extends RigidBody2D

export (float) var speed = 200.0
export (float) var maxRotationSpeed = 0.5

onready var StateMachine = preload('res://lib/StateMachine.gd')
onready var States = preload('./States.gd')
onready var common = get_node('/root/libCommon')
onready var life = 100.0
onready var killAnmimation = preload('res://explosion/explosion_02/Explosion.tscn').instance()

export (float) var detectionRadius = 100.0

var sm
var elapsed = 0
var transitionTimeout = 0.500
var pointsToDraw = []

func _ready():
    sm = StateMachine.StateMachine.new(common, self,
        States.getStatesDictionary(),
        States.getStartStateName())
    sm.connect('newState', self, 'onNewState')
    $Sensor.connect('body_entered', self, 'onPlayerDetected', [], CONNECT_DEFERRED)
    $Sensor.connect('body_exited', self, 'onPlayerLoose', [], CONNECT_DEFERRED)
    _createAreaCollision()

func _createAreaCollision():
    var area = Area2D.new()
    area.monitorable = false
    area.monitoring = true
    area.set_collision_mask_bit(libCommon.CollisionLayer.BulletPlayer, true)
    area.add_child($CollisionShape2D.duplicate())
    area.connect('area_entered', self, 'onHit')
    add_child(area)

func addPointToDraw(point, radius, color):
    getLevel().addPointToDraw(point, radius, color)

func clearPointsToDraw():
    getLevel().clearPointsToDraw()

func onNewState(name):
#    print('[%s:newState]' % get_instance_id(), name)
    pass

func setLife(value):
    common.setLife(self, value)

func kill():
    common.kill(self)
    call_deferred('_remove')

func _draw():
    for ptd in pointsToDraw:
        draw_circle(ptd[0], ptd[1], ptd[2])

func _process(delta):
    pass

func _physics_process(delta):
    elapsed += delta
    if elapsed < transitionTimeout:
        return
    elapsed -= transitionTimeout
    sm.request(elapsed)

func getLevel():
    var nodePath = '/root/Game/LevelManager/Level'
    if not has_node(nodePath):
        return null
    return get_node(nodePath)

func getAirPaths():
    var nodePath = '/root/Game/LevelManager/Level/AirPath'
    if not has_node(nodePath):
        return null
    return get_node(nodePath).get_children()

func getNavigation():
    var nodePath = '/root/Game/LevelManager/Level/Navigation2D'
    if not has_node(nodePath):
        return null
    return get_node(nodePath)

func onPlayerDetected(entity):
    sm.setState('chase', {'target': entity})
    $WeaponSystem.setAutoFire(true)
    $WeaponSystem.immediateFire()

func onPlayerLoose(entity):
    $WeaponSystem.setAutoFire(false)
    sm.setState('idle')

func onHit(entity):
    print('onHit')
    common.hit(self, killAnmimation)

func _remove():
    queue_free()