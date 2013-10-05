# Tea-clock
Steep your tea right.
## Intro
Currently running on [website](http://tea-clock.com) and as a Chrome Web Store [application](https://chrome.google.com/webstore/detail/hmldmlgafdbnfhhicheojakimpmocggp?utm_source=chrome-ntp-icon).
Written in Coffeescript, with Angular.js and Twitter Bootstrap.



## Setup dev environment
1. `sudo npm install -g bower grunt-cli`
2. `npm install` - installs development libraries (coffeescript etc.)
2. `bower install` - downloads Angular.js and Twitter Bootstrap
3. `grunt` - compiles all *.coffee to *.js and generates HTML5 appcache
3. Deploy on apache server
4. Enjoy!

## Watch for changes and recompile
1. `grunt watch`