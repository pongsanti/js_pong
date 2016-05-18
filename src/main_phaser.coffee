ball = null

preload = () ->
  game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
  game.scale.pageAlignHorizontally = true
  game.scale.pageAlignVertically = true
  game.stage.backgroundColor = '#eee'
  game.load.image('ball', 'img/ball.png')

create = () ->
  game.physics.startSystem(Phaser.ARCADE)
  ball = game.add.sprite(50, 50, 'ball')
  game.physics.enable(ball, Phaser.Physics.ARCADE)
  
  ball.body.collideWorldBounds = true
  ball.body.bounce.set(1)

  ball.body.velocity.set(150, 150)

update = () -> 

game = new Phaser.Game(480, 320, Phaser.AUTO, null,
  preload: preload
  create: create
  update: update
)