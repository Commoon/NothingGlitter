tool
extends Node2D

class_name StageManager

export var typing_speed = 4.5
export var starting_pause = 0.5
export var goal_position = Vector2(1040, 720) setget set_goal_position

onready var title_text = $TitleText
onready var player = $Player
onready var goal = $Goal
var started = false
var showing_player = -1
var typing = -1


func _ready():
    title_text.visible_characters = 0
    player.hide()
    goal.hide()
    title_text.text = "Stage %d: Nothing" % get_parent().STAGE_NUMBER
    typing = 0


func _process(delta):
    if title_text == null || typing < 0:
        return
    var n = title_text.text.length()
    if typing < n:
        typing = min(typing + delta * typing_speed, n)
        title_text.visible_characters = floor(typing)
        showing_player = 0
    elif not started:
        showing_player += delta
        if showing_player >= 2 * starting_pause:
            goal.show()
            started = true
        elif showing_player >= starting_pause:
            player.show()


func set_goal_position(value):
    goal_position = value
    if goal != null:
        goal.position = value
