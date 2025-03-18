extends "res://scenes/elevator_scene/ui/elevator_ui.gd"

func _ready() -> void:
	super ()
	
	# overwrite anomaly container behavior
	if Util.get_player().stats.has_item("Monocle"):
		anomaly_container.show()
	else:
		anomaly_container.hide()
