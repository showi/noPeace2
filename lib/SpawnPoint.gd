extends Area2D

export (float) var detectionRadius = 100.0
export (bool) var oneShot = false
export (int) var maxEntitySpawned = 0
export (float) var spawnSec = 3.0

onready var common = get_node('/root/libCommon')

export (String, 'enemy', 'explosion') var entityKind = 'enemy'
export (String) var entityName = 'spaceship01'

var entityClass = null
var entitySpawner = null
var level = null
var entityCount = 0

var CONNECT_FLAGS = CONNECT_ONESHOT

func _init():
    entitySpawner = Timer.new()
    entitySpawner.set_wait_time(spawnSec)
    entitySpawner.one_shot = false
    entitySpawner.connect('timeout', self, 'spawn')

func _ready():
    level = common.getLevelManager()
    apply_scale(Vector2(detectionRadius, detectionRadius))
    connect('area_entered', self, 'on_area_entered', [], CONNECT_FLAGS)
    connect('area_exited', self, 'on_area_exited', [], CONNECT_FLAGS)    
    add_child(entitySpawner)
    entityClass = common.getResource(entityKind, entityName)

func on_area_entered(area):
    entitySpawner.start()
    spawn()

func on_area_exited(area):
    pass

func _remove():
    get_parent().remove_child(self)

func spawn():
    if maxEntitySpawned and entityCount > maxEntitySpawned:
        entitySpawner.stop()
        return
    entityCount += 1
    var entity = entityClass.instance()
    var pos = get_global_position()
    entity.set_global_position(get_position())
    entity.set_global_rotation(get_rotation())
    level.add_child(entity)
