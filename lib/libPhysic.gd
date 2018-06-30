extends Node

static func clampVector(v, vMin, vMax):
    return Vector2(
        absclamp(v.x, vMin.x, vMax.x),
        absclamp(v.y, vMax.y, vMax.y)
    )

static func absclamp(value, minValue, maxValue):
    var valueSign = 1 if value > 0 else -1
    value = abs(value)
    return valueSign * clamp(value, minValue, maxValue)

static accelerate(entity, delta):
    entity.linear_velocity += entity.speed * delta