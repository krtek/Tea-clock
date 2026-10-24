<script>
    import { teas, PRIMARY_TEA_COUNT } from '../teas.js'
    import { selection } from '../selection.svelte.js'
    import { t } from '../i18n.svelte.js'

    const primary = teas.slice(0, PRIMARY_TEA_COUNT)
    const rest = teas.slice(PRIMARY_TEA_COUNT)

    let expanded = $state(false)

    function select(tea) {
        selection.tea = tea.name
        selection.timer = tea.time
    }
</script>

<div class="tea-grid">
    {#each primary as tea}
        <label class="chip" class:selected={selection.tea === tea.name}>
            <input type="radio" bind:group={selection.tea} value={tea.name} onchange={() => select(tea)} />
            {t(tea.title)}
        </label>
    {/each}
    {#if expanded}
        {#each rest as tea}
            <label class="chip" class:selected={selection.tea === tea.name}>
                <input type="radio" bind:group={selection.tea} value={tea.name} onchange={() => select(tea)} />
                {t(tea.title)}
            </label>
        {/each}
    {/if}
    {#if rest.length > 0}
        <button type="button" class="chip more" onclick={() => (expanded = !expanded)}>
            {expanded ? 'Less' : 'More…'}
        </button>
    {/if}
</div>

<style>
    .tea-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
    }

    .chip {
        position: relative;
        padding: 10px 16px;
        border-radius: 999px;
        border: 1.5px solid var(--ceramic);
        background: var(--paper);
        color: var(--ink);
        font-size: 0.95rem;
        font-weight: 500;
        cursor: pointer;
        white-space: nowrap;
        transition: background 0.15s, border-color 0.15s, color 0.15s;
    }

    .chip.selected {
        background: var(--matcha);
        border-color: var(--matcha);
        color: var(--paper);
    }

    .chip:has(input:focus-visible) {
        outline: 2px solid var(--matcha);
        outline-offset: 2px;
    }

    .chip input {
        position: absolute;
        width: 1px;
        height: 1px;
        opacity: 0;
    }

    .more {
        border-style: dashed;
        color: var(--ink);
        opacity: 0.7;
    }

    .more:hover {
        opacity: 1;
    }
</style>
