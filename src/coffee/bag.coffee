EventEmitter = require("eventemitter2").EventEmitter2
{HEIGHT, WIDTH, PIPES_COUNT} = require "./common.coffee"

LEFT_OFFSET = WIDTH / PIPES_COUNT / 2

class Bag extends EventEmitter
    constructor: ->
        super @
        @width = WIDTH / (PIPES_COUNT + 1)
        @height = 72
        @x = LEFT_OFFSET
        @y = HEIGHT - @height
        @$bag = null
        @isRunning = no

    init: ->
        @$bag.width = @width
        @$bag.height = @height
        @reset()
        @draw()

    reset: ->
        @isRunning = no
        @x = LEFT_OFFSET
        @y = HEIGHT - @height

    draw: ->
        @$bag.style.webkitTransform = "translate3d(#{@x}px, #{@y}px, 0)"

    moveTo: (x, y)->
        @x = x
        @y = y
        @draw

module.exports = new Bag