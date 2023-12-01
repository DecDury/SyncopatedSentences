extends Node2D

func _enter_tree() -> void:
	
	var target_spacing = 128
	# center targets with parent
	global_position.x = get_parent().global_position.x - (target_spacing * 5.5)
	
	# Set spacing in between target zones
	var offset = 0
	for t in get_children():
		t.position.x += offset
		offset += target_spacing
		
	# sent position of barline
	$Barline.global_position.y = global_position.y
