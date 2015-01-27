do ->
    types = 
        bomb: {}
        smallCoin: {}
        middleCoin:
            img: do ->
                image = new Image()
                image.src = 'imgs/middle-coin.png'
                image
            radius: 25
            value: 2
            speed: 2
        bigCoin: {}

    canvas = $("#canvas")
    ctx = canvas[0].getContext('2d')
    cwidth = $(document).innerWidth()
    cheight = $(document).innerHeight()
    BTN_WIDTH = 175
    BTN_HEIGHT = 75
    isPlaying = false
    startBtn
    showIntroductionBtn
    replayBtn
    everything = []

    class DropThing
        constructor: (type) ->
            @img = type.img
            @value = type.value
            @radius = type.radius
            @speed = type.speed
            @x = Math.random() * (cwidth - radius)
            @y = -type.radius

       drop: ->
            @y += @speed

        draw: ->
            ctx.drawImage(@img, @x, @y, @width, @height)

    class Button
        constructor: (x, y, width, height) ->
            @x = x
            @y = y
            @width = width
            @height = height

        draw: ->
            ctx.fillStyle="#0000ff";
            ctx.fillRect(@x, @y, @width, @height)

    window.onload = ->
        initCanvas()
        showBeginScene()
        addEventsToCanvas()

    initCanvas = ->
        canvas.attr
            "height": cheight + "px"
            "width": cwidth + "px"
        canvas.css "position", "relative"

    showBeginScene = ->
        startBtn = new Button((cwidth - BTN_WIDTH)/2, (cheight - BTN_HEIGHT)/2 - BTN_HEIGHT,
                                                 BTN_WIDTH, BTN_HEIGHT)
        showIntroductionBtn = new Button((cwidth - BTN_WIDTH)/2, (cheight - BTN_HEIGHT)/2 + BTN_HEIGHT,
                                                 BTN_WIDTH, BTN_HEIGHT)
        everything.push startBtn, showIntroductionBtn
        drawAll()

    addEventsToCanvas = ->
        addBeginEvents()
        addGameEvents()
        addResultEvents()

    drawAll = ->
        ctx.clearRect(0, 0, cwidth, cheight)
        for thing in everything
            thing.draw()

    addBeginEvents = ->
        canvas.bind 'click', startGame
        canvas.bind 'click', (e)->
            $(".introductionContainer").show() if isPointInRect e.pageX, e.pageY, showIntroductionBtn
        $(".closeIntroductionBtn").click ->
            $(".introductionContainer").hide()

    addGameEvents = ->
        canvas.bind 'mousedowm', lockBag
        canvas.bind 'mousemove', moveBag
        canvas.bind 'mouseup', releaseBag

    addResultEvents = ->
        canvas.bind 'click', replayGame
        # share, raffle feature

    startGame = (e)->
        if not isPlaying and isPointInRect(e.pageX, e.pageY, startBtn)
            isPlaying = true
            # remove startBtn, showIntroductionBtn
            everything = []
            startRandomDrop()

    lockBag = ->

    moveBag = ->

    releaseBag = ->

    replayGame = (e)->
        if not isPlaying and isPointInRect(e.pageX, e.pageY, replayBtn)
            #replay

    isPointInRect = (x, y, btnObj)->
        if not btnObj return false
        x >= btnObj.x and x <= btnObj.x + width
            and y >= btnObj.y and y <= btnObj.y + height