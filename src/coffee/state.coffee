EventEmitter = require("eventemitter2").EventEmitter2
util = require "../../lib/utils"

$ = util.$
states = ["start", "game", "over"]

class State extends EventEmitter
    constructor: ->
        super @
        @state = "start"
        @$over = $ "#over"
        @$score = $ "#over .score"
        @$rank = $ "#over .rank"
        @$again = $ "#over .again"
        # @$share = null
        # @$count = null
        @initOverState()

    initOverState: ->
        @$again.addEventListener "touchstart", (event)=>
            event.stopPropagation()
            @change "start"

    change: (state, score)->
        if state not in states then throw "#{state} is not in states"
        @state = state
        @toggleOverState state, score

    toggleOverState: (state, score)->
        if state is "over"
            @$score.innerHTML = score
            @$rank.innerHTML = getRankByScore score
            @$over.style.display = "block"
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