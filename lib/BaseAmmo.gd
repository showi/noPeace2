extends Area2D

export (int) var damage = 20
export (float) var fullPowerTime = 1.0
export (int) var speed = 400
export (float) var powerFactorDefault = 1.0
export (float) var timeout = 5
export (bool) var oneWayCollsion = true

onready var common = get_node('/root/libCommon')

var timer = null
var velocity = Vector2(0, 0)
var hitDamage = 0
var initialVelocity = 0
var weaponSystemRef = null
var engine = null

func _init():
    set_meta('entityKind', 'Ammo')

func _ready():
    hide()
    initTimer()

func _process(delta):
    if velocity:
        position += velocity * delta

func setWeaponSystem(obj):
    weaponSystemRef = weakref(obj)
    set_collision_layer_bit(obj.ammoCollisionLayer, true)

func getWorld():
    return get_node('/root/Game/LevelManager/Level')

func getShooter():
    var ref = weaponSystemRef.get_ref()
    if not ref:
        return null
    return ref.get_parent()

func fire(powerFactor=powerFactorDefault):
    var shooter = getShooter()
    if shooter.has_node('Engine'):
        initialVelocity = clamp(abs(shooter.linear_velocity.y), 1, 1000)
    var totalSpeed =  initialVelocity + speed
    hitDamage = damage + damage * powerFactor
    set_global_rotation(shooter.get_global_rotation())
    velocity = Vector2(0, -1).rotated(shooter.get_global_rotation()) * totalSpeed
    apply_scale(Vector2(1 + powerFactor, 1 + powerFactor))
    timer.start()
    show()

func kill():
    $CollisionShape2D.disabled = true
    hide()
    call_deferred('_remove')

func _remove():
    var world = getWorld()
    queue_free()

func initTimer():
    timer = Timer.new()
    timer.set_wait_time(timeout)
    timer.autostart = false
    timer.process_mode = timer.TIMER_PROCESS_IDLE
    timer.one_shot = true
    timer.connect("timeout", self, 'kill')
    add_child(timer)
