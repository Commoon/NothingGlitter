extends Stage


func _ready():
    stage_manager.goal_position = Vector2(rand_range(100, 1180), rand_range(620, 900))
    

func _enter_tree():
    Game.current_stage = self

