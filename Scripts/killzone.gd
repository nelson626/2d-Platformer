extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if body is Player:
		body.handle_danger()

