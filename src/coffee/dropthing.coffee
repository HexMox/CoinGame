EventEmitter = require("eventemitter2").EventEmitter2
{WIDTH, HEIGHT, PIPES_COUNT} = require './common'

THING_WIDTH = THING_HEIGHT = 0.75 * WIDTH / (PIPES_COUNT + 1)

class Dropthing extends EventEmitter
    constructor: (kind)->
        @x = 0
        @y = 0
        @width = 0
        @height = 0
        # @vx = 0
        @vy = 0
        @kind = kind
        @$dom = null

    init: ->
        