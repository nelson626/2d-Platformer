class_name checkpoint
extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("must checkpoint")
		body.handle_checkpoint()
