extends Control

signal gauge_min(name, value)
signal gauge_max(name, value)

export (String) var gaugeName = "One Gauge"
export (float) var minimum = 0.0
export (float) var maximum = 100.0
export (float) var value = 100.0
export (Color) var color = Color(0, 1, 0, 1)

var gauge = null
var gaugeDefaultSize = null

func getPercentage():
    return clamp(value, minimum, maximum) / maximum * 100

func _ready():
    gauge = $Gauge
    gauge.color = color
    gaugeDefaultSize = gauge.get_size()
    $Label.text = gaugeName

func setValue(_value):
    value = clamp(_value, minimum, maximum)
    if value == minimum:
        emit_signal('gauge_min', value)
    elif value == maximum:
        emit_signal('gauge_max', value)
    var size = gauge.get_size()
    size.x = value
    gauge.set_size(size)
