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
var started = 0
onready var plants = $Plants


func _ready():
    $Memory.position = $Player.position
    $Memory.hide()
    for each in $Paths.get_children():
        var path = each.get_node("PathFollow2D") as PathFollow2D
        var stem = Line2D.new()
        stem.default_color = STEM_COLOR
        stem.points = [path.position]
        paths.append([path, stem, 0.0, 0])
        plants.add_child(stem)


func _on_StageManager_started():
    $Memory.show()
    started = paths.size()


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


func _physics_process(delta):
    if started <= 0:
        return
    for each in paths:
        var path = each[0] as PathFollow2D
        var stem = each[1] as Line2D
        var progress = each[2] as float
        var n_flowers = each[3] as int
        if progress >= 1.0 + GROW_DELAY:
            continue
        var speed = rand_range(GROW_SPEED[0], GROW_SPEED[1])
        progress += speed * delta
        if progress >= 1.0:
            path.unit_offset = 1.0
            if progress >= 1.0 + GROW_DELAY:
                started -= 1
        else:
            path.unit_offset = progress
        for i in range(floor((progress - GROW_DELAY) / GROW_F) - n_flowers):
            n_flowers += 1
            var p = path.unit_offset
            path.unit_offset = progress - GROW_DELAY
            grow_flower(path.position, path.rotation)
            path.unit_offset = p
        if path.unit_offset < 1.0:
            stem.add_point(path.position)
        each[2] = progress
        each[3] = n_flowers


func _on_Memory_interacted():
    pass # Replace with function body.
