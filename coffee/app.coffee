SOUND = true
CANCEL_TIMEOUT = 10000
CHOSEN_TEA = "chosen_tea"
CUSTOM_TIMER = "custom_timer"
CHOSEN_DEGREE = "chosen_degree"
NOTIFICATION_ID = 'tea clock'

@module = angular.module('tea', ['uiSlider'])

#Filters
module.filter('time', () ->
    (input) ->
        Utils.formatTime(input)
)
module.filter('i18n', ['localize', (localize) ->
    (input) ->
        if input != undefined
            localize.getLocalizedString(input)
])

#Services
module.service('teaSelection', ['$rootScope', ($rootScope) ->
    self = this

    selection = {
        chosen_tea: window.teas[0].name
        chosen_degree: window.degrees[0].name
        custom_timer: null
    }

    this.storeSelection = (newSelection) ->
        selection = newSelection
        chrome.storage.sync.set(selection, () ->
            #Empty callback
        )

    this.getSelection = () ->
        return selection

    this.broadcastSelection = (selection) ->
        $rootScope.$broadcast('$teaSelected', selection)

    this.init = () ->
        chrome.storage.sync.get(selection, (stored) ->
            selection = stored
            self.broadcastSelection(selection)
        )

    return this
])
module.service('localize', ['$rootScope', '$locale', '$http', '$filter', ($rootScope, $locale, $http, $filter) ->
    self = this
    this.dictionary = []
    this.resourceFileLoaded = false
    this.dictionary = ''

    this.successCallback = (data) ->
        self.dictionary = data
        this.resourceFileLoaded = true;
        $rootScope.$broadcast('localizeResourcesUpdates')

    this.initLocalizedResources = () ->
        url = 'i18n/resources-locale.js'

        $http({ method: "GET", url: url, cache: false })
        .success(this.successCallback).error(() ->
            url = 'i18n/resources-locale.js.en'
            $http({ method: "GET", url: url, cache: false })
            .success(this.successCallback)
        )

    this.getLocalizedString = (value) ->
        result = ''

        if this.dictionary != [] && this.dictionary.length > 0
            entry = $filter('filter')(this.dictionary, (element) ->
                return element.key == value
            )[0]
            result = entry.value

        return result

    return this
])

module.service('notification', ['$rootScope', ($rootScope) ->
    self = this
    this.snd = new Audio('snd/alarm.mp3')

    this.init = () ->
        closeListener = (id, byUser) ->
            chrome.notifications.clear(NOTIFICATION_ID, () ->
                #Empty callback
            )
            self.snd.pause()

        chrome.notifications.onClosed.addListener(closeListener)
        chrome.notifications.onClicked.addListener(closeListener)


    this.display = (title, message) ->
        chrome.notifications.create(NOTIFICATION_ID,
        {type: 'basic', title: title, message: message, iconUrl: 'img/icon_pruhledna.png'}, () ->
            if SOUND
                self.snd.play()
        )

    return this
])

module.run((teaSelection, localize, notification) ->
    localize.initLocalizedResources()
    teaSelection.init()
    notification.init()
)

@ControlPanelController = ($scope, $timeout, teaSelection, localize, notification) ->
    self = this

    $scope.teas = window.teas
    $scope.degrees = window.degrees

    $scope.$on('$teaSelected', (evt, selection) ->
        self.setFromSelection(selection)
    )

    this.setFromSelection = (selection) ->
        #Pre-init
        $scope.tea = $scope.teas[0]
        $scope.degree = $scope.degrees[0]

        $scope.currentSelection = selection
        if selection[CHOSEN_TEA]
            for tea in $scope.teas
                if tea.name == selection[CHOSEN_TEA]
                    $scope.tea = tea

        if selection[CHOSEN_DEGREE]
            for degree in $scope.degrees
                if degree.name == selection[CHOSEN_DEGREE]
                    $scope.degree = degree

        #Pass this to another thread to avoid overwriting the $scope.time by setting $scope.tea (see $watch below)
        $timeout(() ->
            if selection[CUSTOM_TIMER] is null
                $scope.time = $scope.tea.time
            else
                $scope.time = selection[CUSTOM_TIMER]

            $scope.displayTime = $scope.time
        , 0)
        $scope.displayTemp = Utils.convertTemp($scope.degree, tea.temp)

    $scope.$watch('tea', (tea) ->
        if tea
            $scope.time = tea.time
            $scope.displayTemp = Utils.convertTemp($scope.degree, $scope.tea.temp)
    )

    $scope.setDegree = (degree) ->
        $scope.degree = degree
        $scope.displayTemp = Utils.convertTemp($scope.degree, $scope.tea.temp)

    $scope.start = () ->
        console.log("Starting timer for: " + $scope.time)
        to_store = {}
        to_store[CHOSEN_TEA] = $scope.tea.name
        to_store[CHOSEN_DEGREE] = $scope.degree.name
        to_store[CUSTOM_TIMER] = $scope.time
        teaSelection.storeSelection(to_store)

        $scope.actualTime = $scope.time
        $scope.timer = true

        $('#countdownModal').modal()
        $('#countdownModal').on('hidden', () ->
            $scope.timer = false
        )

        $timeout($scope.onTick, 1000)

    $scope.onTick = () ->
        $scope.actualTime -= 1
        if ($scope.timer && $scope.actualTime >= 0)
            updateTitle($scope.actualTime)
            $timeout($scope.onTick, 1000)
        else
            $('#countdownModal').modal("hide")
            resetTitle()
            #Display notification only if timer enabled!
            if $scope.timer
                notification.display(localize.getLocalizedString('_AppTitle_'),
                    localize.getLocalizedString('_NotificationMessage_'))

    updateTitle = (time) ->
        document.title = "[#{Utils.formatTime(time)}] " + localize.getLocalizedString('_AppTitle_')

    resetTitle = () ->
        document.title = localize.getLocalizedString('_AppTitle_')

ControlPanelController.$inject = ['$scope', '$timeout', 'teaSelection', 'localize', 'notification']

#Utils
class Utils

    Utils.formatTime = (secs) ->
        minutes = Math.floor(secs / 60)
        secs_remainder = secs - (minutes * 60)
        if (secs_remainder) < 10
            secs_remainder = "0" + secs_remainder
        return minutes + ":" + secs_remainder

    Utils.convertTemp = (degree, temperature) ->
        degreeType = degree.symbol
        tempIntervPos = temperature.search('-')
        convert = (tempString, degree) ->
            val = parseInt(tempString)
            degree.formula(val)

        if degreeType != 'C'
            if tempIntervPos > 0
                temp1 = temperature.substring(0, tempIntervPos)
                temp2 = temperature.substring(tempIntervPos + 1)
                convertedTemp = convert(temp1, degree) + ' - ' + convert(temp2, degree)
            else convertedTemp = convert(temperature, degree)
        else convertedTemp = temperature

        return convertedTemp.toString()

