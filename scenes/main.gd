extends Control

# Tracks how many memory fragments the player has collected.
var memory_fragments: int = 0

# The player wins when they collect 5 fragments.
var max_fragments: int = 5

# Tracks which spirit/question the player is currently on.
var current_spirit_index: int = 0

# These connect the script to the labels in your scene.
@onready var memory_jar_label: Label = $MainContainer/ContentBox/TopBar/MemoryJarLabel
@onready var spirit_name_label: Label = $MainContainer/ContentBox/StoryPanel/StoryBox/SpiritNameLabel
@onready var dialogue_label: Label = $MainContainer/ContentBox/StoryPanel/StoryBox/DialogueLabel
@onready var feedback_label: Label = $MainContainer/ContentBox/FeedbackLabel

# These connect the script to your drink buttons.
@onready var tea_button: Button = $MainContainer/ContentBox/DrinkChoiceBox/TeaButton
@onready var coffee_button: Button = $MainContainer/ContentBox/DrinkChoiceBox/CoffeeButton
@onready var juice_button: Button = $MainContainer/ContentBox/DrinkChoiceBox/JuiceButton


# This is the list of spirits/questions.
# Each spirit has dialogue and one correct drink.
var spirits = [
	{
		"name": "Spirit",
		"dialogue": "I miss the warmth of home...\nSomething that feels like a hug.",
		"correct_drink": "Tea",
		"success": "Correct! The warm tea comforts the spirit.",
		"wrong": "The spirit looks unsure. That drink does not match their feeling."
	},
	{
		"name": "Tired Spirit",
		"dialogue": "I have wandered for so long...\nI just need something to wake my memory.",
		"correct_drink": "Coffee",
		"success": "Correct! The coffee helps the spirit remember.",
		"wrong": "The spirit blinks slowly. That drink is not strong enough."
	},
	{
		"name": "Joyful Spirit",
		"dialogue": "I remember sunny days and laughter...\nSomething bright would help me hold onto it.",
		"correct_drink": "Juice",
		"success": "Correct! The juice brings back a bright happy memory.",
		"wrong": "The spirit tilts their head. That does not feel cheerful enough."
	},
	{
		"name": "Lonely Spirit",
		"dialogue": "I waited by the window every evening...\nI just wanted to feel cared for.",
		"correct_drink": "Tea",
		"success": "Correct! The tea makes the spirit feel less alone.",
		"wrong": "The spirit looks down. That drink does not feel gentle enough."
	},
	{
		"name": "Brave Spirit",
		"dialogue": "I was scared, but I kept going...\nI need something bold to finish my story.",
		"correct_drink": "Coffee",
		"success": "Correct! The coffee gives the spirit courage.",
		"wrong": "The spirit shakes their head. That drink does not feel bold enough."
	}
]


func _ready() -> void:
	# This runs when the game starts.
	update_memory_jar()
	show_current_spirit()
	feedback_label.text = "Choose the drink that matches the spirit’s feeling."


func update_memory_jar() -> void:
	# Creates a small visual meter for the memory jar.
	var meter: String = ""

	for i in range(max_fragments):
		if i < memory_fragments:
			meter += "✦ "
		else:
			meter += "✧ "

	memory_jar_label.text = "🫙 Memory Jar: " + meter + str(memory_fragments) + "/" + str(max_fragments)


func show_current_spirit() -> void:
	# Shows the current spirit's name and dialogue.
	var current_spirit = spirits[current_spirit_index]
	spirit_name_label.text = current_spirit["name"]
	dialogue_label.text = current_spirit["dialogue"]


func choose_drink(drink_name: String) -> void:
	# Checks if the player picked the correct drink.
	var current_spirit = spirits[current_spirit_index]

	if drink_name == current_spirit["correct_drink"]:
		memory_fragments += 1
		update_memory_jar()
		feedback_label.text = current_spirit["success"]

		# Move to the next spirit after a correct answer.
		current_spirit_index += 1

		if memory_fragments >= max_fragments:
			show_ending()
		else:
			show_current_spirit()
	else:
		feedback_label.text = current_spirit["wrong"]


func show_ending() -> void:
	# Shows the ending when the Memory Jar is full.
	spirit_name_label.text = "Memory Jar Full"
	dialogue_label.text = "The jar glows with 5 memory fragments...\nThe spirits smile and move on peacefully."
	feedback_label.text = "Ending unlocked: You helped the spirits move on."

	# Disable buttons so the game feels finished.
	tea_button.disabled = true
	coffee_button.disabled = true
	juice_button.disabled = true

func _on_tea_button_pressed() -> void:
	choose_drink("Tea")


func _on_coffee_button_pressed() -> void:
	choose_drink("Coffee")

func _on_juice_button_pressed() -> void:
	choose_drink("Juice")
