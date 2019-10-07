extends Node2D


export var PAUSE_TIME = 0.5

var paused = 0


func _ready():
    pause_mode = Node.PAUSE_MODE_PROCESS
    Game.start(4)


func _enter_tree():
    Game.main_scene = self


func _process(delta):
    if Game.paused and paused >= 0:
        paused += delta
        if paused >= PAUSE_TIME:
            paused = -1


func _unhandled_input(event):
    if paused < 0 and (event.is_action_released("search") or event.is_action_released("cancel")):
        Game.next_stage()
