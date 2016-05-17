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
  updatePosition: (cv, paddle, live) ->
    @dx = -@dx if @x + @dx > cv.width - @radius or @x + @dx < @radius
    if @y + @dy < @radius
      @dy = -@dy
    else if @y + @dy > cv.height - @radius
      if @x > paddle.x and @x < paddle.x + paddle.width
        @dy = -@dy
      else
        live.lives--
        if live.lives is 0
          alert("GAME OVER")
          document.location.reload()
        else
          @x = ballPosX
          @y = ballPosY
          @dx = dx
          @dy = dy
          paddle.x = paddleX

    @x += @dx
    @y += @dy

class Brick
  constructor: (@x, @y, @width, @height) ->
  status: 1
  draw: () ->
    ctx.beginPath();
    ctx.rect(@x, @y, @width, @height)
    ctx.fillStyle = "#0095DD"
    ctx.fill()
    ctx.closePath()
  collisionDetect: (ball, score) ->
    if @status == 1
      if ball.x > @x and ball.x < @x + @width and ball.y > @y and ball.y < @y + @height
        ball.dy = -ball.dy
        @status = 0
        score.score++

class Score
  constructor: (@score) ->
  draw: () ->
    ctx.font = "16px Arial"
    ctx.fillStyle = "#0095DD"
    ctx.fillText("Score: #{@score}", 8, 20)
  checkWinCondition: (brickNums) ->
    if @score is brickNums
      alert("YOU WIN, CONGRATULATIONS!")
      document.location.reload()

class Live
  constructor: (@lives) ->
  draw: (canvas) ->
    ctx.font = "16px Arial"
    ctx.fillStyle = "#0095DD"
    ctx.fillText("Lives: #{@lives}", canvas.width - 65, 20)


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

score = new Score(0)
live = new Live(3)

draw = () ->
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  ball.updatePosition(cv, paddle, live)
  ball.draw()
  paddle.updatePosition(rightPressed, leftPressed, cv)
  paddle.draw()
  # draw bricks
  for c in [0...brickColumnCount]
    for r in [0...brickRowCount] 
      bricks[c][r].draw() if bricks[c][r].status == 1

  for c in [0...brickColumnCount]
    for r in [0...brickRowCount]
      bricks[c][r].collisionDetect(ball, score)

  score.draw()
  live.draw(cv)
  score.checkWinCondition(brickRowCount * brickColumnCount)
  nil


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

mouseMoveHandler = (e) ->
  relativeX = e.clientX - canvas.offsetLeft;
  if relativeX > 0 and relativeX < canvas.width
    paddle.x = relativeX - paddle.width/2

document.addEventListener("keydown", keyDownHandler, false)
document.addEventListener("keyup", keyUpHandler, false)
document.addEventListener("mousemove", mouseMoveHandler, false);
setInterval(draw, 10)