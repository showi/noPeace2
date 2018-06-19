extends RigidBody2D

export (float) var speed = 200
export (float) var life = 10
export (float) var lifeTime = 10.0
export (float) var points = 250

signal lifeChanged(value)

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
    killTimer.connect('timeout', self, 'kill')
    add_child(killTimer)

func _ready():
    makeCollisionArea()
    killAnimation = common.getResource('explosion', 'explosion_02')
    weaponSystem = $WeaponSystem
    engine = $Engine
    world = common.getLevelEntity('LevelDefault/bullets')
    $Sensor.connect('detected', self, 'detected')
    $Sensor.connect('loose', self, 'loose')
    killTimer.start()

func makeCollisionArea():
    var area = Area2D.new()
    area.add_child($CollisionShape2D.duplicate())
    area.monitorable = false
    area.monitoring = true
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
    engine.up()

func kill():
    common.kill(self, killAnimation)
    common.addPlayerStat('score', points)
    call_deferred('_remove')

func _remove():
    var parent = get_parent()
    if not parent:
        return
    queue_free()