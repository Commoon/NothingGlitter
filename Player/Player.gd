extends KinematicBody2D

export var SPEED: float = 500
var velocity = Vector2.ZERO

var to_interact: Node2D = null
var started = false


func _ready():
    hide()


func _enter_tree():
    Game.player = self


func _physics_process(delta):
    if not started:
        return
    var x = -1 * Input.get_action_strength("left") + 1 * Input.get_action_strength("right")
    var y = -1 * Input.get_action_strength("up") + 1 * Input.get_action_strength("down")
    velocity = Vector2(x, y).normalized() * SPEED
    move_and_slide(velocity)


func _input(event):
    if not Game.current_stage.stage_manager.started:
        return
    if event.is_action_released("search") and to_interact != null:
        to_interact.call("interact", self)
    elif event.is_action_released("cancel"):
        Game.current_stage.remove_word()

