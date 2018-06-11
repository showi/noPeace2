extends Area2D

export (Vector2) var SPEED

onready var common = get_node('/root/libCommon')

var screensize
var engine = null
var weaponSystem = null
var world = null

func _init():
    pass

func _ready():
    set_meta('entityKind', 'Player')
    screensize = common.getScreenSize()
    world = common.getLevelEntity('LevelDefault/bullets')
    engine = get_node('Engine')
    weaponSystem = get_node("WeaponSystem")
    connect('area_entered', self, 'hit')

func hit(entity):
    var kind = common.getEntityKind(entity)

func _process(delta):
    if Input.is_action_pressed("ui_right"):
        self.engine.right()
    if Input.is_action_pressed("ui_left"):
        self.engine.left()
    if Input.is_action_pressed("ui_down"):
        self.engine.down()
    if Input.is_action_pressed("ui_up"):
        self.engine.up()

    if self.engine.velocity:
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()

    position += self.engine.velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, - screensize.y * 25, screensize.y)
    if Input.is_action_just_released('ui_accept'):
        weaponSystem.releaseFire()
    elif Input.is_action_just_pressed('ui_accept'):
        weaponSystem.pressFire()

    if self.engine.velocity.x < 0:
        $AnimatedSprite.animation = "left"
        $AnimatedSprite.flip_v = false
    elif self.engine.velocity.x > 0:
        $AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = false
    elif self.engine.velocity.x == 0:
        $AnimatedSprite.animation = "up"
