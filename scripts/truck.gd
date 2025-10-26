extends VehicleBody3D

# Налаштування, які можна змінювати в інспекторі
@export var engine_power: float = 100.0
@export var steer_angle: float = 0.4

func _physics_process(delta):
	# Керування кермом
	var steer_input = Input.get_axis("steer_left", "steer_right")
	steering = lerp(steering, steer_input * steer_angle, 5.0 * delta)

	# Керування газом і гальмом
	var gas_input = Input.get_axis("move_backward", "move_forward")
	engine_force = gas_input * engine_power
