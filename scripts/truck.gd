extends VehicleBody3D
@onready var tps_camera = $SpringArm3D/ThirdPersonCamera
@onready var fps_camera = $FirstPersonCamera
@onready var engine_sound = $EngineSound

# Налаштування, які можна змінювати в інспекторі
@export var engine_power: float = 160.0
@export var steer_angle: float = 0.7


func _physics_process(delta):
	# Керування кермом
	var steer_input = Input.get_axis("steer_left", "steer_right")
	steering = lerp(steering, steer_input * steer_angle * -1.0, 5.0 * delta)

	# Керування газом і гальмом
	var gas_input = Input.get_axis("move_backward", "move_forward")
	engine_force = gas_input * engine_power
	
	# Логіка гучності двигуна
	if gas_input != 0:
		# Коли газ натиснутий, робимо звук гучнішим (0 dB - повна гучність)
		engine_sound.volume_db = -10
	else:
		# Коли стоїмо, робимо звук дуже тихим (-20 dB - майже нечутно)
		engine_sound.volume_db = -40

func _unhandled_input(event):
	# Перевіряємо, чи була натиснута клавіша "C" (або будь-яка інша)
	if event.is_action_pressed("switch_camera"):
		# Якщо активна камера від третьої особи
		if tps_camera.is_current():
			# Робимо активною камеру від першої особи
			fps_camera.make_current()
		else:
			# В іншому випадку робимо активною камеру від третьої особи
			tps_camera.make_current()
