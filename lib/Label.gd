extends GridContainer

export (String) var key = '[key]'
export (String) var value = '[value]'

func _ready():
    setKeyValue(key, value)

func setKeyValue(_key, _value):
    $name.text = _key
    $value.text = _value