canvas = document.getElementById("myCanvas")
ctx = canvas.getContext("2d")

ballPosX = canvas.width/2
ballPosY = canvas.height-30
dx = 2
dy = -2
ballRadius = 10

paddleHeight = 10
paddleWidth = 75
paddleX = (canvas.width-paddleWidth)/2

rightPressed = false
leftPressed = false

brickRowCount = 3
brickColumnCount = 5
brickWidth = 75
brickHeight = 20
brickPadding = 10
brickOffsetTop = 30
brickOffsetLeft = 30

class Canvas 
  constructor: (@width, @height) ->

class Paddle
  constructor: (@x, @y, @width, @height) ->
  draw: () ->
    ctx.beginPath()
    ctx.rect(@x, @y, @width, @height)
    ctx.fillStyle = "#0095DD"
    ctx.fill()
    ctx.closePath()
  updatePosition: (rightPressed, leftPressed, cv) ->
    if rightPressed and @x < cv.width-@width
      @x += 7
    else if leftPressed and @x > 0
      @x -= 7

class Ball
  constructor: (@x, @y, @radius, @dx, @dy) ->

  draw: () ->
    ctx.beginPath()
    ctx.arc(@x, @y, @radius, 0, Math.PI*2)
    ctx.fillStyle = "#0095DD"
    ctx.fill()
    ctx.closePath()
  updatePosition: (cv, paddle) ->
    dx = -dx if @x + dx > cv.width - @radius or @x + dx < @radius
    if @y + dy < @radius
      dy = -dy
    else if @y + dy > cv.height - @radius
      if @x > paddle.x and @x < paddle.x + paddle.width
        dy = -dy
      else
        alert("GAME OVER")
        document.location.reload()

    @x += dx
    @y += dy

class Brick
  constructor: (@x, @y, @width, @height) ->
  draw: () ->
    ctx.beginPath();
    ctx.rect(@x, @y, @width, @height)
    ctx.fillStyle = "#0095DD"
    ctx.fill()
    ctx.closePath()

cv = new Canvas(canvas.width, canvas.height)
ball = new Ball(ballPosX, ballPosY, ballRadius, dx, dy)
paddle = new Paddle(paddleX, cv.height-paddleHeight, paddleWidth, paddleHeight)
bricks = []
for c in [0...brickColumnCount]
  bricks[c] = []
  for r in [0...brickRowCount]
    brickX = (c*(brickWidth + brickPadding)) + brickOffsetLeft
    brickY = (r*(brickHeight + brickPadding)) + brickOffsetTop
    bricks[c][r] = new Brick(brickX, brickY, brickWidth, brickHeight)

draw = () ->
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  ball.updatePosition(cv, paddle)
  ball.draw()
  paddle.updatePosition(rightPressed, leftPressed, cv)
  paddle.draw()
  # draw bricks
  for c in [0...brickColumnCount]
    for r in [0...brickRowCount]
      bricks[c][r].draw()

keyDownHandler = (e) ->
  if e.keyCode == 39
    rightPressed = true
  else if e.keyCode == 37
    leftPressed = true

keyUpHandler = (e) ->
  if e.keyCode == 39
    rightPressed = false
  else if e.keyCode == 37
    leftPressed = false

document.addEventListener("keydown", keyDownHandler, false)
document.addEventListener("keyup", keyUpHandler, false)
setInterval(draw, 10)