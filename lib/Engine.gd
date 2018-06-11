extends Node

export (int) var speed = Vector2(5, 8)
export (Vector2) var minVelocity = Vector2(0, 0)
export (Vector2) var maxVelocity = Vector2(400, 600)

var velocity = null
var disabled = false
var timer = null

func _init():
    velocity = minVelocity
    timer = Timer.new()
    timer.set_wait_time(0.100)
    timer.one_shot = true
    timer.connect('timeout', self, 'enable')
    add_child(timer)

func up():
    velocity.y -= speed.y
    velocity.y = - clamp(- velocity.y, minVelocity.y, maxVelocity.y)

func down():
    velocity.y += speed.y
    velocity.y = clamp(velocity.y, minVelocity.y, maxVelocity.y)

func right():
    if velocity.x < -1:
        velocity.x = 0
        disable()
    if disabled:
        return
    else:
        velocity.x += speed.x
        velocity.x = clamp(velocity.x, minVelocity.x, maxVelocity.x)

func left():
    if velocity.x > 0:
        velocity.x = 0
        disable()
    if disabled:
        return
    else:
        velocity.x -= speed.x
        velocity.x = - clamp(-velocity.x, minVelocity.x, maxVelocity.x)

func enable():
    disabled = false

func disable(time=0.1):
    disabled = true
    timer.set_wait_time(time)
    timer.start()