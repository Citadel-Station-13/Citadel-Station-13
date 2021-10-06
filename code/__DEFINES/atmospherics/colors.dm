#define PIPE_COLOR_GREY			(rgb(255, 255, 255))
#define PIPE_COLOR_YELLOW		(rgb(255, 198, 0))
#define PIPE_COLOR_CYAN			(rgb(0, 255, 249))
#define PIPE_COLOR_GREEN		(rgb(30, 255, 0))
#define PIPE_COLOR_ORANGE		(rgb(255, 129, 25))
#define PIPE_COLOR_PURPLE		(rgb(128, 0, 182))
#define PIPE_COLOR_DARK			(rgb(69, 69, 69))
#define PIPE_COLOR_BROWN		(rgb(178, 100, 56))
#define PIPE_COLOR_VIOLET		(rgb(64, 0, 128))
#define PIPE_COLOR_RED			(rgb(255, 0, 0))
#define PIPE_COLOR_BLUE			(rgb(0, 0, 255))
#define PIPE_COLOR_AMETHYST		(rgb(130, 43, 255))

GLOBAL_LIST_INIT(pipe_paint_colors, list(
		"amethyst" = PIPE_COLOR_AMETHYST,
		"blue" = PIPE_COLOR_BLUE,
		"brown" = PIPE_COLOR_BROWN,
		"cyan" = PIPE_COLOR_CYAN,
		"dark" = PIPE_COLOR_DARK,
		"green" = PIPE_COLOR_GREEN,
		"grey" = PIPE_COLOR_GREY,
		"orange" = PIPE_COLOR_ORANGE,
		"purple" = PIPE_COLOR_PURPLE,
		"red" = PIPE_COLOR_RED,
		"violet" = PIPE_COLOR_VIOLET,
		"yellow" = PIPE_COLOR_YELLOW
))
