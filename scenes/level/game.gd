extends Node2D

@onready var player = $Objects/Player
@onready var grass_layer = $Layers/GrassLayer
@onready var soil_layer = $Layers/SoilLayer
@onready var soil_water_layer = $Layers/SoilWaterLayer

var plant_scene := preload("res://scenes/objects/plant.tscn")

func _ready() -> void:
	day_night_cycle()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		level_reset()
		

func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	var grid_pos = grass_layer.local_to_map(grass_layer.to_local(pos))
	if tool == player.Tools.HOE:
		var cell = grass_layer.get_cell_tile_data(grid_pos) as TileData
		if cell and cell.get_custom_data("usable"):
			soil_layer.set_cells_terrain_connect([grid_pos], 0, 0)
	elif tool == player.Tools.AXE:
		for tree in get_tree().get_nodes_in_group("trees"):
			if tree.position.distance_to(pos) < 10:
				tree.get_hit()
	elif tool == player.Tools.WATER_CAN:
		var cell = soil_layer.get_cell_tile_data(grid_pos) as TileData
		if cell:
			var watered_tiles = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)]
			soil_water_layer.set_cell(grid_pos, 0, watered_tiles.pick_random())
			

func _on_player_seed_use(seed_to_plant: int, pos: Vector2) -> void:
	var grid_pos = grass_layer.local_to_map(grass_layer.to_local(pos))
	var cell = soil_layer.get_cell_tile_data(grid_pos) as TileData
	if cell:
		var plant_pos = Vector2(grid_pos.x * 16 + 8, grid_pos.y * 16 - 4)
		var plant = plant_scene.instantiate() as StaticBody2D
		plant.setup(seed_to_plant, grid_pos)
		$Objects/Plants.add_child(plant)
		plant.position = plant_pos


func day_night_cycle() -> void:
	var tween = create_tween().set_loops()

	tween.tween_property($CanvasModulate, "color", Color.WHITE, 0.0)
	tween.tween_interval(30.0)

	tween.tween_property($CanvasModulate, "color", Color(1.0, 0.82, 0.62), 10.0)
	tween.tween_interval(10.0)

	tween.tween_property($CanvasModulate, "color", Color(0.25, 0.35, 0.6), 10.0)
	tween.tween_interval(5.0)

	tween.tween_callback(lock_player_movement)
	tween.tween_property($DayTransition/ColorRect, "modulate:a", 1.0, 2.0)

	tween.tween_callback(level_reset)
	tween.tween_property($DayTransition/Label, "modulate:a", 1.0, 1.0)
	tween.tween_interval(1.0)
	tween.tween_property($DayTransition/Label, "modulate:a", 0.0, 1.0)

	tween.tween_property($CanvasModulate, "color", Color(0.65, 0.78, 1.0), 0.0)
	tween.tween_property($DayTransition/ColorRect, "modulate:a", 0.0, 2.0)
	tween.tween_callback(unlock_player_movement)

	tween.tween_property($CanvasModulate, "color", Color.WHITE, 10.0)

func lock_player_movement() -> void:
	player.can_move = false
	player.direction = Vector2.ZERO

func unlock_player_movement() -> void:
	player.can_move = true

func level_reset():
	Global.day += 1
	$DayTransition/Label.text = "Day %s" % Global.day
	for plant in get_tree().get_nodes_in_group("plants"):
		plant.grow(plant.grid_position in soil_water_layer.get_used_cells())
	soil_water_layer.clear()
	print("Day %s" % Global.day)
