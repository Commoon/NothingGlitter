extends Area2D

class_name Interactable


func interact(player):
    pass


func _on_Goal_body_entered(body):
    body.to_interact = self


func _on_Goal_body_exited(body):
    if body.to_interact == self:
        body.to_interact = null
