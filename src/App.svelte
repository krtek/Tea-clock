<script>
    import { onMount } from 'svelte'
    import { selection, init as initSelection, store as storeSelection } from './lib/selection.svelte.js'
    import { teas } from './lib/teas.js'
    import { t, loadLocale } from './lib/i18n.svelte.js'
    import { supported, checkPermission } from './lib/notification.js'
    import { trackStart } from './lib/analytics.js'
    import TeaSelector from './lib/components/TeaSelector.svelte'
    import TimeSlider from './lib/components/TimeSlider.svelte'
    import DegreeButtons from './lib/components/DegreeButtons.svelte'
    import CountdownModal from './lib/components/CountdownModal.svelte'
    import InfoPanel from './lib/components/InfoPanel.svelte'

    onMount(() => {
        initSelection()
        loadLocale()
    })

    let modalOpen = $state(false)
    let countdown = $state({ teaTitle: '', time: 0 })

    $effect(() => {
        if (!modalOpen) document.title = t('_AppTitle_')
    })

    function steep() {
        checkPermission()
        const tea = teas.find((x) => x.name === selection.tea)
        storeSelection()
        trackStart(selection.tea, selection.degree, selection.timer)
        countdown = { teaTitle: tea.title, time: selection.timer }
        modalOpen = true
    }
</script>

<div class="container">
    <div class="page-header">
        <h1>{t('_Title_')} <small>{t('_SubTitle_')}</small></h1>
    </div>

    {#if !supported()}
        <div class="row">
            <div class="col-md-12">
                <div class="alert alert-danger alert-dismissable">
                    <h4 class="alert-heading">Modern browser required!</h4>
                    This application needs <strong>desktop notifications</strong>, which are currently implemented in
                    <strong>Google Chrome</strong>, <strong>Safari</strong> or <strong>Mozilla Firefox</strong>.
                </div>
            </div>
        </div>
    {/if}

    <div class="row">
        <div class="col-md-8">
            <div class="well">
                <form class="form-horizontal">
                    <fieldset>
                        <legend>{t('_Slogan_')}</legend>
                        <div class="form-group">
                            <span class="control-label">{t('_TeaLabel_')}</span>
                            <TeaSelector />
                        </div>
                        <div class="form-group">
                            <span class="control-label">{t('_TimeLabel_')}</span>
                            <div class="controls">
                                <div class="col-lg-7">
                                    <TimeSlider />
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <span class="control-label">{t('_TemperatureLabel_')}</span>
                            <DegreeButtons />
                        </div>
                    </fieldset>
                    <div class="form-actions">
                        <button class="btn btn-danger btn-lg" type="button" onclick={steep}>
                            <i class="glyphicon glyphicon-time icon-white"></i> {t('_SteepButtonLabel_')}
                        </button>
                    </div>
                </form>
                <CountdownModal bind:open={modalOpen} teaTitle={countdown.teaTitle} time={countdown.time} />
            </div>
        </div>

        <div class="col-md-4" style="text-align:center">
            <div class="well">
                <InfoPanel />
            </div>
        </div>
    </div>
</div>
