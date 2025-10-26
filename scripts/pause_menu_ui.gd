extends CanvasLayer

# Ховаємо меню при старті
func _ready():
	visible = false

# Ця функція обробляє ввід, який не був оброблений ігровим процесом
func _unhandled_input(event):
	# Якщо натиснута клавіша "ui_cancel" (за замовчуванням це Escape)
	if event.is_action_pressed("ui_cancel"):
		# Змінюємо видимість меню на протилежну
		visible = not visible
		# Ставимо або знімаємо гру з паузи
		get_tree().paused = visible

# Функція для кнопки "Повернутись в меню"
func _on_return_to_menu_pressed():
	# ВАЖЛИВО: Завжди знімайте гру з паузи перед зміною сцени
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn") # <-- Вкажіть тут ваш шлях до головного меню

# Функція для кнопки "Вийти з гри"
func _on_exit_game_pressed():
	get_tree().quit()
