extends Node2D

var points = 1000

onready var common = get_node('/root/libCommon')

var lastPosition = Vector2(0, 0)

var loots = []
var aliveUnits

func _ready():
    initUnits()
    initLoots()

func initUnits():
    aliveUnits = $Units.get_child_count()
    assert aliveUnits != 0
    for unit in $Units.get_children():
        unit.connect('hasBeenKilled', self, 'decreaseAliveUnits')

func decreaseAliveUnits():
    aliveUnits -= 1

func initLoots():
    for loot in $Loots.get_children():
        loots.append(loot)
    remove_child($Loots)

func _process(delta):
    var childCount = $Units.get_child_count()
    if not childCount:
        kill()
    else:
        lastPosition = $Units.get_child(0).get_global_position()

func loot():
    if not loots:
        return
    if aliveUnits > 0:
        return
    var loot = loots[0].duplicate(DUPLICATE_USE_INSTANCING)
    loot.set_global_position(lastPosition)
    get_node('/root/Game/LevelManager/Level').add_child(loot)

func kill():
    loot()
    call_deferred('_remove')

func _remove():
    queue_free()
