EventEmitter = require("eventemitter2").EventEmitter2
DropThing = require "./dropthing.coffee"
{WIDTH, HEIGHT, PIPES_COUNT} = require './common.coffee'

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

class Dropstuff extends EventEmitter
    constructor: ->
        super @
        @pipes = null
        @strategy = null
        @stage = 0
        @flag = 0
        @frameCount = 0

    init: ->
        # same as reset
        @pipes = []
        for i in [1..PIPES_COUNT]
            @pipes.push []
        @flag = 0
        @stage = 0
        @strategy = STRATEGY[@stage]
        @frameCount = 180

    produce: ->
        if (++@flag >= @frameCount)
            @flag = 0
            count  = @getDropsCount()
            for i in [1..count]
                pipeId = Math.floor(Math.random() * 4)
                kind = @getKind()
                # kind = 0
                dropthing = new DropThing(kind, pipeId)
                @pipes[pipeId].push dropthing

    move: (bagLocation)->
        # need a temp pipes variable because splice operation maybe occur
        pipes = []
        for pipe in @pipes
            newPipe = []
            for thing, i in pipe
                thing.drop() 
                thing.draw()
                if thing.isToRemove()
                    continue
                else if isCatch bagLocation, thing.getLocation() 
                    @emit 'catch', kindScores[thing.kind]
                    thing.crash()
                    if thing.kind is 0
                        @emit 'reduce-hp'
                else
                    newPipe.push thing
            pipes.push newPipe
        @pipes = pipes

    getDropsCount: ->
        x = Math.random()
        left = 0
        right = 0
        count = @strategy.MinDroppingPipes
        for item in @strategy.probs
            right += item
            if (x <= right and x > left)
                return count
            left = right
            count++
        @strategy.MaxDroppingPipes

    getKind: ->
        x = Math.random()
        left = 0
        right = 0
        kind = 0
        for item in @strategy.kindprobs
            right += item
            if (x <= right and x > left)
                return kind
            left = right
            kind++
        0

    changeStrategy: (stage)->
        @stage = stage 
        @strategy = STRATEGY[stage]

    changeStrategyByScore: (score)->
        if 0 <= score <= 50
            @changeStrategy 0 if @stage isnt 0
            @frameCount = 180
        if 51 <= score <= 100
            @changeStrategy 1 if @stage isnt 1
            @frameCount = 120
        if 101 <= score <= 150
            @changeStrategy 2 if @stage isnt 2
            @frameCount = 120
        if 151 <= score <= 200 
            @changeStrategy 3 if @stage isnt 3
            @frameCount = 120
        if 201 <= score <= 800
            @changeStrategy 4 if @stage isnt 4
            @frameCount = 60
        if 801 <= score
            @changeStrategy 5 if @stage isnt 5
            @frameCount = 20

isCatch = (trapezoid, rectangle)->
    trapezoid.topLeftX <= rectangle.rightX and trapezoid.topRightX >= rectangle.leftX \
        and rectangle.topY <= trapezoid.topY <= rectangle.downY

module.exports = (new Dropstuff)