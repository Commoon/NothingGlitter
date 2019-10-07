extends Node2D


export var PAUSE_TIME = 0.5

var paused = -1
var homing = false


func _ready():
    Game.start(-1)
    Utils.se_player = $SEPlayer
    Utils.word_player = $WordPlayer


func _enter_tree():
    Game.main_scene = self


func _process(delta):
    if paused >= 0:
        paused += delta
        if paused >= PAUSE_TIME:
            paused = -1


func stop_homing(yes):
    homing = false
    $ReturnToMenu.hide()
    get_tree().paused = false
    if yes:
        Game.start(-1)


func _unhandled_input(event):
    var is_search = event.is_action_released("search")
    var is_cancel = event.is_action_released("cancel")
    var is_home = event.is_action_released("home")
    if Game.paused:
        if paused < 0 and (is_search or is_cancel):
            Game.next_stage()
        return
    if homing:
        if is_search:
            stop_homing(true)
        elif is_cancel or is_home:
            stop_homing(false)
    elif Game.current_stage_number >= 0 and is_home:
        homing = true
        $ReturnToMenu.show()
        paused = 0
        get_tree().paused = true
