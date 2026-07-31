extends StaticBody2D

var grid_pos: Vector2i
var max_age: int
var grow_speed: float
const plant_data = {
	Global.Seeds.CORN: {
		'texture': preload("res://graphics/plants/corn.png"), 
		'max_age': 3,
		'grow_speed': 0.6
	},
	
	Global.Seeds.TOMATO: {
		'texture': preload("res://graphics/plants/tomatoes.png"), 
		'max_age': 3,
		'grow_speed': 0.8
	},
	
	Global.Seeds.PUMPKIN: {
		'texture': preload("res://graphics/plants/pumpkin.png"), 
		'max_age': 4,
		'grow_speed': 0.5
	}
}

func setup(seed_enum: Global.Seeds, grid_position: Vector2i) -> void:
	max_age = plant_data[seed_enum]["max_age"]
	grow_speed = plant_data[seed_enum]["grow_speed"]
	grid_pos = grid_position
	$Sprite.texture = plant_data[seed_enum]["texture"]
