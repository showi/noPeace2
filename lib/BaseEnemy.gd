extends RigidBody2D

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
    connect('body_entered', self, 'hit')
    killTimer.start()


func hit(entity):
    var kind = common.getEntityKind(entity)
    if kind == 'Ammo':
        var shooter = entity.getShooter()
        if not shooter:
            return
        var shooterKind = common.getEntityKind(shooter)
        if shooterKind == 'Player':
            entity.kill()
            life -= entity.hitDamage

func _process(delta):
    if life <= 0:
        return kill()
    engine.up()

func kill():
    common.kill(self, killAnimation)
    call_deferred('_remove')
    
func _remove():
    get_parent().remove_child(self)
    queue_free()
