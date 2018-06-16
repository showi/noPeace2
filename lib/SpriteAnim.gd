extends Node2D

export (float) var speed = 0.1
export (bool) var loop = false
export (bool) var autoRemove = true

var currentIndex = 0
var elapsed = 0
var stopped = false

onready var sprite = $Sprite

func _ready():
    start()

func stop():
    hide()
    stopped = true

func start():
    currentIndex = 0
    stopped = false

func _remove():
    get_parent().remove_child(self)

func kill():
    call_deferred('_remove')

func _process(delta):
    if stopped:
        return
    elapsed += delta
    if elapsed > speed:
        elapsed -= speed
        currentIndex += 1
        if currentIndex >= sprite.hframes:
            if not loop:
                stop()
                if autoRemove:
                    kill()
            currentIndex = 0
        sprite.set_frame(currentIndex)
