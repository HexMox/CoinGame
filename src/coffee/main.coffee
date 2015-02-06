jquery = require "jquery"

Game = require "../../lib/game"
util = require "../../lib/utils"

state = require "./state.coffee"
bag = require "./bag.coffee"
dropstuff = require "./dropstuff.coffee"
{HEIGHT, WIDTH} = require "./common.coffee"

$ = util.$
game = new Game
$area = $ ".area"
$initContainer = $ ".init-container"
$startBtn = $ ".start-btn"
$showInstructionBtn = $ ".show-instruction-btn"
$instruction = $ ".instruction"
$instructionBackBtn = $ ".instruction-back-btn"
$score = $ "#score"
$header = $ ".header"
$bag = $ ".bag"

$drops = $ ".drops"

score = 0
hp = 3

game.on 'init', ->
    initArea()
    initBtns()
    initBag()
    initStates()
    initDropstuff()
    jquery.ajax
        url: location.protocol + "//" + location.host + "/users/access"
        type: 'POST'
        # success: (data, status)->

initArea = ->
    $area.style.width = "#{WIDTH}px"
    $area.style.height = "#{HEIGHT}px"

initBag = ->
    bag.init $bag
    $bag.addEventListener "touchstart", (event)->
        bag.setOffset event.touches[0].clientX
    $bag.addEventListener "touchmove", (event)->
        event.preventDefault();
        bag.moveTo event.touches[0].clientX, event.touches[0].clientY
    $bag.addEventListener "touchend", ->
        bag.clearOffset()
    # game.add $bag

initBtns = ->
    $startBtn.addEventListener "click", ->
        $initContainer.style.display = "none"
        $header.style.display = "block"
        # mobile compatibility, maybe  a bug
        setTimeout ->
            $score.style.position = "absolute"
        , 100
        game.start()
        state.change "start"
    $showInstructionBtn.addEventListener "click", ->
        $instruction.style.display = "block"
        $initContainer.style.display = "none"
    $instructionBackBtn.addEventListener "click", ->
        $instruction.style.display = "none"
        $initContainer.style.display = "block"

initStates = ->
    timer = null
    state.on 'start', ->
        score = 0
        $score.innerHTML = score
        hp = 3
        updateHpView()
        bag.reset()
        bag.show()
        dropstuff.init() #reset
        $drops.innerHTML = ""

        _run = ->
            dropstuff.produce()
            dropstuff.move bag.getCrashCheckObj()
            if (hp > 0)
                timer = requestAnimationFrame(_run)
        _run()
    # put in this becase timer is local variable
    game.on 'stop', ->
        cancelAnimationFrame timer

initDropstuff = ->
    dropstuff.init()
    dropstuff.on 'catch', (gain)->
        score += gain
        dropstuff.changeStrategyByScore score
        updateScoreView()

    dropstuff.on 'reduce-hp', ->
        hp--
        updateHpView()
        if hp <= 0
            game.stop()
            state.change "over", score

    dropstuff.on 'expand-bag', ->
        bag.expand()
    dropstuff.on 'shrink-bag', ->
        bag.shrink()

updateScoreView = ->
    $score.innerHTML = score

updateHpView = ->
    for i in [1..3]
        className = "hp#{i}"
        if i > hp
            $(".#{className}").style.display = "none"
        else
            $(".#{className}").style.display = "block"

game.init()