extends Node2D

@onready var player = $Objects/Player
@onready var soil_layer = $Objects/Layers/SoilLayer as TileMapLayer
@onready var soil_water_layer = $Objects/Layers/SoilWaterLayer as TileMapLayer
@onready var grass_layer = $Objects/Layers/GrassLayer as TileMapLayer
var plant_scene: PackedScene = preload("res://scenes/level/plant.tscn")

@export var daytime_gradient: Gradient

func _process(_delta: float) -> void:
	var daytime_point: float = 1.0 - $DayTimer.time_left / $DayTimer.wait_time
	$CanvasModulate.color = daytime_gradient.sample(daytime_point)
	if Input.is_action_just_pressed("ui_focus_next"):
		day_switch()

func _on_player_tool_use(tool: Player.Tools, pos: Vector2) -> void:
	var grid_position = Vector2i(int(pos.x / 16), int(pos.y / 16))
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
	var cell = soil_layer.get_cell_tile_data(grid_position) as TileData
	
	if cell:
		var plant_position = Vector2(grid_position.x * 16 + 8, grid_position.y * 16)
		var plant = plant_scene.instantiate()
		plant.setup(seed_enum, grid_position)
		plant.position = plant_position
		$Objects/Plants.add_child(plant)
	
func day_switch() -> void:
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate:a", 1.0, 1.0)
	tween.tween_interval(1.0)
	tween.tween_callback(level_reset)
	tween.tween_property($CanvasLayer/ColorRect, "modulate:a", 0.0, 1.0)

func level_reset() -> void:
	for plant in get_tree().get_nodes_in_group("Plants"):
		plant.grow(plant.grid_pos in soil_water_layer.get_used_cells())
	soil_water_layer.clear()
	$DayTimer.start()
