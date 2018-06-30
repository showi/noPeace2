extends Node

onready var common = get_node('/root/libCommon')

class PatrolReachTrackState:
    var pathAndPoint

    func handle(sm):
        var entity = sm.entity
        if not pathAndPoint:
            pathAndPoint = sm.common.getClosestPointInPaths(entity, entity.getPaths())
            var path = pathAndPoint[0]
        else:
            var navPath = pathAndPoint[0]
            var targetPoint = entity.to_local(navPath.to_global(pathAndPoint[1]))
            var distance = targetPoint.length()
            if distance < 40:
                var follow = sm.common.attachEntityToPath(sm.entity, navPath, pathAndPoint[3])
                sm.setState('patrol', { 'onTrack': follow })
                return
            var navigation = entity.getNavigation()
            var path = sm.common.getNavigationPath(entity, navPath.to_global(pathAndPoint[1]), navigation)
            if not path:
                return sm.setState('idle')
            entity.addPointToDraw(path[1], 10, '#00a')
            sm.common.goTo(entity, path, 1, sm.delta)

class PatrolState:
    var onTrack = null

    func handle(sm):
        if not onTrack:
            return sm.setState('patrol:reachTrack')

    func on_exit(sm):
        if onTrack:
            sm.common.detachEntityFromTrack(sm.entity, onTrack)
            onTrack.queue_free()
            onTrack = null

class FindObjectiveState:
    var objectives = ['patrol']

    func handle(sm):
        for objective in objectives:
            if objective == 'patrol':
                if sm.entity.getPaths():
                    return sm.setState('patrol')
                else:
                    print('noPatrolPath')
        sm.setState('idle')

class ChaseState:
    const DETECTION_ANGLE_THRESHOLD = PI / 8
    var target

    func handle(sm):
        if not target:
            return sm.setState('idle')
        var entity = sm.entity
        var navigation = entity.getNavigation()
        if not navigation:
            return sm.setState('idle')
        var path = sm.common.getNavigationPath(entity, target, navigation)
        if not path:
            return sm.setState('idle')
        entity.addPointToDraw(path[1], 10, '#00a')
        var targetInfo = sm.common.goTo(entity, path, 200, sm.delta)
        var angle = Vector2(0, -1).angle_to(entity.to_local(target.get_global_position()))
        if abs(angle) < DETECTION_ANGLE_THRESHOLD:
            entity.startWeaponFiring()
        else:
            entity.stopWeaponFiring()

class IdleState:

    func handle(sm):
#        if sm.getElapsed() < 100:
#            return
        sm.setState('findObjective')

static func getStatesDictionary():
    return {
        'idle': IdleState,
        'findObjective': FindObjectiveState,
        'patrol': PatrolState,
        'patrol:reachTrack': PatrolReachTrackState,
        'chase': ChaseState
    }

static func getStartStateName():
    return 'idle'
