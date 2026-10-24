const CANCEL_TIMEOUT = 10000

let sound
let popup

export function supported() {
    return typeof Notification !== 'undefined'
}

export function checkPermission() {
    if (supported() && Notification.permission !== "granted") {
        Notification.requestPermission()
    }
}

export function playAlarm() {
    sound ??= new Audio('/snd/alarm.mp3')
    sound.currentTime = 0
    sound.play()
    setTimeout(stopAlarm, CANCEL_TIMEOUT)
}

export function stopAlarm() {
    sound?.pause()
}

// Best-effort OS notification; the in-page ready dialog (CountdownModal) is
// the reliable fallback since permission can be denied, ignored, or just
// not supported.
export function display(title, message) {
    if (!supported() || Notification.permission !== "granted") return

    popup = new Notification(title, { body: message, icon: "/img/icon-192.png" })
    popup.onclick = () => popup.close()
    setTimeout(() => popup?.close(), CANCEL_TIMEOUT)
}
