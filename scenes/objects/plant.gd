extends StaticBody2D

var grid_position: Vector2i
var max_age: int
var growth_speed: float
const plant_data = {
	Global.Seeds.CORN: {"texture": preload("res://graphics/plants/corn.png"),
	"max_age": 3,
	"growth_speed": 0.6},
	Global.Seeds.TOMATO: {"texture": preload("res://graphics/plants/tomatoes.png"),
	"max_age": 3,
	"growth_speed": 0.6},
	Global.Seeds.PUMPKIN: {"texture": preload("res://graphics/plants/pumpkin.png"),
	"max_age": 3,
	"growth_speed": 0.6}
}

func setup(seed_to_plant: Global.Seeds, grid_pos: Vector2i):
	grid_position = grid_pos
	max_age = plant_data[seed_to_plant]["max_age"]
	growth_speed = plant_data[seed_to_plant]["growth_speed"]
	$Sprite2D.texture = plant_data[seed_to_plant]["texture"]