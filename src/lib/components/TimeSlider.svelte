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
        -webkit-appearance: none;
        appearance: none;
        width: 100%;
        height: 36px;
        background: transparent;
        cursor: pointer;
    }

    input[type="range"]::-webkit-slider-runnable-track {
        height: 10px;
        border-radius: 999px;
        background: var(--ceramic);
    }

    input[type="range"]::-webkit-slider-thumb {
        -webkit-appearance: none;
        appearance: none;
        box-sizing: border-box;
        width: 30px;
        height: 30px;
        margin-top: -10px;
        border-radius: 50%;
        border: 3px solid var(--paper);
        background: var(--matcha);
        box-shadow: 0 1px 3px rgba(43, 36, 32, 0.3);
        cursor: pointer;
    }

    input[type="range"]::-moz-range-track {
        height: 10px;
        border-radius: 999px;
        background: var(--ceramic);
    }

    input[type="range"]::-moz-range-thumb {
        box-sizing: border-box;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        border: 3px solid var(--paper);
        background: var(--matcha);
        box-shadow: 0 1px 3px rgba(43, 36, 32, 0.3);
        cursor: pointer;
    }
</style>
