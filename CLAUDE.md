# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Tea-clock: a tea-steeping timer, running as a static web app ([tea-clock.com](http://tea-clock.com), deployed on Vercel) and listed on the Chrome Web Store (pointing at the live site). Svelte 5 + Vite, rewritten from the original CoffeeScript/AngularJS/Grunt/Bower stack.

## Setup / build / tests

```
npm install
npm run dev       # Vite dev server
npm run build     # production build to dist/
npm run preview   # serve the production build locally
npm test          # vitest run
```

No test watch mode script is defined; use `npx vitest` directly for watch mode.

## Architecture

- **`src/lib/teas.js`** — static data: `teas` (7 types, each with an i18n title key, brew time in seconds, temp string) and `degrees` (7 temperature units, each with a `formula(celsiusVal)`). Edit this file to add a tea or a temperature scale.
- **`src/lib/selection.svelte.js`** — the single shared reactive state: `selection` (`$state` object: `tea`, `degree`, `timer`), `store()` persists it to `localStorage` (`chosen_tea`, `custom_timer`, `chosen_degree`, only called on "Steep"), `init()` restores it on boot (defaults to celsius if `chosen_degree` is missing, for old stored data). Any component that imports `selection` and mutates it is automatically in sync with every other component — this is what replaced the old Angular `$rootScope.$broadcast('$teaSelected', ...)` pattern.
- **`src/lib/i18n.svelte.js`** — loads `/i18n/resources-locale.js.<lang>` (JSON array of `{key, value}`) based on `navigator.language`, falling back to `.en`. `t(key)` resolves a `_SomeKey_`-style string. The locale files themselves live in `public/i18n/` and are hand-edited directly (no translation tooling) — this mechanism replaces Apache's old `MultiViews` content negotiation (see `.htaccess` in git history), since Vercel's static hosting doesn't do server-side language negotiation.
- **`src/lib/notification.js`** — wraps the browser Notification API + an alarm sound (`public/snd/alarm.mp3`), with a timeout to auto-dismiss.
- **`src/lib/utils.js`** — `formatTime`/`convertTemp`, pure functions using the `degrees` formulas from `teas.js`.
- **`src/lib/analytics.js`** — thin wrapper around `@vercel/analytics`' `track()`, called once on "Steep".
- **`src/lib/components/`** — `TeaSelector`, `TimeSlider` (a native `<input type="range">`, no slider dependency), `DegreeButtons`, `CountdownModal`, `InfoPanel`. All read/write the shared `selection` state directly rather than receiving it as props.
- **`src/App.svelte`** — root layout; owns the countdown modal's open/snapshot state and the "Steep" click handler (checks notification permission, persists selection, starts the countdown).

### Countdown timer gotcha

`CountdownModal.svelte` uses two separate `$effect`s: one starts/stops the `setInterval` and must only *read* the `open`/`time` props, never `actualTime`; a second, separate effect reads `actualTime` to update `document.title`. Combining them into one effect creates a self-triggering loop — the effect would depend on `actualTime` (because it reads it) while also resetting `actualTime` on every run, so the countdown never advances. Keep the write-effect and the read-effect apart.

## Notes

- No `vercel.json`; Vercel auto-detects the Vite preset and deploys `dist/`.
- The Chrome Web Store listing just points at the live URL — it's independent of anything in this repo.
