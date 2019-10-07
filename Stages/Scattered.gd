extends Stage

const Star = preload("res://Items/Star.tscn")

export var STAR_NUMBER = 5
export var SCATTER_SPEED = 700.0
export var MAX_RANDOM_TIMES = 1000.0
export var STAR_RANGE_X = [32, 298]
export var STAR_RANGE_Y = [256, 896]

onready var subview = $Viewport
onready var sprite = $Sprite
onready var block = $Block/CollisionShape2D
onready var stars = $Stars
onready var maze = $Viewport/Maze

var started = false
var reversed = false
var random_times = MAX_RANDOM_TIMES
var remaining_stars = -1


func _ready():
    var p = (STAR_RANGE_Y[1] - STAR_RANGE_Y[0]) / STAR_NUMBER
    for i in range(STAR_NUMBER):
        var star = Star.instance()
        star.position = Vector2(
            rand_range(STAR_RANGE_X[0], STAR_RANGE_X[1]),
            STAR_RANGE_Y[0] + p * i + rand_range(0, p)
        )
        star.connect("interacted", self, "_on_interact")
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
    reversed = false
    block.disabled = false


func recover():
    started = true
    reversed = true
    

func recover_end():
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
    random_times += delta * SCATTER_SPEED * (-1 if reversed else 1)
    if reversed and random_times <= 0:
        self.random_times = 0
        started = false
        recover_end()
    elif not reversed and random_times >= MAX_RANDOM_TIMES:
        self.random_times = MAX_RANDOM_TIMES
        started = false
    var mat = sprite.get_material()
    mat.set_shader_param("random_times", floor(random_times))


func _on_StageManager_started():
    $Words.display()


func _on_interact(star):
    star.queue_free()
    remaining_stars -= 1
    Utils.play_complete_sound()
    if remaining_stars <= 0:
        $Words2.display()


func _on_StageManager_typing_end(text):
    if Utils.check_phrase("Nothing gets scattered", text):
        finish_sentence()
        recover()
    else:
        scatter()
