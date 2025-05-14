extends Area2D

@onready var label = $Label
@onready var timer = $Timer

func _ready():
	label.visible = false

func _on_body_entered(body):
	label.visible = true

func _on_body_exited(body):
	timer.start()

func _on_timer_timeout():
	label.visible = false;
