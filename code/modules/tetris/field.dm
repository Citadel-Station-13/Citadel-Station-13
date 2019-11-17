/datum/tetris_field
	var/lock_mode = TETRIS_LOCK_INFINTIY
	var/limited_lock_turns_left = TETRIS_LIMITED_LOCK_TURNS
	var/limited_lock_turns_left_starting = TETRIS_LIMITED_LOCK_TURNS

	//How fast pieces move down
	var/step_delay = TETRIS_DEFAULT_STEP_SPEED

	//How fast a piece "locks" when they don't move. Can be reset.
	var/lock_delay = TETRIS_DEFAULT_LOCK_DELAY

	//actual playing field
	var/field_width = TETRIS_FIELD_WIDTH
	var/field_height = TETRIS_FIELD_HEIGHT
	var/field_placement_height = TETRIS_FIELD_HEIGHT_PLACEMENT
	var/field_visible_height = TETRIS_FIELD_HEIGHT_SHOW
	var/list/playing_field						//[row][column] =
	var/list/datum/tetris_piece/pieces			//pieces on the board
	var/list/datum/tetris_piece/bag				//pieces in bag


/datum/tetris_field/proc/Initialize()
	pieces = list()
	bag = list()
	initialize_field()

/datum/tetris_field/proc/set_field_size(width = TETRIS_FIELD_WIDTH, height = TETRIS_FIELD_HEGIHT, placement_height = TETRIS_FIELD_HEIGHT_PLACEMENT, visible_height = TETRIS_FIELD_HEIGHT_SHOW)
	field_width = width
	field_height = height
	field_placement_height = placement_hegiht
	field_visible_height = visible_height
	initialize_field()

/datum/tetris_field/proc/initialize_field()
	playing_field = list()
	playing_field.len = field_height
	for(var/i in 1 to field_height)
		playing_field[i] = list()
		var/list/L = playing_field[i]
		L.len = field_width







/datum/tetris_field/proc/get_piece(row, column)
	if((row > field_height) || (column > field_width))
		return
	return playing_field[row][column]





