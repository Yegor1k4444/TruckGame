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

func _ready():
	update_ui_objective()

# Функція для оновлення тексту завдання на екрані
func update_ui_objective():
	if not is_instance_valid(objective_label):
		print("Objective label is not set in GameManager!")
		return

	match current_mission:
		Missions.GO_TO_WAREHOUSE_B:
			objective_label.text = "Завдання: Доставте вантаж на Склад Б"
		Missions.GO_TO_FACTORY_C:
			objective_label.text = "Вантаж доставлено! Тепер візьміть новий і везіть на Фабрику В"
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
