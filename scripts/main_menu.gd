extends Node2D




func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://play_screne.tscn")
	pass # Replace with function body.


func _on_settings_button_down() -> void:
	get_tree().change_scene_to_file("res://settings.tscn")
	pass # Replace with function body.


func _on_exit_button_down() -> void:
	get_tree().quit()
	pass # Replace with function body.
