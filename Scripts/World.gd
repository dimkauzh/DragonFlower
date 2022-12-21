extends Node2D

func _process(_delta):
	$Player/Camera2D/ProgressBar.value = $Player.health
