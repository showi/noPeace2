extends Area2D

export (float) var radius = 100.0
export (String, 'Player', 'Enemy', 'Ammo') var entityKindToDetect = 'Player'

signal detection(kind, entity, distance)
signal loose(kind, entity, distance)

onready var common = get_node('/root/libCommon')

func _ready():
    do_connect()
    setRadius(radius)

func do_connect():
    connect('area_entered', self, 'on_detection')
    connect('area_exited', self, 'on_loose')

func do_unconnect():
    disconnect('area_entered', self, 'on_detection')
    disconnect('area_entered', self, 'on_loose')

func on_detection(entity):
    var kind = common.getEntityKind(entity)
#    if kind == entityKindToDetect:
    emit_signal('detection', kind, entity, entity.get_global_position() -  get_global_position())

func on_loose(entity):
    var kind = common.getEntityKind(entity)
#    if kind == entityKindToDetect:
    emit_signal('loose', kind, entity, entity.get_global_position() - get_global_position() )

func setRadius(_radius):
    $CollisionShape2D.shape.radius = _radius