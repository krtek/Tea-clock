SOUND = true
CANCEL_TIMEOUT = 10000
total_time = 0
window.teas = [
		name: "white"
		title: "Bílý čaj"
		temp: "65-70 °C"
		time: 90
	,
		name: "yellow"
		title: "Žlutý čaj"
		temp: "70-75 °C"
		time: 90
	,
		name: "green"
		title: "Zelený čaj"
		temp: "75-80 °C"
		time: 90
	,
		name: "oolong"
		title: "Čaj oolong"
		temp: "80-85 °C"
		time: 150
	,
		name: "black"
		title: "Černý čaj"
		temp: "99 °C"
		time: 150
	,
		name: "herbal"
		title: "Bylinkový čaj"
		temp: "99 °C"
		time: 300
]


window.getTea = (name) -> 
	for tea in teas
		if (tea.name == name)
			return tea
		

window.createRadios = () ->
	for tea in teas
		$("<li><label><input type='radio' name='time' value='#{tea.name}'><span> #{tea.title} </span></label></li>").appendTo($('#radios'))
		$('input:radio[name=time]')[0].checked = true

window.startTimer = (seconds, btn) ->   
  window.btn = btn
  permission = window.webkitNotifications.checkPermission()
  time = 1000 * seconds
  total_time = time
  console.log("Setting timeout for #{time}")  
  #setTimeout("onTimeout()", time)
  setTimeout("onTick()", 1000)
  if (permission != 0) 
    window.webkitNotifications.requestPermission(startTimer(minutes))


window.onTick = () -> 
  total_time = total_time - 1000  
  window.btn.html(formatMillis(total_time))
  if total_time >= 0
    setTimeout("onTick()", 1000)
  else 
    setTimeout("onTimeout()", 0)
    
window.formatMillis = (millis) -> 
  secs = millis/1000
  minutes = Math.floor(secs/60)
  secs_remainder = secs - (minutes * 60) 
  if (secs_remainder) < 10
    secs_remainder = "0" + secs_remainder
  return minutes + ":" + secs_remainder


window.onTimeout = () ->
  permission = window.webkitNotifications.checkPermission()
  console.log("Permission: #{permission}")
  if (permission == 0) 
    displayNotification()	
  else 
    console.log("Průšvih - nemám permission!")	
  $('#btn-run').button('reset')
  enable()


window.onSliderChange = (evt, ui) -> 
  time = ui.value * 1000
  $('#teaTime').html(formatMillis(time))

  
window.displayNotification = () -> 
  permission = window.webkitNotifications.checkPermission()
  console.log("Permission: #{permission}")
  window.popup = window.webkitNotifications.createHTMLNotification("popup.html")
  popup.show()
  setTimeout("popup.cancel()", CANCEL_TIMEOUT)

window.disableGroup = (group) -> 
  for item in group	
    item.disabled = true

window.enableGroup = (group) ->
  for item in group	
    item.disabled = false

window.updateInfoPanel = (tea) ->
	$('#teaName').button().html(tea.title)
	$('#teaTime').button().html(window.formatMillis(tea.time * 1000))
	$('#teaTemp').button().html(tea.temp)

  
window.ding = (mp3) -> 
  snd = new Audio(mp3)
  if SOUND 
    snd.play()
  
  
  
  
  