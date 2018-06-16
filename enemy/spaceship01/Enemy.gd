extends 'res://lib/BaseEnemy.gd'

func detected(kind, entity):
    $WeaponSystem.setAutoFire(true)
    $WeaponSystem.immediateFire()

func loose(kind, entity):
    $WeaponSystem.setAutoFire(false)

func _ready():
    $Sensor.connect('detected', self, 'detected')
    $Sensor.connect('loose', self, 'loose')
    ._ready()