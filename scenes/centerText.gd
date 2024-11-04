extends RichTextLabel

@onready var question_text: RichTextLabel = $"."
@onready var question_text_rect = question_text.get_rect()

# Called when the node enters the scene tree for the first time.
const MAX_LINES = 3

func reposition_label(text):
	var regex = RegEx.new()
	regex.compile("\\n")
	# Assumes that there are no trailing newlines.
	var linecount = len(regex.search_all(text)) + 1

	var line_offset = question_text_rect.size.y / MAX_LINES / 2
	var top_offset = line_offset * (MAX_LINES - linecount)
	# Adjust the margin by the computed amount
	question_text.set_margin(10, question_text_rect.position.y + top_offset)
