import { teas, degrees } from './teas.js'

const CHOSEN_TEA = "chosen_tea"
const CUSTOM_TIMER = "custom_timer"
const CHOSEN_DEGREE = "chosen_degree"

export const selection = $state({
    tea: teas[0].name,
    degree: degrees[0].name,
    timer: teas[0].time,
})

export function store() {
    localStorage.setItem(CHOSEN_TEA, selection.tea)
    localStorage.setItem(CUSTOM_TIMER, selection.timer)
    localStorage.setItem(CHOSEN_DEGREE, selection.degree)
}

export function init() {
    const tea = localStorage.getItem(CHOSEN_TEA)
    if (tea) {
        selection.tea = tea
        selection.degree = localStorage.getItem(CHOSEN_DEGREE) || "celsius"
        selection.timer = localStorage.getItem(CUSTOM_TIMER)
    }
}
