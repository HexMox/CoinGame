$(document).ready(function() {

    var height = $(document).innerHeight();
    var width = $(document).innerWidth();
    var canvas = $("#canvas");
    var ctx = canvas[0].getContext('2d');
    var dropThingsType = {
        bomb: {},
        smallCoin: {},
        middleCoin: {
            img: (function() {
                var o = new Image();
                o.src = 'imgs/middle-coin.png';
                return o;
            })(),
            radius: 25,
        },
        BigCoin: {}
    };

    (function() {
        canvas.attr({
            "height": height + "px",
            "width": width + "px"
        });
        canvas.css("position", "relative");
    })();

    function createDropThing(type) {
        var radius = dropThingsType[type].radius;
        var offsetX = Math.random() * (width - radius);
        var obj = {
            img: dropThingsType[type].img,
            radius: radius,
            x: offsetX,
            y: -radius,
            drop: function() {
                this.y += 1; // speed
                drawDropThing(self);
                console.log(this.y, height);
                if (this.y < height) {
                    setTimeout(arguments.callee, 100);
                }
            },
            hasBeenCatched: function() {},
            hasRolledOut: function() {}
        };
        return obj;
    }

    function drawDropThing(obj) {
        ctx.drawImage(obj.img, obj.x, obj.y, 2*obj.radius, 2*obj.radius);
    }

    $("#createCoinBtn").click(function  () {
        var newCoin = createDropThing("middleCoin");
        newCoin.drop();
    });
});