<script>
    import { onMount } from 'svelte'

    let deferredPrompt = $state(null)
    let installed = $state(window.matchMedia('(display-mode: standalone)').matches || navigator.standalone === true)
    const isIOS = /iphone|ipad|ipod/i.test(navigator.userAgent)

    onMount(() => {
        const onBeforeInstall = (e) => {
            e.preventDefault()
            deferredPrompt = e
        }
        const onInstalled = () => {
            installed = true
            deferredPrompt = null
        }
        window.addEventListener('beforeinstallprompt', onBeforeInstall)
        window.addEventListener('appinstalled', onInstalled)
        return () => {
            window.removeEventListener('beforeinstallprompt', onBeforeInstall)
            window.removeEventListener('appinstalled', onInstalled)
        }
    })

    async function install() {
        deferredPrompt.prompt()
        await deferredPrompt.userChoice
        deferredPrompt = null
    }
</script>

{#if !installed && (isIOS || deferredPrompt)}
    <footer class="install">
        {#if deferredPrompt}
            <button type="button" onclick={install}>Add to home screen</button>
        {:else}
            <p>Add Tea-clock to your home screen: tap <strong>Share</strong>, then "Add to Home Screen".</p>
        {/if}
    </footer>
{/if}

<style>
    .install {
        display: none;
    }

    @media (max-width: 640px) {
        .install {
            display: flex;
            justify-content: center;
            margin-top: 24px;
            padding-top: 16px;
            border-top: 1px solid var(--ceramic);
        }
    }

    p {
        margin: 0;
        font-size: 0.85rem;
        text-align: center;
        opacity: 0.75;
    }

    button {
        padding: 8px 18px;
        border: 1.5px solid var(--ceramic);
        border-radius: 999px;
        background: var(--paper);
        color: var(--ink);
        font-size: 0.9rem;
        font-weight: 500;
        cursor: pointer;
    }
</style>
