extends Area2D

export (float) var speed = 200
export (float) var life = 10
export (float) var lifeTime = 10.0

onready var common = get_node('/root/libCommon')

var world
var killTimer
var killAnimation
var weaponSystem
var engine
var enemyInSight = false

func _init():
    set_meta('entityKind', 'Enemy')
    killTimer = Timer.new()
    killTimer.set_wait_time(lifeTime)
    killTimer.one_shot = true
    killTimer.connect('timeout', self, 'kill')
    add_child(killTimer)

func _ready():
    killAnimation = common.getResource('explosion', 'explosion_02')
    weaponSystem = $WeaponSystem
    engine = $Engine
    world = common.getLevelEntity('LevelDefault/bullets')
    killTimer.start()
    engine.up()
    connect('area_entered', self, 'hit')

func hit(entity):
    var kind = common.getEntityKind(entity)
    if kind == 'Ammo':
        var shooterKind = common.getEntityKind(entity.shooter)
        if shooterKind == 'Player':
            entity.kill()
            life -= entity.hitDamage

func _process(delta):
    if life <= 0:
        return kill()
    var velocity = Vector2(0, 1).rotated(get_rotation())  * speed * delta
    position += velocity
    position += engine.velocity * delta

func kill():
    hide()
    killTimer.stop()
    var animation = killAnimation.instance()
    animation.set_scale(Vector2(4, 4))
    animation.set_position(get_global_position())
    common.getLevelEntity('LevelDefault/explosions').add_child(animation)
    call_deferred('_remove')

func _remove():
    get_parent().remove_child(self)