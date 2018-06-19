extends Area2D

export (String, 'life') var powerupKind = 'life'
export (float) var value = 100.0
export (int) var lootProbabiliy = 10

func _ready():
    connect('area_entered', self, 'on_pickup')
    
func on_pickup(entity):
    entity.get_parent().powerupPickup(powerupKind, value)
    kill()

func kill():
    call_deferred('_remove')

func _remove():
    queue_free()