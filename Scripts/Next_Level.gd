extends Area2D

var level_num: int

func _on_body_entered(body):
	level_num = 2
	var parse_string = str(level_num)
	get_tree().change_scene_to_file("res://Scenes/level" + parse_string + ".tscn")
