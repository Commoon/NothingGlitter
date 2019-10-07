extends StaticBody2D

const TEXTURES = [
    preload("res://Assets/Flower-1.png"),
    preload("res://Assets/Flower-2.png"),
    preload("res://Assets/Flower-3.png")
]

var growing = false
var withering = false
var target_scale = 0.0
var grow_speed = 0.0
var grow_rotation_speed = 0.0


func _ready():
    $Sprite.texture = TEXTURES[floor(randf() * TEXTURES.size())]
    scale = Vector2.ZERO


func grow(speed, rotation_speed, target_scale, color):
    self.target_scale = target_scale
    modulate = color
    grow_speed = speed
    grow_rotation_speed = rotation_speed
    growing = true


func wither():
    withering = true


func _process(delta):
    if growing:
        var p = scale.x + grow_speed * delta
        if p >= target_scale:
            p = target_scale
            growing = false
        scale = Vector2.ONE * p
        rotate(grow_rotation_speed * delta)
    elif withering:
        var p = scale.x - grow_speed * delta
        if p <= 0:
            scale = Vector2.ZERO
            withering = false
            queue_free()
        else:
            scale = Vector2.ONE * p
        rotate(grow_rotation_speed * delta)
