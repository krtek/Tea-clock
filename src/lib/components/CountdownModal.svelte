<script>
    import { t } from '../i18n.svelte.js'
    import { formatTime } from '../utils.js'
    import { display } from '../notification.js'

    let { open = $bindable(false), teaTitle, time } = $props()

    let actualTime = $state(0)

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
    <div class="modal-backdrop fade in"></div>
    <div class="modal fade in" style="display:block" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" onclick={() => (open = false)}>&times;</button>
                    <h3>{t(teaTitle)}</h3>
                </div>
                <div class="modal-body">
                    <div style="text-align: center;"><h1>{formatTime(actualTime)}</h1></div>
                    <div class="progress">
                        <div class="progress-bar" style="width: {actualTime / (time / 100)}%" id="countdownBar"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary btn-lg" id="btn-reset" onclick={() => (open = false)}>
                        <i class="glyphicon glyphicon-repeat icon-white"></i>
                        <span>{t('_ResetButtonLabel_')}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
{/if}
