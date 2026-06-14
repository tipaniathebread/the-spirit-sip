extends Control

# -----------------------------
# THE SPIRIT SIP - MAIN GAME SCRIPT
# This script controls:
# - spirit dialogue
# - drink choices
# - memory fragment score
# - ending when the jar reaches 5/5
# -----------------------------


# How many memory fragments the player has collected
var memory_fragments := 0

# How many fragments are needed to finish the game
var max_fragments := 5

# Which spirit is currently being shown
var current_spirit_index := 0

# Stops the player from clicking buttons too fast
var is_changing_spirit := false


# This is the spirit data.
# Each spirit has:
# name, dialogue, correct drink, success message, and wrong message.
var spirits = [
	{
		"name": "Lonely Spirit",
		"dialogue": "I miss the sound of rain at home...",
		"correct_drink": "Tea",
		"success": "The tea feels warm and familiar. A memory fragment appears.",
		"wrong": "That drink does not match the spirit's memory."
	},
	{
		"name": "Tired Spirit",
		"dialogue": "I have been wandering for so long...",
		"correct_drink": "Coffee",
		"success": "The coffee gives the spirit comfort. A memory fragment appears.",
		"wrong": "The spirit still looks tired."
	},
	{
		"name": "Playful Spirit",
		"dialogue": "I remember sunny days and sweet laughter...",
		"correct_drink": "Juice",
		"success": "The juice reminds the spirit of happy memories.",
		"wrong": "The spirit tilts its head, unsure."
	},
	{
		"name": "Quiet Spirit",
		"dialogue": "I used to sit by the window during storms...",
		"correct_drink": "Tea",
		"success": "The warm tea brings peace to the spirit.",
		"wrong": "The spirit stays quiet."
	},
	{
		"name": "Lost Spirit",
		"dialogue": "I cannot remember where I was going...",
		"correct_drink": "Coffee",
		"success": "The coffee helps the spirit remember their path.",
		"wrong": "The memory stays unclear."
	}
]


# These connect the script to the child nodes in your scene.
# The names must match your scene tree exactly.
@onready var title_label: Label = $TitleLabel
@onready var spirit_label: Label = $SpiritLabel
@onready var dialogue_label: Label = $DialoguePanel/DialogueLabel
@onready var coffee_button: Button = $CoffeeButton
@onready var tea_button: Button = $TeaButton
@onready var juice_button: Button = $JuiceButton
@onready var memory_jar_label: Label = $MemoryJarLabel
@onready var feedback_label: Label = $FeedbackLabel


func _ready():
	# Set the starting title
	title_label.text = "The Spirit Sip"

	# Show the first spirit when the game starts
	show_current_spirit()

	# Connect the buttons to the drink choice function
	coffee_button.pressed.connect(func(): choose_drink("Coffee"))
	tea_button.pressed.connect(func(): choose_drink("Tea"))
	juice_button.pressed.connect(func(): choose_drink("Juice"))


func show_current_spirit():
	# Get the current spirit from the list
	var spirit = spirits[current_spirit_index]

	# Show the spirit dialogue
	dialogue_label.text = spirit["name"] + ":\n" + spirit["dialogue"]

	# Clear the feedback message
	feedback_label.text = ""

	# Update the memory jar text
	update_memory_jar()

	# Optional: show a simple ghost emoji for now
	# Later you can replace this with a Sprite2D or TextureRect.
	spirit_label.text = "👻"


func choose_drink(drink_name: String):
	# Prevent button spam while changing spirits
	if is_changing_spirit:
		return

	var spirit = spirits[current_spirit_index]

	# Check if the player chose the correct drink
	if drink_name == spirit["correct_drink"]:
		memory_fragments += 1
		feedback_label.text = spirit["success"]
		update_memory_jar()

		# If the jar is full, finish the game
		if memory_fragments >= max_fragments:
			end_game()
			return

		# Move to the next spirit after a short pause
		is_changing_spirit = true
		set_buttons_disabled(true)

		await get_tree().create_timer(1.5).timeout

		current_spirit_index += 1
		show_current_spirit()

		is_changing_spirit = false
		set_buttons_disabled(false)

	else:
		# Wrong drink: player can try again
		feedback_label.text = spirit["wrong"] + " Try again."


func update_memory_jar():
	# Updates the Memory Jar label, example: Memory Jar: 3/5
	memory_jar_label.text = "Memory Jar: " + str(memory_fragments) + "/" + str(max_fragments)


func set_buttons_disabled(value: bool):
	# Turns the buttons on or off
	coffee_button.disabled = value
	tea_button.disabled = value
	juice_button.disabled = value


func end_game():
	# This runs when the player collects 5 fragments
	dialogue_label.text = "The Memory Jar is full.\nThe spirits move on peacefully."

	feedback_label.text = "Ending reached: The cafe has helped 5 spirits."

	spirit_label.text = "✨"

	update_memory_jar()

	# Disable buttons because the game has ended
	set_buttons_disabled(true)
