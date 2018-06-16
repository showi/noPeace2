extends Area2D

export (Color) var color = Color('#1f1')
export (float) var life = 100.0

signal lifeChanged(value)
onready var common = get_node('/root/libCommon')

func _ready():
    $Sprite.set_modulate(color)
    connect('body_entered', self, 'hit')
    $Life.connect('gauge_min', self, 'on_shield_off', [false])

func hit(entity):
    print('hit')
    common.setLife(self, life - entity.damage)

func on_shield_off(value):
    print('shield off')
