extends StaticBody2D

var grid_pos: Vector2i
var age: float
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
		'max_age': 3,
		'grow_speed': 0.5
	}
}

func setup(seed_enum: Global.Seeds, grid_position: Vector2i) -> void:
	max_age = plant_data[seed_enum]["max_age"]
	grow_speed = plant_data[seed_enum]["grow_speed"]
	grid_pos = grid_position
	$Sprite.texture = plant_data[seed_enum]["texture"]

func grow(watered: bool) -> void:
	if watered:
		age = min(age + grow_speed, max_age)
		$Sprite.frame = int(age)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if age >= max_age:
		queue_free()
