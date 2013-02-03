SOUND = true
CANCEL_TIMEOUT = 10000
CHOSEN_TEA = "chosen_tea"
CUSTOM_TIMER = "custom_timer"

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

  # init display
  Utils.updateInfoPanel($scope, chosenTea)

  #check if there is stored time
  $scope.time = localStorage[CUSTOM_TIMER]
  if !$scope.time
    $scope.time = chosenTea.time

  $scope.teas = window.teas


  # Update displayed tea name etc.
  $scope.updateDisplay = () ->
    tea = $scope.teas[$scope.radio.index]
    Utils.updateInfoPanel($scope, tea)

  $scope.start = () ->
    permission = window.webkitNotifications.checkPermission()
    if permission != 0
      window.webkitNotifications.requestPermission($scope.onTimerStart)
    else
      $scope.onTimerStart()

  $scope.onTimerStart = () ->
    console.log("Starting timer for: " + $scope.time)
    Utils.store($scope.teas[$scope.radio.index].name, $scope.time)

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

  Utils.store = (name, time) ->
    localStorage[CHOSEN_TEA] = name
    localStorage[CUSTOM_TIMER] = time

  #Updates info panel with new tea
  Utils.updateInfoPanel = ($scope, tea) ->
    $scope.displayTime = tea.time
    $scope.displayTemp = tea.temp
    $scope.displayName = tea.title
    $scope.time = tea.time

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

