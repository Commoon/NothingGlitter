extends Area2D

class_name Interactable

export var item_name = "interactable"

signal select_changed
signal interacted


var selected = false


func can_interact(player):
    return true


func interact(player):
    emit_signal("interacted", self)
    select(false, player)


func select(value, player):
    selected = value
    player.to_interact = self if selected else null
    emit_signal("select_changed", value)


func _on_body_entered(body):
    if not self.can_interact(body):
        return
    if body.to_interact != null:
        body.to_interact.select(false, body)
    select(true, body)


func _on_body_exited(body):
    if body.to_interact == self:
        select(false, body)


func _ready():
    self.connect("body_entered", self, "_on_body_entered")
    self.connect("body_exited", self, "_on_body_exited")
