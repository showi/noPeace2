extends Node2D

export (int) var timeout = 2

var timer

func _init():
    timer = Timer.new()
    timer.one_shot = true
    timer.set_wait_time(timeout)
    timer.connect('timeout', self, 'kill')
    add_child(timer)

func _ready():
    timer.start()

func kill():
    hide()
    call_deferred('_remove')

func _remove():
    get_parent().remove_child(self)
    queue_free()
