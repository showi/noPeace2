extends StaticBody2D

onready var common = get_node('/root/libCommon')

func _ready():
    $CollisionPolygon2D.polygon = $Polygon2D.polygon
    $Area2D.add_child($CollisionPolygon2D.duplicate())
    $Area2D.connect('area_entered', self, 'hit')

func hit(entity):
    entity.kill()