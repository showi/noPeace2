extends Line2D

onready var common = get_node('/root/libCommon')

func _ready():
    assert points.size() == 2
    var area = Area2D.new()
    area.monitorable = false
    area.monitoring = true
    area.collision_mask = 0
    area.collision_layer = 0
    for layer in [common.CollisionLayer.BulletPlayer, common.CollisionLayer.BulletEnemy]:
        area.set_collision_mask_bit(layer, true)
    var collisionShape = CollisionShape2D.new()
    var rectangleShape = RectangleShape2D.new()
    rectangleShape.extents = Vector2(width / 2, points[0].distance_to(points[1]) / 2)
    collisionShape.shape = rectangleShape
    collisionShape.position = points[0] + ((points[1] - points[0]) / 2)
    area.add_child(collisionShape)
    add_child(area)
    area.connect('area_entered', self, 'hit')
    var body = StaticBody2D.new()
    for layer in [common.CollisionLayer.Player, common.CollisionLayer.Enemy]:
        body.set_collision_layer_bit(layer, true)
    body.add_child(collisionShape.duplicate())
    add_child(body)

func hit(entity):
    pass
#    entity.get_parent().kill()