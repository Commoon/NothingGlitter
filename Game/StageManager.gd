extends Node2D

signal typing_end
signal started

class_name StageManager

export var typing_speed = 6
export var starting_pause = 0.5
export var goal_position = Vector2(1040, 720) setget set_goal_position

onready var title_text = $TitleText
onready var goal = $Goal
var started = false
var showing_player = -1
var typing = -1


func _ready():
    title_text.visible_characters = 0
    goal.hide()
    set_goal_position(goal_position)
    title_text.bbcode_text = "Stage %d: Nothing" % Game.current_stage_number
    typing = 0
    showing_player = 0


func _process(delta):
    if typing < 0 or title_text == null:
        return
    var n = title_text.text.length()
    if typing < n:
        typing = min(typing + delta * typing_speed, n)
        title_text.visible_characters = floor(typing)
        if typing == n:
            emit_signal("typing_end", title_text.text)
    elif not started:
        showing_player += delta
        if showing_player >= 2 * starting_pause:
            goal.show()
            started = true
            emit_signal("started")
        elif showing_player >= starting_pause:
            Game.player.show()


func set_goal_position(value):
    goal_position = value
    if goal != null:
        goal.position = value
