SOUND = true
CANCEL_TIMEOUT = 10000
CHOSEN_TEA = "chosen_tea"
CUSTOM_TIMER = "custom_timer"
total_time = 0
timer_running = false

window.getTea = (name) -> 
	for tea in teas
		if (tea.name == name)
			return tea

window.storeTea = (tea) ->
	localStorage[CHOSEN_TEA] = tea.name

window.createRadios = () ->
	stored_tea = localStorage[CHOSEN_TEA]
	for tea in teas
		$("<label class='radio'><input type='radio' name='time' value='#{tea.name}'>#{tea.title}</label>").appendTo($('#radios'))
		
	if stored_tea
		for radio in $('input:radio[name=time]')
			if radio.value == stored_tea
				radio.checked = true
	else 
		$('input:radio[name=time]')[0].checked = true

window.startTimer = (seconds, btn) ->   
	window.btn = btn
	permission = window.webkitNotifications.checkPermission() 
	time = 1000 * seconds
	total_time = time
	console.log("Setting timeout for #{time}")  
	timer_running = true
	setTimeout("onTick()", 1000)
	if (permission != 0) 
		window.webkitNotifications.requestPermission(startTimer(minutes))


window.onTick = () -> 
	total_time = total_time - 1000  
	if (timer_running)
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
	enable()


window.onSliderChange = (evt, ui) -> 
	time = ui.value * 1000
	$('#teaTime').html(formatMillis(time))


window.displayNotification = () -> 
	permission = window.webkitNotifications.checkPermission()
	console.log("Permission: #{permission}")
	window.popup = window.webkitNotifications.createHTMLNotification("popup.html")
	ding('snd/alarm.mp3', window.popup)		
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


window.ding = (mp3, popup) -> 
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
		setTimeout(pauseAudio, CANCEL_TIMEOUT) 
		
window.enable = () ->
	$('#btn-run').button('reset')
	enableGroup($('input:radio[name=time]'));
	$("#slider").slider("enable");
	time = $("#slider").slider("option", "value")
	$('#teaTime').html(formatMillis(time * 1000))
	$('#btn-reset').attr("disabled", "true")


#Initialization code
$(document).ready ->
	#popovers
	$("a[rel=popover]").popover(offset: 10).click = (e) ->
		e.preventDefault()
	#radios
	createRadios()
	
	#slider
	$("#slider").slider({min:1, max: 659})
	
	#run button function
	$('#btn-run').click -> 
		permission = window.webkitNotifications.checkPermission()
		if (permission != 0) 
			window.webkitNotifications.requestPermission()
		time =  $("#slider").slider( "option", "value" )
		localStorage[CUSTOM_TIMER] = time
		console.log("Setting timer for: " + time)
		$('#btn-run').button('loading');
		startTimer(time, $('#teaTime'))
		disableGroup($('input:radio[name=time]'))
		$("#slider").slider("disable")
		$('#btn-reset').removeAttr("disabled")
		
	#reset button function
	$('#btn-reset').click ->
		window.enable()
		timer_running = false
	
	#radio button functions
	$('input:radio[name=time]').click ->
		name = $('input:radio[name=time]:checked').val();
		tea = getTea(name)
		storeTea(tea)
		updateInfoPanel(tea)
		$('#slider').slider("option", "value", tea.time);


	$( "#slider" ).slider(slide: (event, ui) ->
		onSliderChange(event, ui))
	$( "#slider" ).slider(change: (event, ui) ->
		onSliderChange(event, ui))
	
	#check webkit notification
	if (!window.webkitNotifications)
		$(".alert").show()
		$('#btn-run').toggleClass('disabled')
		
	$('input:radio[name=time]:checked').click()
	if localStorage[CUSTOM_TIMER] 
		$("#slider").slider("option", "value", localStorage[CUSTOM_TIMER])
	

