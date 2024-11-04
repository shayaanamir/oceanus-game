extends Node

var noOfQuestions = 10
@onready var question_text: Label = $"../CanvasLayer/questionPanel/VBoxContainer/questionText"

@onready var option_a: Button = $"../CanvasLayer/Options/optionA"
@onready var option_b: Button = $"../CanvasLayer/Options/optionB"
@onready var option_c: Button = $"../CanvasLayer/Options/optionC"
@onready var option_d: Button = $"../CanvasLayer/Options/optionD"

@onready var pollution_bar: ProgressBar = $"../CanvasLayer/pollutionBar"

@onready var timer_label: Label = $"../CanvasLayer/Timer/timerLabel"
@onready var timer: Timer = $"../CanvasLayer/Timer/Timer"

var timerSeconds = 20
var OCEAN_GAME_QUESTIONS = "res://data/ocean_game.questions.json"

var questions = {}
var current_question = {}
var asked_questions = []
var score = 0

func loadQuestions(filePath: String):
	if FileAccess.file_exists(filePath):
		
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		return parsedResult
	else:
		print("File not found")


func set_button_min_size(min_size: Vector2) -> void:
	option_a.set_custom_minimum_size(min_size)
	option_b.set_custom_minimum_size(min_size)
	option_c.set_custom_minimum_size(min_size)
	option_d.set_custom_minimum_size(min_size)



func wrap_button_texts() -> void:
	option_a.autowrap_mode = TextServer.AUTOWRAP_WORD
	option_b.autowrap_mode = TextServer.AUTOWRAP_WORD
	option_c.autowrap_mode = TextServer.AUTOWRAP_WORD
	option_d.autowrap_mode = TextServer.AUTOWRAP_WORD

# Function to reset option button colors
func reset_option_colors() -> void:
	option_a.modulate = Color(1, 1, 1)
	option_b.modulate = Color(1, 1, 1)
	option_c.modulate = Color(1, 1, 1)
	option_d.modulate = Color(1, 1, 1)

# Function to provide feedback

func disable_option_buttons() -> void:
	option_a.disabled = true
	option_b.disabled = true
	option_c.disabled = true
	option_d.disabled = true


func enable_option_buttons() -> void:
	option_a.disabled = false
	option_b.disabled = false
	option_c.disabled = false
	option_d.disabled = false

func display_question(question_data: Dictionary) -> void:
	current_question = question_data
	
	  # Store the current question
	question_text.text = question_data["question_text"]

	var answers = question_data["answers"]
	option_a.text = answers[0]
	option_b.text = answers[1]
	option_c.text = answers[2]
	option_d.text = answers[3]

	set_button_min_size(Vector2(448, 0))  # Set minimum size for the buttons
	wrap_button_texts()  # Ensure longer text is wrapped inside the buttons
	reset_option_colors()

func provide_feedback(is_correct: bool, selected_button: Button) -> void:
	if is_correct:
		selected_button.modulate = Color(0, 2, 0)
		score += 1
		print("Correct! Score:", score)
		pollution_bar.value -= 10
	else:
		selected_button.modulate = Color(2, 0, 0)  # Red for incorrect
		print("Incorrect! The correct answer was:", current_question["correct_answer"])
		pollution_bar.value += 10
		
	disable_option_buttons()

	await get_tree().create_timer(2.0).timeout
	load_next_question()

func load_next_question() -> void:
	enable_option_buttons()
	reset_option_colors()
	
	if asked_questions.size() >= noOfQuestions or asked_questions.size() >= questions.size() or pollution_bar.value <= 30:
		show_final_score()
	else:
		var random_index = randi_range(0, questions.size() - 1)
		while asked_questions.has(random_index):
			random_index = randi_range(0, questions.size() - 1)
		
		asked_questions.append(random_index)
		display_question(questions[random_index])

func show_final_score() -> void:
	question_text.text = "Quiz Completed!\nYour Score: %s/%s" % [str(score), str(asked_questions.size())]
	disable_option_buttons()
	


func update_timer_label() -> void:
	var minutes = timerSeconds / 60  # Calculate the minutes
	var seconds = timerSeconds % 60  # Calculate the remaining seconds
	
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func _ready() -> void:
	questions = loadQuestions(OCEAN_GAME_QUESTIONS)
	print(questions)
	if questions.size() > 0:
		load_next_question()
	
	timer.wait_time = 1.0
	timer.one_shot = false  # Keep repeating until stopped
	timer.start()  # Start the timer
	update_timer_label()




func _process(delta: float) -> void:
	if timerSeconds == 0:
		show_final_score()

# Button Press Handlers
func _on_option_a_pressed() -> void:
	handle_answer(option_a.text, option_a)

func _on_option_b_pressed() -> void:
	handle_answer(option_b.text, option_b)

func _on_option_c_pressed() -> void:
	handle_answer(option_c.text, option_c)

func _on_option_d_pressed() -> void:
	handle_answer(option_d.text, option_d)

# Function to handle answer selection
func handle_answer(selected_answer: String, selected_button: Button) -> void:
	var correct_answer = current_question["correct_answer"]
	
	var selected_answer_letter = selected_answer[0]
	var is_correct = selected_answer_letter == correct_answer  # Compare only the first character
	
	provide_feedback(is_correct, selected_button)
	
	# Extract the first character from selected answer to match 'correct_answer' (e.g. 'A)' -> 'A')
	
	
	
	

func _on_timer_timeout() -> void:
	if timerSeconds > 0:
		timerSeconds -= 1
		update_timer_label()
