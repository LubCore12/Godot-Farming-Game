extends Node2D

@onready var player = $Objects/Player
var plant_scene: PackedScene = preload("res://scenes/level/plant.tscn")

func _on_player_tool_use(tool: Player.Tools, pos: Vector2) -> void:
	var grid_position = Vector2i(int(pos.x / 16), int(pos.y / 16))
	var soil_layer = $Objects/Layers/SoilLayer
	var soil_water_layer = $Objects/Layers/SoilWaterLayer
	var grass_layer = $Objects/Layers/GrassLayer
	var grass_cell = grass_layer.get_cell_tile_data(grid_position) as TileData
	var soil_cell = soil_layer.get_cell_tile_data(grid_position) as TileData
	var soil_water_cell = soil_water_layer.get_cell_tile_data(grid_position) as TileData
	
	match tool:
		Player.Tools.HOE:
			if grass_cell and grass_cell.get_custom_data("usable") and not soil_cell:
				soil_layer.set_cells_terrain_connect([grid_position], 0, 0)
				
		Player.Tools.AXE:
			for tree in get_tree().get_nodes_in_group("Trees"):
				if tree.position.distance_to(pos) < 10:
					tree.hit()
			
		Player.Tools.WATER:
			if soil_cell and not soil_water_cell:
				soil_water_layer.set_cells_terrain_connect([grid_position], 0, 0)


func _on_player_seed_use(seed_enum: Global.Seeds, pos: Vector2) -> void:
	var grid_position = Vector2i(int(pos.x / 16), int(pos.y / 16))
	var soil_layer = $Objects/Layers/SoilLayer
	var soil_water_layer = $Objects/Layers/SoilWaterLayer
	var cell = soil_layer.get_cell_tile_data(grid_position) as TileData
	
	if cell:
		var plant_position = Vector2(grid_position.x * 16 + 8, grid_position.y * 16)
		var plant = plant_scene.instantiate()
		plant.setup(seed_enum, grid_position)
		plant.position = plant_position
		$Objects/Plants.add_child(plant)
	
