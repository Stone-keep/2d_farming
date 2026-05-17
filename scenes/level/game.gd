extends Node2D

@onready var player = $Objects/Player
@onready var grass_layer = $Layers/GrassLayer
@onready var soil_layer = $Layers/SoilLayer
@onready var soil_water_layer = $Layers/SoilWaterLayer

var plant_scene := preload("res://scenes/objects/plant.tscn")

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
		print(grid_pos)
