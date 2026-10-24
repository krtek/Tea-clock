<script>
    import { selection } from '../selection.svelte.js'
</script>

<input
    type="range"
    min="1"
    max="659"
    step="1"
    bind:value={selection.timer}
    aria-label="Steep time"
/>

<style>
    input[type="range"] {
        width: 100%;
        accent-color: var(--matcha);
        height: 6px;
    }
</style>
