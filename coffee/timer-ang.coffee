SOUND = true
CANCEL_TIMEOUT = 10000
CHOSEN_TEA = "chosen_tea"
CUSTOM_TIMER = "custom_timer"
CHOSEN_DEGREE = "chosen_degree"

@module = angular.module('tea', []);

#directives
module.directive('slider', ($timeout) ->
   {
    restrict: 'E',
    link: ($scope, $element, $attrs) ->
      slider = $element.slider({
      min: 1,
      max: 659,
      value: $scope.time,
      slide: (event, ui) ->
        onSliderChange(event, ui, $scope)
      change: (event, ui) ->
        onSliderChange(event, ui, $scope)
      })
      $scope.$watch('time', ->
        slider.slider({ value: $scope.time })
      )
    })

module.directive('degrees', () ->
  {
    restrict: 'A',
    template: "<button type='button' class='btn' "+
                        "ng-repeat='degree in degrees' "+
                        "ng-class='{active: degree.name == chosenDegree.name}'"+
                        "ng-click='activate(degree)'>{{degree.title}} "+
              "</button>",
    controller: ($scope) -> 
      $scope.activate = (degree) ->
        $scope.chosenDegree = degree
        Utils.convertTemp(degree, $scope.displayTemp)
        $scope.updateDisplay()
    })

module.filter('time', () ->
  (input) ->
    Utils.formatTime(input)
)

#event handlers
@onSliderChange = (event, ui, $scope) ->
  $scope.time = ui.value
  $scope.displayTime = $scope.time

  #$apply only if not already applied
  if !$scope.$$phase
    $scope.$apply()

#Controllers
@TimerController = ($scope, $timeout) ->
  storedTea = localStorage[CHOSEN_TEA]
  $scope.radio = {index: 0}

  chosenTea = window.teas[0]

  if storedTea
    for tea in window.teas
      if tea.name == storedTea
        chosenTea = tea

  chosenTea.checked = true

  storedDegree = localStorage[CHOSEN_DEGREE]
  $scope.chosenDegree = window.degrees[0]

  if storedDegree
    for degree in window.degrees
      if degree.name == storedDegree
        $scope.chosenDegree = degree

  # init display
  Utils.updateInfoPanel($scope, chosenTea, $scope.chosenDegree)

  #check if there is stored time
  $scope.time = localStorage[CUSTOM_TIMER]
  if !$scope.time
    $scope.time = chosenTea.time

  $scope.teas = window.teas

  $scope.degrees = window.degrees

  # Update displayed tea name etc.
  $scope.updateDisplay = () ->
    tea = $scope.teas[$scope.radio.index]
    degree = $scope.degrees[$scope.chosenDegree.name]
    Utils.updateInfoPanel($scope, tea, degree)

  $scope.start = () ->
    permission = window.webkitNotifications.checkPermission()
    if permission != 0
      window.webkitNotifications.requestPermission($scope.onTimerStart)
    else
      $scope.onTimerStart()

  $scope.onTimerStart = () ->
    console.log("Starting timer for: " + $scope.time)
    Utils.store($scope.teas[$scope.radio.index].name, $scope.time, $scope.chosenDegree.name)

    $scope.actualTime = $scope.time
    $scope.timer = true
    if (window.webkitNotifications.checkPermission() != 0)
      $("#notification_disabled").show()
      return

    $('#countdownModal').modal()
    $('#countdownModal').on('hidden', -> $scope.timer = false)

    #Google Analytics
    _gaq.push(['_trackEvent', 'start-time', $scope.time])
    _gaq.push(['_trackEvent', 'start-tea', localStorage[CHOSEN_TEA]])

    $timeout($scope.onTick, 1000)

  $scope.onTick = () ->
    $scope.actualTime -= 1
    if ($scope.timer && $scope.actualTime >= 0)
      $timeout($scope.onTick, 1000)
    else
      $('#countdownModal').modal("hide")
      #Display notification only if timer enabled!
      if $scope.timer
        Utils.displayNotification()

#Utils
class Utils

  Utils.formatTime = (secs) ->
    minutes = Math.floor(secs / 60)
    secs_remainder = secs - (minutes * 60)
    if (secs_remainder) < 10
      secs_remainder = "0" + secs_remainder
    return minutes + ":" + secs_remainder

  Utils.store = (name, time, degree) ->
    localStorage[CHOSEN_TEA] = name
    localStorage[CUSTOM_TIMER] = time
    localStorage[CHOSEN_DEGREE] = degree

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


  #Updates info panel with new tea
  Utils.updateInfoPanel = ($scope, tea) ->
    $scope.displayTime = tea.time
    $scope.displayName = tea.title
    $scope.time = tea.time
    $scope.displayTemp = Utils.convertTemp($scope.chosenDegree, tea.temp)

  Utils.displayNotification = () ->
    permission = window.webkitNotifications.checkPermission()
    console.log("Permission: #{permission}")
    window.popup = window.webkitNotifications.createNotification("img/icon.png",
    window.notificationTemplate.title,
    window.notificationTemplate.body)

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

#Initialization code
$(document).ready ->
  #check webkit notification
  if (!window.webkitNotifications)
    $("#notification_not_found").show()
    $('#btn-run').toggleClass('disabled')
  #popovers
  $("[rel='tooltip']").tooltip();

