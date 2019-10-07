tool
extends Interactable

const TEXTURES = [
    preload("res://Assets/Star-1.png"),
    preload("res://Assets/Star-2.png")
]

export var SCALE_RANGE = [0.7, 1.0]

onready var sprite = $Sprite

func _ready():
    sprite.texture = TEXTURES[floor(randf() * TEXTURES.size())]
    scale = Vector2.ONE * rand_range(SCALE_RANGE[0], SCALE_RANGE[1])
    rotate(randf() * 2 * PI)
