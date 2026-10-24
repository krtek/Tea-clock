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

export function display(title, message) {
    popup = new Notification(title, { body: message, icon: "/img/icon.png" })

    sound ??= new Audio('/snd/alarm.mp3')
    sound.play()

    popup.onclick = () => popup.close()
    popup.onclose = () => sound.pause()

    setTimeout(cancel, CANCEL_TIMEOUT)
}

function cancel() {
    popup?.close()
    sound?.pause()
}
