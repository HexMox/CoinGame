EventEmitter = require("eventemitter2").EventEmitter2
{$} = require '../../lib/utils'
{WIDTH, HEIGHT, PIPES_COUNT} = require './common.coffee'

PIPES_WIDTH = WIDTH / (PIPES_COUNT + 1)
THING_WIDTH = THING_HEIGHT = 0.75 * PIPES_WIDTH
LEFT_OFFSET = WIDTH / (PIPES_COUNT + 1) / 2
TOP_OFFSET = 0.03 * HEIGHT
SECONDS = 3
SPEED = HEIGHT / (SECONDS * 60)

$drops = $ ".drops"

KINDS = [
    "boom", 
    "paper-money",
    "gold-money",
    "gold-bar"
]

class Dropthing extends EventEmitter
    constructor: (kind, pipeId)->
        super @
        @x = 0
        @y = TOP_OFFSET
        @width = THING_WIDTH
        @height = THING_HEIGHT
        # @vx = 0
        @vy = 0
        @kind = kind
        @pipeId = pipeId
        @$dom = null
        @init()

    init: ->
        @x = (Math.random() * PIPES_WIDTH * 0.25) + (@pipeId * PIPES_WIDTH + LEFT_OFFSET)
        @vy = SPEED
        @$dom = @createDom()

    drop: ->
        @y += @vy

    draw: ->
        @$dom.style.webkitTransform = "translate3d(#{@x}px, #{@y}px, 0)"

    remove: ->
        $drops.removeChild @$dom

    crash: ->
        that = @
        switch @kind
            when 0
                @$dom.className = "blast drop"
                @$dom.style.width = @width * 2
                @$dom.style.height = @height * 2
            when 1 then @$dom.className = "add-three drop"
            when 2 then @$dom.className = "add-five drop"
            when 3 then @$dom.className = "add-ten drop"
        setTimeout ->
            that.remove()
        , 500

    createDom: ->
        div = document.createElement "div"
        div.className = "#{KINDS[@kind]} drop"
        div.style.width = "#{@width}px"
        div.style.height = "#{@height}px"
        div.style.webkitTransform = "translate3d(#{@x}, #{@y}, 0)"
        $drops.appendChild div
        div

    getLocation: ->
        location =  
            leftX: @x
            rightX: @x + @width
            topY: @y
            downY: @y + @height

    isToRemove: ->
        @y >= HEIGHT

module.exports = Dropthing