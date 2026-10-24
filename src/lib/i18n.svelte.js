const SUPPORTED_LOCALES = ["cs", "de", "en", "sk", "sq"]

export const dictionary = $state({ entries: [] })

function detectLocale() {
    const lang = (navigator.language || "en").slice(0, 2).toLowerCase()
    return SUPPORTED_LOCALES.includes(lang) ? lang : "en"
}

export async function loadLocale() {
    const locale = detectLocale()
    const res = await fetch(`/i18n/resources-locale.js.${locale}`)
    dictionary.entries = res.ok ? await res.json() : await (await fetch('/i18n/resources-locale.js.en')).json()
}

export function t(key) {
    return dictionary.entries.find((entry) => entry.key === key)?.value ?? ''
}
