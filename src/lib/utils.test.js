import { describe, it, expect } from 'vitest'
import { formatTime, convertTemp } from './utils.js'
import { degrees } from './teas.js'

describe('formatTime', () => {
    it('zero-pads seconds under 10', () => {
        expect(formatTime(0)).toEqual('0:00')
        expect(formatTime(59)).toEqual('0:59')
        expect(formatTime(60)).toEqual('1:00')
        expect(formatTime(605)).toEqual('10:05')
    })
})

describe('convertTemp', () => {
    const celsius = degrees.find((d) => d.name === 'celsius')
    const fahrenheit = degrees.find((d) => d.name === 'fahrenheit')

    it('leaves a single value untouched in celsius', () => {
        expect(convertTemp(celsius, '99')).toEqual('99')
    })

    it('converts a single value to another unit', () => {
        expect(convertTemp(fahrenheit, '99')).toEqual('210.2')
    })

    it('converts each side of a range', () => {
        expect(convertTemp(fahrenheit, '65 - 70')).toEqual('149 - 158')
    })
})
