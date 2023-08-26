extends Node2D

var spawn_spacing = 100;

func _ready() -> void:
	var offset: int = 0
	for location in $Container.get_children():
		location.globalposition += offset
		offset += spawn_spacing
	
	for note in notes:
		

func spawn_letters() -> void:
	for note in notes:
		var pitch = str(note[0])
