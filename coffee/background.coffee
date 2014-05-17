#Initialization code
chrome.app.runtime.onLaunched.addListener(() ->
    chrome.app.window.create('index.html', {
        'bounds':
            'width': 380,
            'height': 380
    })
)