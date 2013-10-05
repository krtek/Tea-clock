module.exports = (grunt) ->

    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")
        coffee:
            compile:
                expand: true
                flatten: false
                cwd: 'coffee'
                src: ['*.coffee']
                dest: 'js'
                ext: '.js'
        watch:
            files: ['index.html', 'coffee/*.coffee']
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
                    'js/*.js'
                    'css/*.css'
                    'snd/*'
                    'libs/angular/*.min.js'
                    'libs/jquery/*.min.js'
                    'libs/bootstrap/dist/js/*.min.js'
                    'libs/bootstrap/dist/css/*.min.css'
                    'libs/bootstrap/dist/fonts/*'
                    'libs/jquery-ui/themes/ui-lightness/*.min.css'
                    'libs/jquery-ui/themes/ui-lightness/images/*'
                    'libs/jquery-ui/ui/minified/jquery-ui.js'
                ]
                dest: 'tea-clock.appcache'

    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks("grunt-contrib-coffee")
    grunt.loadNpmTasks("grunt-contrib-watch")
    grunt.loadNpmTasks('grunt-manifest')

    # Default task(s).
    grunt.registerTask "default", ["coffee", "manifest"]
