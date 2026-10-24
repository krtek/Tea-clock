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

- **`src/lib/teas.js`** — static data: `teas` (6 types, each with an i18n title key, brew time in seconds, temp string; the first `PRIMARY_TEA_COUNT` entries are shown by default in `TeaSelector`, the rest behind "More") and `degrees` (celsius/fahrenheit, each with a `formula(celsiusVal)`). Edit this file to add a tea or a temperature scale.
- **`src/lib/selection.svelte.js`** — the single shared reactive state: `selection` (`$state` object: `tea`, `degree`, `timer`), `store()` persists it to `localStorage` (`chosen_tea`, `custom_timer`, `chosen_degree`, only called on "Steep"), `init()` restores it on boot (defaults to celsius if `chosen_degree` is missing, for old stored data). Any component that imports `selection` and mutates it is automatically in sync with every other component — this is what replaced the old Angular `$rootScope.$broadcast('$teaSelected', ...)` pattern.
- **`src/lib/i18n.svelte.js`** — loads `/i18n/resources-locale.js.<lang>` (JSON array of `{key, value}`) based on `navigator.language`, falling back to `.en`. `t(key)` resolves a `_SomeKey_`-style string. The locale files themselves live in `public/i18n/` and are hand-edited directly (no translation tooling) — this mechanism replaces Apache's old `MultiViews` content negotiation (see `.htaccess` in git history), since Vercel's static hosting doesn't do server-side language negotiation.
- **`src/lib/notification.js`** — wraps the browser Notification API + an alarm sound (`public/snd/alarm.mp3`), with a timeout to auto-dismiss.
- **`src/lib/utils.js`** — `formatTime`/`convertTemp`, pure functions using the `degrees` formulas from `teas.js`.
- **`src/lib/analytics.js`** — thin wrapper around `@vercel/analytics`' `track()`, called once on "Steep".
- **`src/lib/components/`** — `TeaSelector` (chip row), `TimeSlider` (a native `<input type="range">`, no slider dependency), `DegreeButtons` (segmented toggle), `CountdownModal` (full-screen takeover with an SVG circular progress ring). All read/write the shared `selection` state directly rather than receiving it as props. There's no separate "info panel" — the single-column layout shows the live tea/time/temp values inline, so one view is both the editor and the summary.
- **`src/lib/components/InstallFooter.svelte`** — "add to home screen" prompt, CSS-hidden above a 640px viewport (`@media (max-width: 640px)`) since installing only makes sense on a phone. On Android/Chrome it captures `beforeinstallprompt` and shows a button that calls `.prompt()`; iOS Safari has no such API, so it instead shows static "tap Share, then Add to Home Screen" instructions. Renders nothing once already installed (`display-mode: standalone` / `navigator.standalone`) or on a platform with neither path available (e.g. desktop).
- **`src/App.svelte`** — root layout; owns the countdown modal's open/snapshot state and the "Steep" click handler (checks notification permission, persists selection, starts the countdown).
- **`src/app.css`** — design tokens (`--cream`, `--paper`, `--ceramic`, `--matcha`, `--amber`, `--ink`) as CSS custom properties on `:root`, plus the self-hosted Figtree font (`@fontsource/figtree`, no Bootstrap/jQuery). Component-specific styles live in each `.svelte` file's scoped `<style>` block.
- **`public/img/`** — the teapot-clock logo, pre-rendered at the sizes each use needs: `logo.png` (256×256, header image), `favicon.png` (48×48), `apple-touch-icon.png` (180×180), `icon-192.png`/`icon-512.png` (PWA manifest icons, `icon-192.png` doubles as the notification icon). To swap the logo, resize the new source into each of these (e.g. `sips -z <size> <size> source.png --out public/img/<name>.png`) rather than pointing multiple uses at one oversized file.

### Countdown timer gotcha

`CountdownModal.svelte` uses two separate `$effect`s: one starts/stops the `setInterval` and must only *read* the `open`/`time` props, never `actualTime`; a second, separate effect reads `actualTime` to update `document.title`. Combining them into one effect creates a self-triggering loop — the effect would depend on `actualTime` (because it reads it) while also resetting `actualTime` on every run, so the countdown never advances. Keep the write-effect and the read-effect apart.

On reaching zero the modal doesn't close itself — it switches to a `finished` ready state (full ring, checkmark, "Close" button) and stays open until the user dismisses it. This is the reliable path: the native `Notification` (`src/lib/notification.js`'s `display()`) is best-effort and silently no-ops without permission, so the in-page dialog — not the OS notification — is what the user can actually count on seeing. The alarm sound (`playAlarm()`/`stopAlarm()`) is likewise decoupled from the native notification's lifecycle so it plays regardless of permission.

Because the modal stays open past zero, `tick()` must `clearInterval(intervalId)` itself the moment `actualTime <= 0` — the `setInterval` only otherwise stops via the start/stop effect's cleanup, which only re-runs when `open` changes, and `open` no longer flips to false at zero. Forgetting this makes `tick()` keep firing every second for as long as the ready dialog is shown, re-triggering the notification and alarm sound on every tick.

Notification permission is requested once, on page load (`App.svelte`'s `onMount`), not on the first "Steep" click — `checkPermission()` is a no-op once permission is already granted or denied, so there's no need to call it again later.

## Notes

- `vercel.json` pins `framework: "vite"`, `buildCommand: "npm run build"`, `outputDirectory: "dist"` explicitly — the Vercel project's dashboard settings predate this rewrite (it was a no-build static site before), and without this file Vercel served the raw repo instead of running the Vite build, producing an unbundled `index.html` (`import { mount } from 'svelte'` as a literal bare specifier, 404s on `/manifest.json`). If deploys ever regress to that symptom again, check this file is still present before anything else.
- The Chrome Web Store listing just points at the live URL — it's independent of anything in this repo.
