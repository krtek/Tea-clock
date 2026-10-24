export function formatTime(secs) {
    const minutes = Math.floor(secs / 60)
    let secsRemainder = secs - minutes * 60
    if (secsRemainder < 10) secsRemainder = "0" + secsRemainder
    return minutes + ":" + secsRemainder
}

export function convertTemp(degree, temperature) {
    const convert = (tempString) => Math.round(degree.formula(parseInt(tempString)))

    const tempIntervPos = temperature.search('-')
    let convertedTemp
    if (degree.symbol !== 'C') {
        convertedTemp = tempIntervPos > 0
            ? convert(temperature.substring(0, tempIntervPos)) + ' - ' + convert(temperature.substring(tempIntervPos + 1))
            : convert(temperature)
    } else {
        convertedTemp = temperature
    }

    return convertedTemp.toString()
}
