canvas = document.getElementById("myCanvas")
ctx = canvas.getContext("2d")

x = canvas.width/2
y = canvas.height-30
dx = 2
dy = -2
ballRadius = 10

paddleHeight = 10
paddleWidth = 75
paddleX = (canvas.width-paddleWidth)/2

rightPressed = false
leftPressed = false

class Canvas 
  constructor: (@width, @height) ->

cv = new Canvas(canvas.width, canvas.height)

class Ball
  constructor: (@x, @y, @radius, @dx, @dy) ->

  draw: () ->
    ctx.beginPath()
    ctx.arc(@x, @y, @radius, 0, Math.PI*2)
    ctx.fillStyle = "#0095DD"
    ctx.fill()
    ctx.closePath()
  updatePosition: (cv) ->
    dx = -dx if @x + dx > cv.width - @radius or @x + dx < @radius
    if @y + dy < @radius
      dy = -dy
    else if @y + dy > cv.height - @radius
      if @x > paddleX and @x < paddleX + paddleWidth
        dy = -dy
      else
        alert("GAME OVER")
        document.location.reload()

    @x += dx
    @y += dy

ball = new Ball(cv.width/2, cv.height-30, 10, dx, dy)
###
drawBall = () ->
  ctx.beginPath()
  ctx.arc(x, y, ballRadius, 0, Math.PI*2)
  ctx.fillStyle = "#0095DD"
  ctx.fill()
  ctx.closePath()
###

drawPaddle = () ->
  ctx.beginPath()
  ctx.rect(paddleX, canvas.height-paddleHeight, paddleWidth, paddleHeight)
  ctx.fillStyle = "#0095DD"
  ctx.fill()
  ctx.closePath()  

draw = () ->
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  ball.updatePosition(cv)
  ball.draw()
  drawPaddle()
  ###
  dx = -dx if x + dx > canvas.width - ballRadius or x + dx < ballRadius
  
  if y + dy < ballRadius
    dy = -dy
  else if y + dy > canvas.height - ballRadius
    if x > paddleX and x < paddleX + paddleWidth
      dy = -dy
    else
      alert("GAME OVER")
      document.location.reload()
  
  x += dx
  y += dy
###
  if rightPressed and paddleX < canvas.width-paddleWidth
    paddleX += 7
  else if leftPressed and paddleX > 0
    paddleX -= 7

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
