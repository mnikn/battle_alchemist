extends Control

func _on_Restart_pressed():
	var scene = load("res://Main.tscn")
	self.get_tree().change_scene_to(scene)
