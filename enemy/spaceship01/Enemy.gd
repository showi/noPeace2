extends 'res://lib/BaseEnemy.gd'

func detected(kind, entity):
    $WeaponSystem.setAutoFire(true)
    $WeaponSystem.immediateFire()

func loose(kind, entity):
    $WeaponSystem.setAutoFire(false)
