EventEmitter = require("eventemitter2").EventEmitter2
DropThing = require "./dropthing"
{$} = require '../../lib/util'
{WIDTH, HEIGHT, PIPES_COUNT} = require './common'

$drops = $ '.drops'
LEFT_OFFSET = WIDTH / (PIPES_COUNT + 1) / 2
PIPE_PRODUCE = 0.25
STRATEGY = [{
    MinDroppingPipes: 1
    MaxDroppingPipes: 1
    probs: [1]
    kindprobs: [.05, .60, .25, .10]
    timeStamp: 3
}, {
    MinDroppingPipes: 1
    MaxDroppingPipes: 2
    probs: [0.7, 0.3]
    kindprobs: [.25, .20, .35, .20]
    timeStamp: 2
}, {
    MinDroppingPipes: 1
    MaxDroppingPipes: 2
    probs: [0.6, 0.4]
    kindprobs: [.25, .35, .25, .15]
    timeStamp: 2
}, {
    MinDroppingPipes: 1
    MaxDroppingPipes: 3
    probs: [0.5, 0.3, 0.2]
    kindprobs: [.35, .35, .15, .15]
    timeStamp: 2
}, {
    MinDroppingPipes: 1
    MaxDroppingPipes: 3
    probs: [0.5, 0.3, 0.2]
    kindprobs: [.5, .2, .1, .2]
    timeStamp: 2
},{
    MinDroppingPipes: 3 
    MaxDroppingPipes: 4 
    probs: [0.6, 0.4]
    kindprobs: [.7, .15, .1, .05]
    timeStamp: 2
}]
kindScores = [0, 3, 5, 10]

class Dropstuff extends EventEmitter2
    constructor: ->
        super @
        @pipes = null
        @strategy = null
        @stage = 0
        @flag = 0

    init: ->
        @pipes = []
        for i in [1..PIPES_COUNT]
            pipes.push []
            flags.push 0
        @flag = 0
        @stage = 0
        @strategy = STRATEGY[stage]

    produce: ->
        if (++flag >= 3)
            flag = 0
            count  = @getDropsCount()
            for i in [1..count]
                pipeId = Math.floor(Math.random() * 4)
                kind = @getKind()
                dropthing = new DropThing(kind, pipeId)
                @pipes[pipeId].push dropthing

    move: (bagLocation)->
        for pipe in pipes
            for i, thing in pipe
                thing.drop()
                if isCatch bagLocation, thing.getLocation() 
                    @emit 'catch', kindScores[thing.kind]
                    thing.crash()
                    pipe.splice i, 1
                    if thing.kind is 0
                        @emit 'reduce-hp'
                if thing.isToRemove()
                    pipe.splice i, 1
                thing.draw()

    getDropsCount: ->
        x = Math.random()
        left = 0
        right = 0
        count = strategy.MinDroppingPipes
        for item in strategy.probs
            right += item
            if (x <= right and x > left)
                return count
            left = right
            count++
        strategy.MaxDroppingPipes

    getKind: ->
        x = Math.random()
        left = 0
        right = 0
        kind = 0
        for item in strategy.kindprobs
            right += item
            if (x <= right and x > left)
                return kind
            left = right
            kind++
        0

isCatch = (trapezoid, rectangle)->
    trapezoid.topLeftX <= rectangle.rightX and trapezoid.topRightX >= rectangle.leftX \
        and rectangle.topY <= trapezoid.topY <= rectangle.downY

module.exports = new Dropstuff