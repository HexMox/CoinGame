EventEmitter = require("eventemitter2").EventEmitter2
{HEIGHT, WIDTH, PIPES_COUNT} = require "./common.coffee"

LEFT_OFFSET = WIDTH / PIPES_COUNT / 2
MIN_BAG_WIDTH = WIDTH / (PIPES_COUNT + 1)
MAX_BAG_WIDTH = MIN_BAG_WIDTH * 3

class Bag extends EventEmitter
    constructor: ->
        super @
        @width = MIN_BAG_WIDTH
        @height = Math.floor 1.41439206 * @width
        @x = LEFT_OFFSET
        @y = HEIGHT - @height
        @offset = 0
        @$bag = null
        @isDragging = no

        @topOffsetRate = 0.207
        @leftOffsetRate = 0.273
        @rightOffsetRate = 0.834

    init: (@$bag)->
        @applyToDom()
        @reset()
        @draw()

    applyToDom: ->
        @y = HEIGHT - @height
        @draw()
        @$bag.width = @width
        @$bag.height = @height
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
        if @isDragging
            @x = x - @offset
            if @x >= WIDTH - @width then @x = WIDTH - @width
            if @x <= 0 then @x = 0
            # y cannot change
            # @y = y
            @draw()

    getCrashCheckObj: ->
        obj =
            x: @x
            y: @y
            width: @width
            height: @height
            topY: @topOffsetRate * @height + @y
            topLeftX: @leftOffsetRate * @width + @x
            topRightX: @rightOffsetRate * @width + @x

    expand: ->
        @width += MIN_BAG_WIDTH / 2
        @width = MAX_BAG_WIDTH if @width > MAX_BAG_WIDTH
        @height = Math.floor 1.41439206 * @width
        @applyToDom()

    shrink: ->
        @width -= MIN_BAG_WIDTH / 2
        @width = MIN_BAG_WIDTH if @width < MIN_BAG_WIDTH
        @height = Math.floor 1.41439206 * @width
        @applyToDom()

module.exports = (new Bag)