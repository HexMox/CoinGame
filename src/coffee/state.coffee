EventEmitter = require("eventemitter2").EventEmitter2
util = require "../../lib/utils"

$ = util.$
states = ["start", "game", "over"]
REWARD_SCORE = 50

class State extends EventEmitter
    constructor: ->
        super @
        @state = "start"
        @$over = $ "#over"

        @$overFail = $ ".over-fail"
        @$failScore = $ ".over-fail .score"
        @$againBtn = $ ".over-fail .again"

        @$overSucceed = $ ".over-succeed"
        @$succeedScore = $ ".over-succeed .score"
        @$bullshit = $ ".bullshit"
        @$goLotteryBtn = $ ".over-succeed .go-lottery"

        @$overLotteryClose = $ ".over-lottery-close"
        @$openRewardBtn = $ ".over-lottery-close .open-reward-btn"

        @$overLotteryOpen = $ ".over-lottery-open"

        @$congratulation = $ ".congratulation"
        @$goShareBtn = $ ".go-share-btn"
        @initOverState()

    initOverState: ->
        @$againBtn.addEventListener "touchstart", (event)=>
            event.stopPropagation()
            @change "start"

        @$goLotteryBtn.addEventListener "touchstart", (event)=>
            event.stopPropagation()
            @$overSucceed.style.display = "none"
            @$overLotteryClose.style.display = "block"

        @$openRewardBtn.addEventListener "touchstart", (event)=>
            event.stopPropagation()
            @$overLotteryClose.style.display = "none"
            @$overLotteryOpen.style.display = "block"
            setTimeout =>
                @$overLotteryOpen.style.display = "none"
                @$congratulation.style.display = "block"
            , 1000

    change: (state, score)->
        if state not in states then throw "#{state} is not in states"
        @state = state
        @toggleOverState state, score
        @emit state

    toggleOverState: (state, score)->
        if state is "over"
            @$over.style.display = "block"
            if score > REWARD_SCORE
                @$succeedScore.innerHTML = score
                @$bullshit.innerHTML = getRankByScore score
                @$overSucceed.style.display = "block"
            else
                @$failScore.innerHTML = score
                @$overFail.style.display = "block"
        else
            @$over.style.display = "none"

getRankByScore = (score)->
    if 0 <= score <= 50 then return rankString 10
    if 51 <= score <= 100 then return rankString 40
    if 101 <= score <= 150 then return rankString 75
    if 151 <= score <= 200 then return rankString 90
    if 201 <= score then return rankString 98

rankString = (percent)->
    "已超过#{percent}%的兔玩家"

module.exports = (new State)