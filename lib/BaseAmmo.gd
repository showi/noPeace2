extends Area2D

export (int) var damage = 20
export (float) var fullPowerTime = 1.0
export (int) var speed = 400
export (float) var powerFactorDefault = 1.0
export (int) var timeout = 5

var shooter = null
var powerFactor = powerFactorDefault
var timer = null
var velocity = null
var world = null
var hitDamage = null

func _init():
    hide()
    set_meta('entityKind', 'Ammo')
    velocity = null
    initTimer()    

func _ready():
    set_global_position(shooter.get_global_position())
    var totalSpeed = clamp(abs(shooter.engine.velocity.y), 0, 1000) + speed
    velocity = Vector2(0, 1).rotated(get_rotation()) * totalSpeed
    show()

func _process(delta):
    if velocity:
        position += velocity * delta

func fire(_world, _shooter, pctCharging):
    world = _world
    shooter = _shooter
    powerFactor = 1 + (pctCharging / 100) * 2.0
    hitDamage = damage * powerFactor
    apply_scale(Vector2(powerFactor, powerFactor))
    set_global_rotation(shooter.get_global_rotation())
    set_global_position(shooter.get_position())
    timer.start()
    world.add_child(self)

func kill():
    $CollisionShape2D.disabled = true
    hide()
    velocity = null
    call_deferred('_remove')

func _remove():
    world.remove_child(self)

func initTimer():
    timer = Timer.new()
    timer.set_wait_time(timeout)
    timer.autostart = false
    timer.process_mode = timer.TIMER_PROCESS_IDLE
    timer.one_shot = true
    timer.connect("timeout", self, 'kill')
    add_child(timer)
