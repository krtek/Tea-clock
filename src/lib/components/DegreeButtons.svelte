<script>
    import { degrees } from '../teas.js'
    import { selection } from '../selection.svelte.js'
</script>

<div class="segmented">
    {#each degrees as degree}
        <label class="segment" class:selected={selection.degree === degree.name}>
            <input type="radio" bind:group={selection.degree} value={degree.name} />
            {degree.symbol}
        </label>
    {/each}
</div>

<style>
    .segmented {
        display: inline-flex;
        border: 1.5px solid var(--ceramic);
        border-radius: 999px;
        overflow: hidden;
    }

    .segment {
        position: relative;
        padding: 8px 20px;
        font-weight: 600;
        color: var(--ink);
        cursor: pointer;
        transition: background 0.15s, color 0.15s;
    }

    .segment.selected {
        background: var(--matcha);
        color: var(--paper);
    }

    .segment:has(input:focus-visible) {
        outline: 2px solid var(--matcha);
        outline-offset: 2px;
    }

    .segment input {
        position: absolute;
        width: 1px;
        height: 1px;
        opacity: 0;
    }
</style>
