SOUND = false
MINUTE = 1000 * 60
CANCEL_TIMEOUT = 5000
total_time = 0

window.startTimer = (minutes, btn) ->   
  window.btn = btn
  permission = window.webkitNotifications.checkPermission()
  time = MINUTE * minutes
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
    
formatMillis = (millis) -> 
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
    window.btn.button('reset')
  else 
    console.log("Průšvih - nemám permission!")
  
  
window.displayNotification = () -> 
  permission = window.webkitNotifications.checkPermission()
  console.log("Permission: #{permission}")
  window.popup = window.webkitNotifications.createHTMLNotification("popup.html")
  popup.show()
  setTimeout("popup.cancel()", CANCEL_TIMEOUT)
  
window.ding = () -> 
  snd = new Audio("snd/ding.wav")
  if SOUND 
    snd.play()
  
  
  
  
  