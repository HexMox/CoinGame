EventEmitter = require("eventemitter2").EventEmitter2
DropThing = require "./dropthing.coffee"
{WIDTH, HEIGHT, PIPES_COUNT} = require './common.coffee'

LEFT_OFFSET = WIDTH / (PIPES_COUNT + 1) / 2
PIPE_PRODUCE = 0.25
STRATEGY = [{
    # score 0-25
    MinDroppingPipes: 1
    MaxDroppingPipes: 2
    probs: [0.7, 0.3] # 生成掉落通道数的概率
    # 生成掉落物种类数的概率，依次为炸弹，白羊，黑羊，纸币，金币，金条
    kindprobs: [0, 0, 0, 0.60, 0.25, 0.15]
    timeStamp: 3
    MinSpeed: HEIGHT / (2.2 * 60)
    MaxSpeed: HEIGHT / (1.9 * 60)
}, {
    # score 26-50
    MinDroppingPipes: 1
    MaxDroppingPipes: 2
    probs: [0.6, 0.4]
    kindprobs: [0.05, 0, 0, 0.60, 0.25, 0.10]
    timeStamp: 3
    MinSpeed: HEIGHT / (1.8 * 60)
    MaxSpeed: HEIGHT / (1.6 * 60)
}, {
    # score 51-100
    MinDroppingPipes: 1
    MaxDroppingPipes: 3
    probs: [0.5, 0.3, 0.2]
    kindprobs: [0.05, 0.05, 0.05, 0.40, 0.30, 0.15]
    timeStamp: 2
    MinSpeed: HEIGHT / (1.8 * 60)
    MaxSpeed: HEIGHT / (1.6 * 60)
}, {
    # score 101-150
    MinDroppingPipes: 1
    MaxDroppingPipes: 3
    probs: [0.5, 0.3, 0.2]
    kindprobs: [0.15, 0.10, 0.10, 0.27, 0.25, 0.13]
    timeStamp: 2
    MinSpeed: HEIGHT / (1.5 * 60)
    MaxSpeed: HEIGHT / (1.3 * 60)
}, {
    # score 151-300
    MinDroppingPipes: 1
    MaxDroppingPipes: 4
    probs: [0.25, 0.25, 0.25, 0.25]
    kindprobs: [0.18, 0.13, 0.12, 0.23, 0.23, 0.11]
    timeStamp: 2
    MinSpeed: HEIGHT / (1 * 60)
    MaxSpeed: HEIGHT / (0.7 * 60)
},{
    # score 301-800
    MinDroppingPipes: 2 
    MaxDroppingPipes: 4 
    probs: [0.3, 0.4, 0.3]
    kindprobs: [0.24, 0.15, 0.10, 0.20, 0.15, 0.16]
    timeStamp: 2
    MinSpeed: HEIGHT / (1 * 60)
    MaxSpeed: HEIGHT / (0.7 * 60)
},{
    # score 800up
    MinDroppingPipes: 3
    MaxDroppingPipes: 5 
    probs: [0.3, 0.3, 0.4]
    kindprobs: [0.39, 0.12, 0.05, 0.20, 0.12, 0.12]
    timeStamp: 2
    MinSpeed: HEIGHT / (1 * 60)
    MaxSpeed: HEIGHT / (0.7 * 60)
}]
kindScores = [0, 0, 0, 3, 5, 10]

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
        @flag = 180
        @stage = 0
        @strategy = STRATEGY[@stage]
        @frameCount = 180

    produce: ->
        if (++@flag >= @frameCount)
            @flag = 0
            count  = @getDropsCount()
            for i in [1..count]
                pipeId = Math.floor(Math.random() * PIPES_COUNT)
                kind = @getKind()
                speed = @getSpeed()
                dropthing = new DropThing(kind, pipeId, speed)
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
                else if isCatch bagLocation, thing.getCrashCheckObj(), thing.kind
                    @emit 'catch', kindScores[thing.kind]
                    thing.crash()
                    if thing.kind is 0
                        @emit 'reduce-hp'
                    if thing.kind is 1
                        @emit 'expand-bag'
                    if thing.kind is 2
                        @emit 'shrink-bag'
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

    getSpeed: ->
        speed = Math.floor(@strategy.MinSpeed +  Math.random() * (@strategy.MaxSpeed - @strategy.MinSpeed))

    changeStrategy: (stage)->
        @stage = stage 
        @strategy = STRATEGY[stage]
        @frameCount = @strategy.timeStamp * 60

    changeStrategyByScore: (score)->
        if 0 <= score <= 25
            @changeStrategy 0 if @stage isnt 0
        if 26 <= score <= 50
            @changeStrategy 1 if @stage isnt 1
        if 51 <= score <= 100
            @changeStrategy 2 if @stage isnt 2
        if 101 <= score <= 150
            @changeStrategy 3 if @stage isnt 3
        if 151 <= score <= 300
            @changeStrategy 4 if @stage isnt 4
        if 301 <= score <= 800
            @changeStrategy 5 if @stage isnt 5
        if 801 <= score
            @changeStrategy 6 if @stage isnt 6

isCatch = (trapezoid, rectangle, kind)->
    # if kind is 0
    #     rightBound = trapezoid.x + trapezoid.width - rectangle.width * 1/2
    #     leftBound = trapezoid.x
    #     return leftBound <= rectangle.rightX and rightBound >= rectangle.leftX \
    #         and rectangle.topY <= trapezoid.topY <= rectangle.downY
    trapezoid.topLeftX <= rectangle.rightX and trapezoid.topRightX >= rectangle.leftX \
        and rectangle.topY <= trapezoid.topY <= rectangle.downY

module.exports = (new Dropstuff)