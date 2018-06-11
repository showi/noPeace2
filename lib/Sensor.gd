extends Area2D

signal detected(kind, entity)
signal loose(kind, entity)

export (String, 'Player', 'Enemy') var entityKindToDetect
export (float) var detectionLength = 100.0
export (float) var detectionWidth = 20.0

onready var common = get_node('/root/libCommon')

func _init():
    pass

func _ready():
    $detection.shape.points[1] = Vector2(detectionWidth / 2, detectionLength)
    $detection.shape.points[2] = Vector2(-detectionWidth / 2, detectionLength)
    connect('area_entered', self, 'detected')
    connect('area_exited', self, 'loose')

func detected(entity):
    var kind = common.getEntityKind(entity)
    if kind == entityKindToDetect:
        emit_signal('detected', kind, entity)

func loose(entity):
    var kind = common.getEntityKind(entity)
    if kind == entityKindToDetect:
        emit_signal('loose', kind, entity)