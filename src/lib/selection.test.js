import { describe, it, expect, beforeEach } from 'vitest'
import { selection, store, init } from './selection.svelte.js'

describe('selection', () => {
    beforeEach(() => {
        localStorage.clear()
        selection.tea = 'white'
        selection.degree = 'celsius'
        selection.timer = undefined
    })

    it('leaves the current selection untouched when storage is empty', () => {
        init()
        expect(selection.tea).toEqual('white')
        expect(selection.degree).toEqual('celsius')
    })

    it('stores selection to local storage', () => {
        selection.tea = 'black'
        selection.degree = 'fahrenheit'
        selection.timer = 666
        store()

        expect(localStorage.getItem('chosen_tea')).toEqual('black')
        expect(localStorage.getItem('custom_timer')).toEqual('666')
        expect(localStorage.getItem('chosen_degree')).toEqual('fahrenheit')
    })

    it('upgrades a user with no chosen_degree in storage to celsius', () => {
        localStorage.setItem('chosen_tea', 'white')
        localStorage.setItem('custom_timer', '10')

        init()

        expect(selection.tea).toEqual('white')
        expect(selection.timer).toEqual('10')
        expect(selection.degree).toEqual('celsius')
    })

    it('restores a normal user selection from storage', () => {
        localStorage.setItem('chosen_tea', 'oolong')
        localStorage.setItem('custom_timer', '10')
        localStorage.setItem('chosen_degree', 'fahrenheit')

        init()

        expect(selection.tea).toEqual('oolong')
        expect(selection.timer).toEqual('10')
        expect(selection.degree).toEqual('fahrenheit')
    })
})
