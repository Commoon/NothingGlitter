extends Stage

const Star = preload("res://Items/Star.tscn")

export var STAR_NUMBER = 5
export var SCATTER_SPEED = 5.0
export var MAX_RANDOM_TIMES = 5
export var STAR_RANGE_X = [0, 1200]
export var STAR_RANGE_Y = [32, 192]

onready var subview = $Viewport
onready var sprite = $Sprite
onready var block = $Block/CollisionShape2D
onready var stars = $Stars
onready var maze = $Viewport/Maze

var started = false
var recovering = false
var random_times = MAX_RANDOM_TIMES
var remaining_stars = -1


func _ready():
    var p = (STAR_RANGE_X[1] - STAR_RANGE_X[0]) / STAR_NUMBER
    for i in range(STAR_NUMBER):
        var star = Star.instance()
        star.position = Vector2(
            STAR_RANGE_X[0] + p * i + rand_range(0, p),
            rand_range(STAR_RANGE_Y[0], STAR_RANGE_Y[1])
        )
        star.connect("interacted", self, "_on_interact")
        star.connect("dropped", self, "_on_star_dropped")
        stars.add_child(star)
    remaining_stars = stars.get_child_count()
    scatter()


func scatter():
    var goal = stage_manager.goal
    if goal.get_parent() == stage_manager:
        stage_manager.remove_child(goal)
        subview.add_child(goal)
    if maze.get_parent() == self:
        remove_child(maze)
        subview.add_child(maze)
    started = true
    recovering = false
    block.disabled = false


func recover():
    started = true
    recovering = true
    

func recover_end():
    started = false
    var goal = stage_manager.goal
    if goal.get_parent() == subview:
        subview.remove_child(goal)
        stage_manager.add_child(goal)
    if maze.get_parent() == subview:
        subview.remove_child(maze)
        add_child(maze)
    block.disabled = true


func _process(delta):
    if not started:
        return
    random_times += delta * SCATTER_SPEED
    if random_times >= MAX_RANDOM_TIMES:
        if recovering:
            random_times = 0
            recover_end()
        else:
            random_times = 1
    var mat = sprite.get_material()
    mat.set_shader_param("random_times", floor(random_times))


func _on_StageManager_started():
    $Words.display()


func _on_interact(star):
    star.drop()
    Utils.play_complete_sound()


func _on_star_dropped():
    remaining_stars -= 1
    if remaining_stars <= 0:
        Utils.play_complete_sound()
        $Words2.display()


func _on_StageManager_typing_end(text):
    if Utils.check_phrase("Nothing gets scattered", text):
        finish_sentence()
        recover()
    else:
        scatter()
