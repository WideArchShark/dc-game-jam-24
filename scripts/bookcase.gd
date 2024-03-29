extends Node3D

# THIS ISN'T GOING TO WORK, AS IT GETS RESET WHEN THE SCENE RELOADS. 
# I REWORKED IT ANYWAY. SO IGNORE THIS ONE, AND PROBABLY DELETE IT.

@onready var interactable = $Interactable
const BOOKSHELVES = preload("res://dialogue_resources/bookshelves.dialogue")

func _on_bookcase_interact(interactable:Interactable):
	GameManager.books_read += 1
	DialogueManager.show_dialogue_balloon(BOOKSHELVES, "bookshelf_%d_unread" % GameManager.books_read)
	
	interactable.interaction_type = Interactable.InteractionType.DIALOGUE
	interactable.dialogue_title = "bookshelf_%d_read" % GameManager.books_read
	
	await DialogueManager.dialogue_ended
	interactable.mark_interaction_finished()
