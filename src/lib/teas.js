// The first PRIMARY_TEA_COUNT entries (teas.js) are shown by default in
// TeaSelector; the rest are behind "More".
export const teas = [
    { name: "black", title: "_BlackTea_", temp: "99", time: 150 },
    { name: "green", title: "_GreenTea_", temp: "75 - 80", time: 90 },
    { name: "fruit", title: "_FruitTea_", temp: "99", time: 300 },
    { name: "white", title: "_WhiteTea_", temp: "65 - 70", time: 90 },
    { name: "yellow", title: "_YellowTea_", temp: "70 - 75", time: 90 },
    { name: "oolong", title: "_OolongTea_", temp: "80 - 85", time: 150 },
]

export const PRIMARY_TEA_COUNT = 3

export const degrees = [
    { name: "celsius", title: "Celsius", symbol: "C", formula: (val) => val },
    { name: "fahrenheit", title: "Fahrenheit", symbol: "F", formula: (val) => val * 9 / 5 + 32 },
]
