#define TETRIS_LOCK_INFINITY		1				//can stall forever by turning
#define TETRIS_LOCK_LIMITED			2				//can turn <x> number of times to stall
#define TETRIS_LOCK_STEP			3				//can only delay by making piece move down naturally

#define TETRIS_FIELD_WIDTH					10
#define TETRIS_FIELD_HEIGHT					40
#define TETRIS_FIELD_HEIGHT_PLACEMENT		22
#define TETRIS_FIELD_HEIGHT_SHOW			21

#define TETRIS_PIECE_BAG_DEPTH			7

#define TETRIS_DEFAULT_STEP_SPEED			5		//deciseconds
#define TETRIS_DEFAULT_LOCK_DELAY			5

#define TETRIS_LIMITED_LOCK_STEPS			20		//turns until a forced lock on TETRIS_LOCK_LIMITED
