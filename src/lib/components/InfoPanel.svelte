<script>
    import { teas, degrees } from '../teas.js'
    import { selection } from '../selection.svelte.js'
    import { t } from '../i18n.svelte.js'
    import { formatTime, convertTemp } from '../utils.js'

    let tea = $derived(teas.find((x) => x.name === selection.tea))
    let degree = $derived(degrees.find((x) => x.name === selection.degree))
    let displayTime = $derived(selection.timer || tea.time)
    let displayTemp = $derived(convertTemp(degree, tea.temp))
</script>

<div class="clearfix">
    <img src="/img/icon_pruhledna.png" alt="" /><br /><br />
</div>
<div class="clearfix">
    <span class="btn btn-default btn-lg" id="teaName">{t(tea.title)}</span>
</div>
<br /><br />
<div class="clearfix">
    <span class="btn btn-default btn-lg">{formatTime(displayTime)}</span><br />
    <small>{t('_TimeTooltip_')}</small>
</div>
<br /><br />
<div class="clearfix">
    <span class="btn btn-default btn-lg">{displayTemp} °{degree.symbol}</span><br />
    <small>{t('_TemperatureTooltip_')}</small>
</div>
