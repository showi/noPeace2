extends Node2D

var points = 1000

onready var common = get_node('/root/libCommon')

func _process(delta):
    var childCount = $Units.get_child_count()
    if not childCount:
        kill()

func kill():
    call_deferred('_remove')

func _remove():
    queue_free()

