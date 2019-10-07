extends Stage

export var STEM_COLOR = Color(0.5, 1, 0.5)
export var GROW_SPEED = [0.2, 0.5]
export var GROW_RANGE = 80.0
export var GROW_SIZE = [0.5, 1.0]
export var GROW_DELAY = 0.1
export var GROW_F = 0.03
export var GROW_FLOWER_SPEED = 5.0
export var GROW_FLOWER_ROTATION = 0.6
export var FLOWER_HUE = [0.67, 1.2]
export var FLOWER_SATURATION = [0.7, 0.7]
export var FLOWER_LIGHTNESS = [0.7, 0.7]

const Flower = preload("res://Items/Flower.tscn")

var paths = []
var growing = 0
var reversed = false
var started = false
var first_time = true
onready var plants = $Plants


func _ready():
    $Memory.position = $Player.position
    $Memory.hide()
    growing = paths.size()
    for each in $Paths.get_children():
        var path = each.get_node("PathFollow2D") as PathFollow2D
        var stem = Line2D.new()
        stem.default_color = STEM_COLOR
        stem.points = [path.global_position]
        paths.append([path, stem, 0.0, []])
        plants.add_child(stem)


func _on_StageManager_started():
    $Memory.show()
    grow()
    $Words.display()


func grow_flower(pos, rot):
    var r = rand_range(-GROW_RANGE, GROW_RANGE)
    var flower_position = pos + (Vector2.UP * r).rotated(rot)
    var flower = Flower.instance()
    var target_scale = rand_range(GROW_SIZE[0], GROW_SIZE[1])
    var h = rand_range(FLOWER_HUE[0], FLOWER_HUE[1])
    var s = rand_range(FLOWER_SATURATION[0], FLOWER_SATURATION[1])
    var v = rand_range(FLOWER_LIGHTNESS[0], FLOWER_LIGHTNESS[1])
    flower.position = flower_position
    plants.add_child(flower)
    flower.grow(GROW_FLOWER_SPEED, GROW_FLOWER_ROTATION, target_scale, Color.from_hsv(h, s, v))
    return flower


func _physics_process(delta):
    if not started:
        return
    for each in paths:
        var path = each[0] as PathFollow2D
        var stem = each[1] as Line2D
        var progress = each[2] as float
        var flowers = each[3] as Array
        if not reversed:
            if progress >= 1.0 + GROW_DELAY:
                continue
            var speed = rand_range(GROW_SPEED[0], GROW_SPEED[1])
            progress += speed * delta
            if progress >= 1.0:
                path.unit_offset = 1.0
                if progress >= 1.0 + GROW_DELAY:
                    growing -= 1
                    if growing == 0:
                        started = false
            else:
                path.unit_offset = progress
            for i in range(floor((progress - GROW_DELAY) / GROW_F) - flowers.size()):
                var p = path.unit_offset
                path.unit_offset = progress - GROW_DELAY
                flowers.append(grow_flower(path.global_position, path.rotation))
                path.unit_offset = p
            if path.unit_offset < 1.0:
                stem.add_point(path.global_position)
            each[2] = progress
        else:
            if progress <= 0.0:
                continue
            var speed = rand_range(GROW_SPEED[0], GROW_SPEED[1])
            progress -= speed * delta
            if progress <= GROW_DELAY:
                path.unit_offset = 0.0
                if progress <= 0:
                    growing += 1
                    if growing == paths.size():
                        started = false
            else:
                path.unit_offset = progress - GROW_DELAY
            for i in range(flowers.size()  - floor((progress - GROW_DELAY) / GROW_F)):
                var flower = flowers.pop_back()
                if flower != null:
                    flower.wither()
            each[2] = progress


func wither():
    started = true
    reversed = true
    for each in paths:
        each[1].points = []


func grow():
    started = true
    reversed = false


func _on_Memory_interacted(memory):
    $Words2.display()
    memory.queue_free()


func update_flowers(text):
    if Utils.check_phrase("Nothing grew wildly", text):
        finish_sentence()
        wither()
    else:
        grow()


func _on_StageManager_typing_end(text):
    if first_time:
        first_time = false
        return
    update_flowers(text)
