extends StaticBody2D

onready var common = get_node('/root/libCommon')

func _ready():
    makeCollisionShape()

func makeCollisionShape():
    var polygon = $Polygon2D
    assert(polygon)
    var collision = CollisionPolygon2D.new()
    collision.polygon = polygon.polygon
    add_child(collision)
    var area = Area2D.new()
    area.add_child(collision.duplicate(DUPLICATE_USE_INSTANCING))
    area.set_collision_mask_bit(common.CollisionLayer.BulletPlayer, true)
    area.connect('area_entered', self, 'on_area_entered')
    add_child(area)

func on_area_entered(entity):
    entity.queue_free()