#Initialization code
chrome.app.runtime.onLaunched.addListener(() ->
    chrome.app.window.create('index.html', {
        'bounds':
            'width': 400,
            'height': 500
    })
)