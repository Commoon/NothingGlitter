extends StaticBody2D

const TEXTURES = [
    preload("res://Assets/Flower-1.png"),
    preload("res://Assets/Flower-2.png"),
    preload("res://Assets/Flower-3.png")
]

var growing = false
var target_scale = 0.0
var grow_speed = 0.0


func _ready():
    $Sprite.texture = TEXTURES[floor(randf() * TEXTURES.size())]


func grow(speed, hue):
    modulate = Color.from_hsv(hue, 0.7, 0.7)
    grow_speed = speed
    growing = true
    
    
func _process(delta):
    if not growing:
        return
    var p = scale.x + grow_speed * delta
    if p >= target_scale:
        p = target_scale
        growing = false
    scale = Vector2.ONE * p
