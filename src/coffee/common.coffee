HEIGHT = document.documentElement.clientHeight
WIDTH = document.documentElement.clientWidth
MAX_HEIGHT = 568
MAX_WIDTH = 360
HEIGHT = if HEIGHT > MAX_HEIGHT then MAX_HEIGHT else HEIGHT
WIDTH = if WIDTH > MAX_WIDTH then MAX_WIDTH else WIDTH

PIPES_COUNT = 4

# Framerate: 1000 / 60
RATE = 16.7

AGENT = window.navigator.userAgent

module.exports = {HEIGHT, WIDTH, PIPES_COUNT, RATE, AGENT}
