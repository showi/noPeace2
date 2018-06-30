extends RigidBody2D

export (float) var speed = 200
export (float) var life = 10
export (float) var lifeTime = 6000.0
export (float) var points = 250

signal lifeChanged(value)
signal hasBeenKilled()

onready var common = get_node('/root/libCommon')

var world
var killTimer
var killAnimation
var weaponSystem
var engine
var enemyInSight = false
var isDestroyed = false

func _init():
    set_meta('entityKind', 'Enemy')
    killTimer = Timer.new()
    killTimer.set_wait_time(lifeTime)
    killTimer.one_shot = true
    killTimer.connect('timeout', self, '_remove', [], CONNECT_DEFERRED)
    add_child(killTimer)

func _ready():
    makeCollisionArea()
    killAnimation = common.getResource('explosion', 'explosion_02')
    weaponSystem = $WeaponSystem
    engine = $Engine
    world = common.getLevelEntity('LevelDefault/bullets')
    linear_velocity = Vector2(0, -speed).rotated(get_global_rotation())
    killTimer.start()

func makeCollisionArea():
    var area = Area2D.new()
    area.add_child($CollisionShape2D.duplicate(DUPLICATE_USE_INSTANCING))
    area.monitorable = false
    area.monitoring = true
    area.collison_mask = 0
    area.set_collision_mask_bit(common.CollisionLayer.BulletPlayer, true)
    area.connect('area_entered', self, 'hit')
    add_child(area)

func setLife(value):
    common.setLife(self, value)

func hit(entity):
    common.hit(self, entity)

func _process(delta):
    if life <= 0:
        return kill()

func kill():
    common.kill(self, killAnimation)
    common.addPlayerStat('score', points)
    emit_signal('hasBeenKilled')
    call_deferred('_remove')

func remove():
    call_deferred('_remove')

func _remove():
    queue_free()
