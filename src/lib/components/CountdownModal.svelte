<script>
    import { t } from '../i18n.svelte.js'
    import { formatTime } from '../utils.js'
    import { display } from '../notification.js'

    let { open = $bindable(false), teaTitle, time } = $props()

    const RADIUS = 90
    const CIRCUMFERENCE = 2 * Math.PI * RADIUS

    let actualTime = $state(0)
    let progress = $derived(time > 0 ? actualTime / time : 0)
    let dashOffset = $derived(CIRCUMFERENCE * (1 - progress))

    function tick() {
        actualTime -= 1
        if (actualTime <= 0) {
            open = false
            display(t('_AppTitle_'), t('_NotificationMessage_'))
        }
    }

    // Starts/stops the interval; must not itself read actualTime, or every
    // tick's write would re-trigger this effect and reset the countdown.
    $effect(() => {
        if (!open) return
        actualTime = time
        const intervalId = setInterval(tick, 1000)
        return () => clearInterval(intervalId)
    })

    // Reflects the ticking actualTime in the title; App.svelte resets the
    // title back to _AppTitle_ once the modal closes.
    $effect(() => {
        if (open) document.title = `[${formatTime(actualTime)}] ${t('_AppTitle_')}`
    })
</script>

{#if open}
    <div class="countdown" role="dialog" aria-modal="true" aria-label={t(teaTitle)}>
        <h2>{t(teaTitle)}</h2>
        <div class="ring">
            <svg viewBox="0 0 200 200">
                <circle class="track" cx="100" cy="100" r={RADIUS} />
                <circle
                    class="progress"
                    cx="100"
                    cy="100"
                    r={RADIUS}
                    stroke-dasharray={CIRCUMFERENCE}
                    stroke-dashoffset={dashOffset}
                />
            </svg>
            <span class="ring-time">{formatTime(actualTime)}</span>
        </div>
        <button type="button" class="cancel" onclick={() => (open = false)}>{t('_ResetButtonLabel_')}</button>
    </div>
{/if}

<style>
    .countdown {
        position: fixed;
        inset: 0;
        z-index: 100;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 32px;
        padding: 24px;
        background: var(--cream);
    }

    h2 {
        margin: 0;
        font-size: 1.5rem;
        font-weight: 600;
    }

    .ring {
        position: relative;
        width: min(70vw, 260px);
        aspect-ratio: 1;
    }

    svg {
        width: 100%;
        height: 100%;
        transform: rotate(-90deg);
    }

    circle {
        fill: none;
        stroke-width: 14;
    }

    .track {
        stroke: var(--ceramic);
        opacity: 0.35;
    }

    .progress {
        stroke: var(--amber);
        stroke-linecap: round;
        transition: stroke-dashoffset 1s linear;
    }

    .ring-time {
        position: absolute;
        inset: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2.5rem;
        font-weight: 700;
        font-variant-numeric: tabular-nums;
    }

    .cancel {
        padding: 14px 32px;
        border: none;
        border-radius: 999px;
        background: var(--ink);
        color: var(--paper);
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
    }
</style>
