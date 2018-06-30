extends Area2D

export (String, 'Cone', 'Circle') var detectionType = 'Cone'
export (float) var detectionLength = 400.0
export (float) var detectionWidth = 400.0

onready var common = get_node('/root/libCommon')

var availableShapes = {}

func _init():
    pass

func _ready():
    for shape in get_children():
        availableShapes[shape.get_name()] = shape
        remove_child(shape)
    setShape(detectionType)

func setShape(name):
    for shape in get_children():
        remove_child(shape)
    var shape = availableShapes[detectionType]
    add_child(shape)
    var method_name = '_shape_init_%s' % detectionType.to_lower()
    call(method_name)

func _shape_init_cone():
    get_node(detectionType).shape.points[1] = Vector2(detectionWidth / 2, detectionLength)
    get_node(detectionType).shape.points[2] = Vector2(-detectionWidth / 2, detectionLength)

func _shape_init_circle():
    get_node(detectionType).shape.radius = detectionLength
