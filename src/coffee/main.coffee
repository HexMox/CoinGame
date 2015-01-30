Game = require "../../lib/game"
util = require "../../lib/util"
bag = require "./bag"
dropstuff = require "./dropstuff"
state = require "./state"
{HEIGHT, WIDTH} = require "./common"

$ = util.$
game = new Game
$area = $ ".area"
$initContainer = $ ".init-container"
$startBtn = $ ".start-btn"
$showInstructionBtn = $ ".show-instruction-btn"
$instruction = $ ".instruction"
$instructionBackBtn = $ ".instruction-back-btn"
$score = $ "#score"
$hp = $ ".hp"
$bag = $ ".bag"

score = 0
hp = 3

game.on 'init', ->
    initArea()
    initBtns()
    initBag()
    initStates()
    initDropstuff()

initArea = ->
    $area.style.width = "#{WIDTH}px"
    $area.style.height = "#{HEIGHT}px"

initBag = ->
    bag.init $bag
    $bag.addEventListener "touchstart", (event)->
        bag.setOffset event.clientX
    $bag.addEventListener "touchmove", (event)->
        bag.moveTo event.clientX, event.clientY
    $bag.addEventListener "touchend", ->
        bag.clearOffset()
    # game.add $bag

initBtns = ->
    $startBtn.addEventListener "click", ->
        game.start()
    $showInstructionBtn.addEventListener "click", ->
        $instruction.style.display = "block"
        $initContainer.style.display = "none"
    $instructionBackBtn.addEventListener "click", ->
        $instruction.style.display = "none"
        $initContainer.style.display = "block"

initStates = ->
    state.on 'start', ->
        score = 0
        $score.innerHTML = score
        hp = 3
        $hp.innerHTML = hp
        bag.reset()

    state.on 'catch', (gain)->
        score += gain

    state.on 'reduce-hp', ->
        hp--
        if hp <= 0
            game.stop()
            state.change "over", score

initDropstuff = ->
    timer = null
    dropstuff.init()
    dropstuff.on 'start', ->
        _run = ->
            dropstuff.produce()
            dropstuff.move
                topLeftX: bag.x + bag.width * 0.1
                topRightX: bag.x + bag.width * 0.9
                topY: bag.y
            timer = requestAnimationFrame(_run)
        _run()
    dropstuff.on 'stop', ->
        cancelAnimationFrame timer

game.init()