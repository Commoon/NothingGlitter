tool
extends Interactable

const TEXTURES = [
    preload("res://Assets/Star-1.png"),
    preload("res://Assets/Star-2.png")
]

signal dropped

export var SCALE_RANGE = [0.4, 0.7]
export var DROPPING_SPEED = 700.0
export var DROPPING_ROTATION_SPEED = 3.0

onready var sprite = $Sprite

var dropping = -1


func _ready():
    sprite.texture = TEXTURES[floor(randf() * TEXTURES.size())]
    scale = Vector2.ONE * rand_range(SCALE_RANGE[0], SCALE_RANGE[1])
    rotate(randf() * 2 * PI)


func drop():
    dropping = 0.0


func _process(delta):
    if dropping < 0:
        return
    global_position.y += delta * DROPPING_SPEED
    rotate(delta * DROPPING_ROTATION_SPEED)
    if global_position.y >= 960 + 128:
        emit_signal("dropped")
        queue_free()
