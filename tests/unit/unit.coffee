describe('service', () ->
    beforeEach(angular.mock.module('tea', () ->
    ))

    beforeEach(() ->
        store = {}
        spyOn(localStorage, 'getItem').andCallFake((key) ->
            #console.log("Returning #{key}=#{store[key]}")
            return store[key]
        )
        spyOn(localStorage, 'setItem').andCallFake((key, value) ->
            #console.log("Setting #{key}=#{value}")
            return store[key] = value + '';
        )
        spyOn(localStorage, "clear").andCallFake(() ->
            store = {}
        )
    )

    describe('Tea storage service test', () ->
        it('Check default values', inject((teaSelection) ->
            selection = teaSelection.getSelection()
            expect(selection.tea).toEqual('white')
            expect(selection.degree).toEqual('celsius')
        ))
        it('Check if values are stored to local storage', inject((teaSelection) ->
            selection = teaSelection.getSelection()
            selection.tea = 'black'
            selection.degree = 'kelvin'
            selection.timer = 666
            teaSelection.storeSelection(selection)

            expect(localStorage.getItem('chosen_tea')).toEqual('black')
            expect(localStorage.getItem('custom_timer')).toEqual('666')
            expect(localStorage.getItem('chosen_degree')).toEqual('kelvin')
        ))

    )
)



