
module.exports = (grunt) ->

    coffeeify = require "coffeeify"
    stringify = require "stringify"

    grunt.initConfig
        connect:
            sever:
                options:
                    port: 3001
                    base: '.'

        clean:
            bin: ["bin"]
            dist: ["dist"]

        watch:
            compile:
                options:
                    livereload: true
                files: ["src/**/*.coffee", "src/**/*.less", "src/**/*.html", "lib/**/*.js"]
                tasks: ["browserify", "less"]

        browserify:
            dev:
                options:
                  preBundleCB: (b)->
                    b.transform(coffeeify)
                    b.transform(stringify({extensions: [".hbs", ".html", ".tpl", ".txt"]}))
                expand: true
                flatten: true
                src: ["src/coffee/main.coffee"]
                dest: "bin/js"
                ext: ".js"

        less:
            compile:
                files:
                    "bin/css/style.css": ["src/less/style.less"]

        uglify:
            build:
                files: [{
                    expand: true
                    cwd: "bin/js/"
                    src: ["**/*.js"]
                    dest: "dist/js"
                    ext: ".min.js"
                }]

        cssmin:
            build:
                files:
                    "dist/css/style.css": ["bin/css/style.css"]

        copy:
            assets:
                src: "assets/**/*"
                dest: "dist/"
            html:
                src: "src/index.html"
                dest: "dist/index.html"

    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks 'grunt-browserify';
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-cssmin"

    grunt.registerTask "default",  ->
        grunt.task.run [
            "connect"
            "clean:bin"
            "browserify"
            "less"
            "watch"
        ]

    grunt.registerTask "build", ->
        grunt.task.run [
            "clean:bin"
            "clean:dist"
            "browserify"
            "less"
            "uglify"
            "cssmin"
            "copy"
        ]