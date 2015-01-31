EventEmitter = require("eventemitter2").EventEmitter2
{HEIGHT, WIDTH, PIPES_COUNT} = require "./common.coffee"

LEFT_OFFSET = WIDTH / PIPES_COUNT / 2

class Bag extends EventEmitter
    constructor: ->
        super @
        @width = WIDTH / (PIPES_COUNT + 1)
        @height = Math.floor 1.41439206 * @width
        @x = LEFT_OFFSET
        @y = HEIGHT - @height
        @offset = 0
        @$bag = null
        @isDragging = no

    init: (@$bag)->
        @$bag.width = @width
        @$bag.height = @height
        @reset()
        @draw()

    reset: ->
        @isDragging = no
        @x = LEFT_OFFSET
        @y = HEIGHT - @height
        @draw()

    setOffset: (ex)->
        @offset = ex - @x
        @isDragging = yes

    clearOffset: ->
        @offset = 0
        @isDragging = no

    draw: ->
        @$bag.style.webkitTransform = "translate3d(#{@x}px, #{@y}px, 0)"

    show: ->
        @$bag.style.display = "block"

    moveTo: (x, y)->
        x = if x > WIDTH then WIDTH else x;
        if @isDragging
            @x = x - @offset
            # y cannot change
            # @y = y
            @draw()

module.exports = (new Bag)