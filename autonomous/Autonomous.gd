extends RigidBody2D

export (float) var speed = 200.0

onready var StateMachine = preload('res://lib/StateMachine.gd')
onready var States = preload('./States.gd')
onready var common = get_node('/root/libCommon')

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
    $Sensor.connect('area_entered', self, 'onPlayerDetected', [], CONNECT_DEFERRED)
    $Sensor.connect('area_exited', self, 'onPlayerLoose', [], CONNECT_DEFERRED)

func addPointToDraw(point, radius, color):
    print('auto: ', point)
    getLevel().addPointToDraw(point, radius, color)

func clearPointsToDraw():
    getLevel().clearPointsToDraw()

func onNewState(name):
    print('[%s:newState]' % get_instance_id(), name)

func _draw():
    for ptd in pointsToDraw:
        draw_circle(ptd[0], ptd[1], ptd[2])

func _process(delta):
    elapsed += delta
    if elapsed > transitionTimeout:
        elapsed -= transitionTimeout
        sm.request(transitionTimeout)

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

func onPlayerLoose(entity):
    sm.setState('idle')
