module.exports = (grunt) ->

    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")
        coffee:
            compileJoined:
                options:
                    join: true
                files:
                    'js/app.js': ['coffee/*.coffee']
        watch:
            files: ['index.html', 'coffee/*.coffee', 'css/*.css']
            tasks: ['coffee', 'manifest']

        manifest:
            generate:
                options:
                    basePath: '.'
                    cache:[
                        'i18n/angular-locale.js'
                        'i18n/resources-locale.js'
                        'http://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png'
                    ]
                    network: ['*']
                    preferOnline: true
                    verbose: true
                    timestamp: true
                    hash: true

                src: [
                    'index.html'
                    'img/icon_pruhledna.png'
                    'js/*.js'
                    'css/*.css'
                    'snd/*'
                    'libs/angular/*.min.js'
                    'libs/angular-touch/*.min.js'
                    'libs/jquery/*.min.js'
                    'libs/venturocket-angular-slider/build/*.min.js'
                    'libs/bootstrap/dist/js/*.min.js'
                    'libs/bootstrap/dist/css/*.min.css'
                    'libs/bootstrap/dist/fonts/*'
                ]
                dest: 'tea-clock.appcache'

    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks("grunt-contrib-coffee")
    grunt.loadNpmTasks("grunt-contrib-watch")
    grunt.loadNpmTasks('grunt-manifest')

    # Default task(s).
    grunt.registerTask "default", ["coffee", "manifest"]
