extends Node2D

export (float) var cooldown = 0.5
export (bool) var autoFire = false
export (int, 4, 5) var ammoCollisionLayer = 5
export (float) var fullPowerTime = 2.0

signal pctChargingSignal(percentage)

onready var common = get_node('/root/libCommon')

var ammo
var disabled = true
var elapsed = 0
var elapsedCoolDown = 0
var selectedAmmo

enum STATES {
    idle,
    charging,
    cooldown
}

var state = STATES.cooldown
var pctCharging = 0.0
var isAutofiring = false

func _init():
    pass

func _ready():
    loadAmmos()
    setAutoFire(autoFire)
    state = STATES.idle
    setPctCharging(0)

func loadAmmos():
    assert $Ammos.get_child_count() != 0
    selectedAmmo = $Ammos.get_child(0)

func getWorld():
    var world = common.getLevelEntity('LevelDefault/bullets')
    if not world:
        world = get_parent()
    return world

func setState(p_state):
    state = p_state

func setAutoFire(value):
    autoFire = value
    if autoFire:
        isAutofiring = true
    else:
        isAutofiring = false

func immediateFire():
    pressFire()
    releaseFire()

func pressFire():
    if state == STATES.charging:
        return releaseFire()
    elif state != idle:
        return
    elapsed = 0
    pctCharging = 0
    state = STATES.charging
    return true

func releaseFire():
    if state != STATES.charging:
        return false
    state = STATES.cooldown
    for cannon in $Cannons.get_children():
        ammo = selectedAmmo.duplicate(DUPLICATE_USE_INSTANCING)
        ammo.setWeaponSystem(self)
        ammo.set_global_position(cannon.get_global_position())
        getWorld().add_child(ammo)
        ammo.fire(pctCharging)
    setPctCharging(0)
    return true

func getShooter():
    return get_parent()

func setPctCharging(value):
        pctCharging = value
        emit_signal('pctChargingSignal', pctCharging * 100)

func _process(delta):
    if state == STATES.cooldown:
        if elapsedCoolDown < cooldown:
            elapsedCoolDown += delta
        else:
            elapsedCoolDown = 0
            state = STATES.idle
    if state == STATES.charging:
        elapsed += delta
        setPctCharging(clamp((elapsed / fullPowerTime), 0, 1.0))
    elif state == STATES.idle and isAutofiring:
        immediateFire()