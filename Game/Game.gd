extends Node

const MAX_STAGE = 2

var current_stage: Stage = null
var main_scene: Node = null

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
    var number = current_stage.STAGE_NUMBER
    var world_environment = main_scene.get_node("WorldEnvironment")
    number = (number + 1) % (MAX_STAGE + 1)
    var stage_scene = load("res://Stages/Stage %d.tscn" % number) if number < MAX_STAGE else \
        load("res://Game/Ending.tscn")
    current_stage.queue_free()
    var new_stage = stage_scene.instance()
    main_scene.add_child_below_node(world_environment, new_stage)
    main_scene.paused = 0
    main_scene.get_node("Completed").hide()
    get_tree().paused = false
    paused = false
