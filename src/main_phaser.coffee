ball = null

preload = () ->
  game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
  game.scale.pageAlignHorizontally = true
  game.scale.pageAlignVertically = true
  game.stage.backgroundColor = '#eee'
  game.load.image('ball', 'img/ball.png')

create = () ->
  ball = game.add.sprite(50, 50, 'ball')
update = () -> 
  ball.x += 1
  ball.y += 1

game = new Phaser.Game(480, 320, Phaser.AUTO, null,
  preload: preload
  create: create
  update: update
)