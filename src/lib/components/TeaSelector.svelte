<script>
    import { teas } from '../teas.js'
    import { selection } from '../selection.svelte.js'
    import { t } from '../i18n.svelte.js'
</script>

{#each teas as tea}
    <div class="controls">
        <div class="radio">
            <label>
                <input type="radio" bind:group={selection.tea} value={tea.name} onchange={() => (selection.timer = tea.time)} />
                {t(tea.title)}
            </label>
        </div>
    </div>
{/each}
