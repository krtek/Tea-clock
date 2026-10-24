<script>
    import { onMount } from 'svelte'
    import { selection, init as initSelection, store as storeSelection } from './lib/selection.svelte.js'
    import { teas, degrees } from './lib/teas.js'
    import { t, loadLocale } from './lib/i18n.svelte.js'
    import { supported, checkPermission } from './lib/notification.js'
    import { trackStart } from './lib/analytics.js'
    import { convertTemp, formatTime } from './lib/utils.js'
    import TeaSelector from './lib/components/TeaSelector.svelte'
    import TimeSlider from './lib/components/TimeSlider.svelte'
    import DegreeButtons from './lib/components/DegreeButtons.svelte'
    import CountdownModal from './lib/components/CountdownModal.svelte'
    import InstallFooter from './lib/components/InstallFooter.svelte'

    onMount(() => {
        initSelection()
        loadLocale()
    })

    let tea = $derived(teas.find((x) => x.name === selection.tea))
    let degree = $derived(degrees.find((x) => x.name === selection.degree))
    let temp = $derived(convertTemp(degree, tea.temp))

    let modalOpen = $state(false)
    let countdown = $state({ teaTitle: '', time: 0 })

    $effect(() => {
        if (!modalOpen) document.title = t('_AppTitle_')
    })

    function steep() {
        checkPermission()
        storeSelection()
        trackStart(selection.tea, selection.degree, selection.timer)
        countdown = { teaTitle: tea.title, time: selection.timer }
        modalOpen = true
    }
</script>

<div class="page">
    <header>
        <img src="/img/logo.png" alt="" class="logo" />
        <h1>{t('_Title_')}</h1>
        <p class="tagline">{t('_SubTitle_')}</p>
    </header>

    {#if !supported()}
        <div class="banner">
            <strong>Modern browser required.</strong> Tea-clock needs desktop notifications, supported in Chrome,
            Safari and Firefox.
        </div>
    {/if}

    <main>
        <section class="field">
            <span class="field-label">{t('_TeaLabel_')}</span>
            <TeaSelector />
        </section>

        <section class="field">
            <div class="field-row">
                <span class="field-label">{t('_TimeLabel_')}</span>
                <span class="field-value">{formatTime(selection.timer)}</span>
            </div>
            <TimeSlider />
        </section>

        <section class="field">
            <div class="field-row control-row">
                <DegreeButtons />
                <span class="field-value">{temp}°{degree.symbol}</span>
            </div>
        </section>

        <button type="button" class="steep" onclick={steep}>{t('_SteepButtonLabel_')}</button>
    </main>

    <InstallFooter />
</div>

<CountdownModal bind:open={modalOpen} teaTitle={countdown.teaTitle} time={countdown.time} />

<style>
    .page {
        max-width: 420px;
        margin: 0 auto;
        padding: 32px 20px 48px;
    }

    header {
        text-align: center;
        margin-bottom: 24px;
    }

    .logo {
        width: 96px;
        height: auto;
        margin-bottom: 8px;
    }

    h1 {
        margin: 0;
        font-size: 1.75rem;
        font-weight: 700;
    }

    .tagline {
        margin: 4px 0 0;
        color: var(--ink);
        opacity: 0.6;
        font-size: 0.95rem;
    }

    .banner {
        background: var(--paper);
        border: 1.5px solid var(--amber);
        border-radius: 12px;
        padding: 12px 16px;
        font-size: 0.9rem;
        margin-bottom: 20px;
    }

    main {
        display: flex;
        flex-direction: column;
        gap: 24px;
    }

    .field {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .field-row {
        display: flex;
        justify-content: space-between;
        align-items: baseline;
    }

    .field-row.control-row {
        align-items: center;
    }

    .field-label {
        font-weight: 500;
        opacity: 0.7;
    }

    .field-value {
        font-size: 1.25rem;
        font-weight: 700;
        font-variant-numeric: tabular-nums;
    }

    .steep {
        padding: 16px;
        border: none;
        border-radius: 999px;
        background: var(--matcha);
        color: var(--paper);
        font-size: 1.1rem;
        font-weight: 700;
        cursor: pointer;
        margin-top: 8px;
        transition: background 0.15s;
    }

    .steep:hover {
        background: var(--matcha-dark);
    }
</style>
