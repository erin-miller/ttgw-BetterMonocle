extends CanvasLayer

const QualityColors := {
	FloorModifier.ModType.POSITIVE: Color(0.488, 1, 0.456),
	FloorModifier.ModType.NEUTRAL: Color(1, 0.539, 0.21),
	FloorModifier.ModType.NEGATIVE: Color(1, 0.336, 0.27),
}

const ANOMALY_ICON := preload("res://objects/player/ui/anomaly_icon.tscn")

var prev_floor_idx: int = -1
var floor_idx: int = -1
var anom_container: Control
var elevator_scene: Node
var elevator_ui: Node

func _ready() -> void:
	if SceneLoader && SceneLoader.current_scene && SceneLoader.current_scene.name == "ElevatorScene":
		await _init_elevator_scene()

func _process(delta) -> void:
	# so are we in the elevator...?
	if SceneLoader && SceneLoader.current_scene && SceneLoader.current_scene.name == "ElevatorScene":
		if not elevator_scene:
			await _init_elevator_scene()
		
		floor_idx = SceneLoader.current_scene.get_child(2).floor_index
			
		if prev_floor_idx != floor_idx:
			prev_floor_idx = floor_idx
			update_anomalies()
	else:
		clear_anomalies()

func _init_elevator_scene():
	elevator_scene = SceneLoader.current_scene
	elevator_ui = elevator_scene.get_child(2) # TODO: try to access w/o index
	
	# wait for elevator_ui.floors to be populated
	await get_tree().process_frame
	while not elevator_ui.floors:
		await get_tree().process_frame
	
	update_anomalies()

func update_anomalies():
	clear_anomalies()
	
	var player: Player = Util.get_player()
	
	if not player or not player.stats.has_item("Monocle"):
		return
	
	_init_anom_container()
	
	var floors: Array[FloorVariant] = elevator_ui.floors
	
	# parse for anomalies and display them
	if floors && floors[floor_idx]:
		var curr: FloorVariant = floors[floor_idx]
		
		# taken from res://objects/pause_menu/pause_menu.gd
		for mod: Script in curr.modifiers:
			var mod_instance := FloorModifier.new()
			mod_instance.set_script(mod)
			if mod in curr.anomalies:
				var new_icon: Control = ANOMALY_ICON.instantiate()
				new_icon.instantiated_anomaly = mod_instance
				anom_container.add_child(new_icon)
			else:
				mod_instance.queue_free()

func clear_anomalies():
	if anom_container:
			anom_container.queue_free()

func _init_anom_container():
	anom_container = elevator_scene.find_child("AnomaliesContainer", true, false)
	
	if not anom_container:
		anom_container = HBoxContainer.new()
		anom_container.name = "AnomaliesContainer"
		anom_container.custom_minimum_size = Vector2(200, 50)
		
		# bottom center anchor
		anom_container.anchor_left = 0.5
		anom_container.anchor_right = 0.5
		anom_container.anchor_top = 1
		anom_container.anchor_bottom = 1
		
		# bottom center margins
		anom_container.offset_left = -220  # half of the container width
		anom_container.offset_right = 100
		anom_container.offset_top = -100  
		anom_container.offset_bottom = 0
		
		add_child(anom_container)
