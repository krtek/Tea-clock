SOUND = true
CANCEL_TIMEOUT = 10000
CHOSEN_TEA = "chosen_tea"
CUSTOM_TIMER = "custom_timer"
CHOSEN_DEGREE = "chosen_degree"

@module = angular.module('tea', [])

module.directive('slider', ($timeout) ->
   {
    restrict: 'E',
    link: ($scope, $element, $attrs) ->
      $element.slider({
        min: 1,
        max: 659,
        value: $scope.time,
        slide: (event, ui) ->
          $scope.setTime(ui.value)
          if !$scope.$$phase
            $scope.$apply()
        change: (event, ui) ->
          $scope.setTime(ui.value)
          if !$scope.$$phase
            $scope.$apply()
        })
      $scope.$watch('time', ->
        $element.slider({ value: $scope.time })
      )  
    }
)

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
  selection = {
    tea: window.teas[0].name,
    degree: window.degrees[0].name
  }

  this.storeSelection = (newSelection) ->
    selection = newSelection
    localStorage[CHOSEN_TEA] = selection.tea
    localStorage[CUSTOM_TIMER] = selection.timer
    localStorage[CHOSEN_DEGREE] = selection.degree.name

  this.getSelection = () ->
    return selection

  this.setSelection = (selection) ->
    $rootScope.$broadcast('$teaSelected', selection)

  this.init = () ->
    if localStorage[CHOSEN_TEA]
      #This might not be initialized
      degs = 'celsius'
      if localStorage[CHOSEN_DEGREE]
          degs = localStorage[CHOSEN_DEGREE]
      selection = {
        tea: localStorage[CHOSEN_TEA]
        degree: degs
        timer: localStorage[CUSTOM_TIMER]
      }
])
module.service('localize', ['$rootScope', '$locale', '$http', '$filter', ($rootScope, $locale, $http, $filter) ->
  self = this
  this.dictionary = []
  this.resourceFileLoaded = false
  self.dictionary = ''

  this.successCallback = (data) ->
    self.dictionary = data
    this.resourceFileLoaded = true;
    $rootScope.$broadcast('localizeResourcesUpdates')

  this.initLocalizedResources = () ->
    url = 'i18n/resources-locale.js'

    $http({ method:"GET", url:url, cache:false })
      .success(this.successCallback).error( () ->
        url = 'i18n/resources-locale.js.en'
        $http({ method:"GET", url:url, cache:false })
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

])
module.run((teaSelection, localize) ->
  localize.initLocalizedResources()
  teaSelection.init()
)

#Controllers
@SliderController = ($scope, teaSelection) ->
  self = this

  $scope.$on('$teaSelected', (evt, selection) ->
    self.setFromSelection(selection)
  )

  this.setFromSelection = (selection) ->
    $scope.time = selection.timer
    $scope.displayTime = $scope.time

  $scope.setTime = (time) ->
    currentSelection = teaSelection.getSelection()
    currentSelection.timer = time
    teaSelection.setSelection(currentSelection)

SliderController.$inject= ['$scope', 'teaSelection']


@ControlPanelController = ($scope, $timeout, teaSelection, localize) ->
  self = this

  $scope.radio = {index: 0}
  $scope.teas = window.teas
  $scope.degrees = window.degrees

  $scope.$on('$teaSelected', (evt, selection) ->
    self.setFromSelection(selection)
  )

  this.setFromSelection = (selection) ->
    if selection.tea
      for tea in window.teas
        if tea.name == selection.tea
          $scope.tea = tea
          $scope.tea.checked = true
    
    if selection.degree
      for degree in window.degrees
        if degree.name == selection.degree
          $scope.chosenDegree = degree

    $scope.time = selection.timer || $scope.tea.time

  this.setFromSelection(teaSelection.getSelection())

  $scope.setTea = (tea) ->
      currentSelection = teaSelection.getSelection()
      currentSelection.tea = tea.name
      currentSelection.timer = tea.time
      teaSelection.setSelection(currentSelection)

  $scope.setDegree = (degree) ->
      currentSelection = teaSelection.getSelection()
      currentSelection.degree = degree.name
      currentSelection.timer = $scope.time
      teaSelection.setSelection(currentSelection)

  $scope.start = () ->
    permission = window.webkitNotifications.checkPermission()
    if permission != 0
      window.webkitNotifications.requestPermission($scope.onTimerStart)
    else
      $scope.onTimerStart()

  $scope.onTimerStart = () ->
    console.log("Starting timer for: " + $scope.time)

    teaSelection.storeSelection(selection = {
      tea: $scope.tea.name
      degree: $scope.chosenDegree
      timer: $scope.time
    })
    $scope.displayName = $scope.tea.title
    $scope.actualTime = $scope.time
    $scope.timer = true
    if (window.webkitNotifications.checkPermission() != 0)
      $("#notification_disabled").show()
      return

    $('#countdownModal').modal()
    $('#countdownModal').on('hidden', ->
      $scope.timer = false)

    #Google Analytics
    Utils.gaTrack(localStorage[CHOSEN_TEA], $scope.chosenDegree, $scope.time)

    $timeout($scope.onTick, 1000)

  $scope.onTick = () ->
    $scope.actualTime -= 1
    if ($scope.timer && $scope.actualTime >= 0)
      $timeout($scope.onTick, 1000)
    else
      $('#countdownModal').modal("hide")
      #Display notification only if timer enabled!
      if $scope.timer
        Utils.displayNotification(localize.getLocalizedString('_AppTitle_'), localize.getLocalizedString('_NotificationMessage_'))

ControlPanelController.$inject= ['$scope', '$timeout', 'teaSelection', 'localize']


@InfoPanelController = ($scope, teaSelection) ->
  self = this

  $scope.$on('$teaSelected', (evt, selection) ->
    self.setFromSelection(selection)
  )

  this.setFromSelection = (selection) ->
    if selection.tea
      for item in window.teas
        if item.name == selection.tea
          tea = item

    if selection.degree
      for degree in window.degrees
        if degree.name == selection.degree
          $scope.chosenDegree = degree

    $scope.displayName = tea.title
    $scope.time = selection.timer || tea.time
    $scope.displayTime = $scope.time
    $scope.displayTemp = Utils.convertTemp($scope.chosenDegree, tea.temp)


  this.setFromSelection(teaSelection.getSelection())

InfoPanelController.$inject = ['$scope', 'teaSelection']

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
        temp2 = temperature.substring(tempIntervPos+1)
        convertedTemp = convert(temp1, degree) + ' - ' + convert(temp2, degree)
      else convertedTemp = convert(temperature, degree)
    else convertedTemp = temperature

    return convertedTemp.toString()

  Utils.displayNotification = (title, message) ->
    permission = window.webkitNotifications.checkPermission()
    console.log("Permission: #{permission}")
    window.popup = window.webkitNotifications.createNotification("img/icon.png",
    title,
    message)

    Utils.ding('snd/alarm.mp3', window.popup)
    popup.show()
    setTimeout("popup.cancel()", CANCEL_TIMEOUT)

  Utils.ding = (mp3, popup) ->
    snd = new Audio(mp3)
    if SOUND
      snd.play()
      ###
       stop playing alert sound when notification popup is closed
       (synchronized with notification popup through CANCEL_TIMEOUT
       constant which is same in both cases)
       ###
      pauseAudio = -> snd.pause()
      popup.onclose = pauseAudio
      popup.onclick = pauseAudio
      setTimeout(pauseAudio, CANCEL_TIMEOUT)

  Utils.gaTrack = (tea, degree, time) ->
    _gaq.push(['_trackEvent', 'start-tea', tea])
    _gaq.push(['_trackEvent', 'degree', degree])
    _gaq.push(['_trackEvent', 'start-time', time])


#Initialization code
$(document).ready ->
  #check webkit notification
  if (!window.webkitNotifications)
    $("#notification_not_found").show()
    $('#btn-run').toggleClass('disabled')
  #popovers
  $("[rel='tooltip']").tooltip();
