module.exports = function (config) {
    config.set({
                   basePath: '../',

                   preprocessors: {
                       '**/*.coffee': ['coffee']
                   },

                   files: [
                       'libs/angular/angular.js',
                       'libs/angular-mocks/angular-mocks.js',
                       'libs/jquery/jquery.js',
                       'js/*.js',
                       'i18n/*.js.en',
                       'tests/unit/**/*.coffee'
                   ],

                   autoWatch: true,

                   frameworks: ['jasmine'],

                   browsers: ['Chrome'],

                   plugins: [
                       'karma-junit-reporter',
                       'karma-chrome-launcher',
                       'karma-firefox-launcher',
                       'karma-jasmine',
                       'karma-coffee-preprocessor'
                   ],

                   junitReporter: {
                       outputFile: 'tests/out/unit.xml',
                       suite: 'unit'
                   },

                   coffeePreprocessor: {
                       // options passed to the coffee compiler
                       options: {
                           bare: true,
                           sourceMap: false
                       },
                       // transforming the filenames
                       transformPath: function (path) {
                           return path.replace(/\.js$/, '.coffee');
                       }
                   }
               })
}