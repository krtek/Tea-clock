<script>
    import { selection } from '../selection.svelte.js'
    import { formatTime } from '../utils.js'
</script>

<div class="time-slider">
    <input type="range" min="1" max="659" step="1" bind:value={selection.timer} />
    <span class="time-slider-bubble">{formatTime(selection.timer)}</span>
</div>
