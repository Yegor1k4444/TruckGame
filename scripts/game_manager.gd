extends Node

# Створюємо "стани" для наших місій
enum Missions {
	GO_TO_WAREHOUSE_B,  # Перша місія: їхати з А до Б
	GO_TO_FACTORY_C,    # Друга місія: їхати з Б до В
	ALL_COMPLETE        # Всі місії виконано
}

# Змінна, що зберігає поточну місію
var current_mission = Missions.GO_TO_WAREHOUSE_B

# Посилання на наш UI Label, щоб змінювати текст
@export var objective_label: Label
@export var radio_player : AudioStreamPlayer
@export var tutorial_label: Label

enum TutorialState {
	SHOW_MOVE,      # Показуємо "Натисніть W"
	SHOW_STEER,     # Показуємо "Натисніть A/D"
	SHOW_CAMERA,    # Показуємо "Натисніть Space/C"
	DONE            # Навчання завершено
}

# Змінна, що зберігає наш поточний етап
var current_tutorial_state = TutorialState.SHOW_MOVE

func _ready():
	update_ui_objective()
	
	radio_player.playing = $"/root/PlayScrene/CanvasLayer/CheckBox".button_pressed # <-- Замініть шлях на правильний до вашого CheckBox
	
	# -- ДОДАЙТЕ ЦІ РЯДКИ --
	tutorial_label.text = "Натисніть [W], щоб почати рух"
	tutorial_label.visible = true

func _process(delta: float) -> void:
	if current_tutorial_state == TutorialState.DONE:
		return

	match current_tutorial_state:
		
		TutorialState.SHOW_MOVE:
			# Якщо ми на етапі "Рух" і гравець натиснув "вперед"
			if Input.is_action_just_pressed("move_forward"):
				current_tutorial_state = TutorialState.SHOW_STEER
				tutorial_label.text = "Використовуйте [A] та [D] для поворотів"
			
		TutorialState.SHOW_STEER:
			# Якщо ми на етапі "Поворот" і гравець натиснув вліво АБО вправо
			if Input.is_action_just_pressed("steer_left") or Input.is_action_just_pressed("steer_right"):
				current_tutorial_state = TutorialState.SHOW_CAMERA
				tutorial_label.text = "Натисніть [C], щоб змінити вид камери" 
				
		TutorialState.SHOW_CAMERA:
			# Якщо ми на етапі "Камера" і гравець натиснув 'switch_camera'
			if Input.is_action_just_pressed("switch_camera"):
				# Завершуємо навчання
				current_tutorial_state = TutorialState.DONE
				# Ховаємо лейбл
				tutorial_label.visible = false


# Функція для оновлення тексту завдання на екрані
func update_ui_objective():
	if not is_instance_valid(objective_label):
		print("Objective label is not set in GameManager!")
		return

	match current_mission:
		Missions.GO_TO_WAREHOUSE_B:
			objective_label.text = "Завдання: Доставте вантаж до Оранжово-зеленого будинку з синім навесом"
		Missions.GO_TO_FACTORY_C:
			objective_label.text = "Вантаж доставлено! Тепер візьміть новий і везіть до Червоного будинку"
		Missions.ALL_COMPLETE:
			objective_label.text = "Всі доставки виконано! Чудова робота!"

# Ця функція викликається сигналом від зони на Складі Б
func _on_warehouse_b_reached(body):
	# Перевіряємо, чи це наша вантажівка
	if body.name == "Truck":
		# Якщо так, перевіряємо, чи ми виконуємо правильну місію
		if current_mission == Missions.GO_TO_WAREHOUSE_B:
			print("Перша місія виконана!")
			current_mission = Missions.GO_TO_FACTORY_C
			update_ui_objective()

# Ця функція викликається сигналом від зони на Фабриці В
func _on_factory_c_reached(body):
	# Перевіряємо, чи це наша вантажівка
	if body.name == "Truck":
		# Якщо так, перевіряємо, чи ми виконуємо правильну місію
		if current_mission == Missions.GO_TO_FACTORY_C:
			print("Друга місія виконана!")
			current_mission = Missions.ALL_COMPLETE
			update_ui_objective()


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# Галочка є - вмикаємо музику (точніше, вимикаємо тишу)
		radio_player.playing = true
	else:
		# Галочки немає - вимикаємо музику (вмикаємо тишу)
		radio_player.playing = false
