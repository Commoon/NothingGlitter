extends Node

const STAGE_NAMES = [
    "Stage 0", "Simple Maze",
    "Glitters", "Tilted Stick",
    "Gold Experience",
    "Scattered",
    "Arrows"
]

var current_stage = null
var current_stage_number = 0
var main_scene: Node = null
var player = null
var max_cleared_stage = 0

var paused = false


func _enter_tree():
    randomize()
    

func win():
    if main_scene == null:
        return
    main_scene.get_node("Completed").show()
    main_scene.paused = 0
    get_tree().paused = true
    if current_stage_number + 1 > max_cleared_stage and current_stage_number + 1 < STAGE_NAMES.size():
        max_cleared_stage = current_stage_number + 1
    paused = true


func next_stage():
    start(current_stage_number + 1)


func start(index):
    if current_stage != null:
        player = null
        current_stage.queue_free()
    var stage_scene
    if index >= STAGE_NAMES.size():
        current_stage_number = -2
        stage_scene = load("res://Game/Ending.tscn")
    elif index == -1:
        current_stage_number = -1
        stage_scene = load("res://Game/Menu.tscn")
    else:
        current_stage_number = index
        var stage_name = STAGE_NAMES[index]
        stage_scene = load("res://Stages/%s.tscn" % stage_name)
    var new_stage = stage_scene.instance()
    var world_environment = main_scene.get_node("WorldEnvironment")
    main_scene.add_child_below_node(world_environment, new_stage)
    main_scene.get_node("Completed").hide()
    get_tree().paused = false
    paused = false
    current_stage = new_stage
