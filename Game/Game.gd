extends Node

const STAGE_NAMES = [
    "Stage 0", "Simple Maze",
    "Glitters", "Tilted Stick",
    "Gold Experience",
    "Scattered",
    "Arrows",
    "Ending"
]

var current_stage: Stage = null
var current_stage_number = 0
var main_scene: Node = null
var player = null

var paused = false


func _enter_tree():
    randomize()
    

func win():
    if main_scene == null:
        return
    main_scene.get_node("Completed").show()
    get_tree().paused = true
    paused = true


func next_stage():
    start(current_stage_number + 1)


func start(index):
    if index > STAGE_NAMES.size():
        return
    current_stage_number = index
    var stage_name = STAGE_NAMES[index]
    var stage_scene = load("res://Stages/%s.tscn" % stage_name)
    if current_stage != null:
        current_stage.queue_free()
    var new_stage = stage_scene.instance()
    var world_environment = main_scene.get_node("WorldEnvironment")
    main_scene.add_child_below_node(world_environment, new_stage)
    main_scene.paused = 0
    main_scene.get_node("Completed").hide()
    get_tree().paused = false
    paused = false
