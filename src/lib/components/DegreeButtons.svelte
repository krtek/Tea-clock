<script>
    import { degrees } from '../teas.js'
    import { selection } from '../selection.svelte.js'
</script>

<div class="btn-group controls">
    {#each degrees as degree}
        <button
            type="button"
            class="btn btn-default"
            class:active={selection.degree === degree.name}
            onclick={() => (selection.degree = degree.name)}
        >{degree.title}</button>
    {/each}
</div>
