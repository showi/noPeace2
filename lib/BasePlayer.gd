extends RigidBody2D

signal lifeSignal(value)
signal pressFire()
signal releaseFire()

export (float) var life = 100.0
export (float) var damage = 10.0

onready var common = get_node('/root/libCommon')

var screensize
var engine = null
var world = null
var killAnimation = null
var rotationSpeed = 10

func _init():
    set_meta('entityKind', 'Player')

func _ready():
    killAnimation = common.getResource('explosion', 'explosion_02')    
    connect('body_entered', self, 'hit')
    connect('pressFire', $WeaponSystem, 'pressFire')
    connect('releaseFire', $WeaponSystem, 'releaseFire')
    $WeaponSystem.connect("pctChargingSignal", $Hud/Power, 'setValue')
    connect('lifeSignal', $Hud/Life, 'setValue')
    screensize = common.getScreenSize()
    world = common.getLevelEntity('LevelDefault/bullets')
    if not world:
        world = get_parent()
    engine = get_node('Engine')

func hit(entity):
    common.hit(self, entity)

func setLife(value):
    life = value
    emit_signal('lifeSignal', value)
    if life <= 0:
        kill()

func kill():
    common.kill(self, killAnimation)
    call_deferred('_remove')

func _process(delta):
    var rspeed = 0.66
    if Input.is_action_pressed("ui_right"):
        engine.right()
    if Input.is_action_pressed("ui_left"):
        engine.left()
    if Input.is_action_pressed("ui_down"):
        engine.down()
    if Input.is_action_pressed("ui_up"):
        engine.up()

    if self.linear_velocity.length():
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()

    if Input.is_action_just_released('ui_fire'):
        emit_signal('releaseFire')
    elif Input.is_action_just_pressed('ui_fire'):
        emit_signal('pressFire')

    if engine.direction == engine.Direction.LEFT:
        $AnimatedSprite.animation = "left"
        $AnimatedSprite.flip_v = false
    elif engine.direction == engine.Direction.RIGHT:
        $AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = false
    elif engine.direction == engine.Direction.UP:
        $AnimatedSprite.animation = "up"
    elif engine.direction == engine.Direction.RIGHT:
        $AnimatedSprite.animation = "up"

func _remove():
    get_parent().remove_child(self)
    queue_free()
