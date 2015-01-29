
module.exports = (grunt) ->
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
                files: ["src/**/*.coffee", "src/**/*.less", "src/**/*.html"]
                tasks: ["coffee", "less"]

        coffee:
            compile:
                options:
                    join: true
                files:
                    "bin/js/main.js": ["src/coffee/*.coffee"]

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

    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-cssmin"

    grunt.registerTask "default",  ->
        grunt.task.run [
            "connect"
            "clean:bin"
            "coffee"
            "less"
            "watch"
        ]

    grunt.registerTask "build", ->
        grunt.task.run [
            "clean:bin"
            "clean:dist"
            "coffee"
            "less"
            "uglify"
            "cssmin"
            "copy"
        ]