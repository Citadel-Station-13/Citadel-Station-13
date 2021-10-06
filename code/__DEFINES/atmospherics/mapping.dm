/**
 * STRUCTURE OF FULL HELPERS:
 *
 * /path/to/pipe/preset: [distro, scrubber, fuel, aux, general]/visible?
 * /path/to/pipe/layer#/visible?/color
 */

// for the love of god don't change these
#define PIPE_LAYER_FUEL			1
#define PIPE_LAYER_DISTRO		2
#define PIPE_LAYER_GENERAL		3
#define PIPE_LAYER_SCRUBBER		4
#define PIPE_LAYER_AUX			5

/// Fully registers a path for all 5 layers and every valid pipe color, as well as registering the standard lines. Used for pipes that use pixel-shifting to visualize layers
#define ATMOS_MAPPING_FULL_PX_DOUBLE(path)				\
	ATMOS_MAPPING_LAYERS_PX_COLORS_INT(path)			\
	ATMOS_MAPPING_DISTRO(path)							\
	ATMOS_MAPPING_SCRUBBER(path)						\
	ATMOS_MAPPING_FUEL(path)							\
	ATMOS_MAPPING_AUX(path)								\
	ATMOS_MAPPING_GENERAL(path)

/// Fully registers a path for all 5 layers and every valid pipe color, as well as registering the standard lines. Used for pipes that use icon-# state changes to visualize layers.
#define ATMOS_MAPPING_FULL_IX(path, iconbase)			\
	ATMOS_MAPPING_LAYERS_IX_COLORS_INT(path, iconbase)	\
	ATMOS_MAPPING_DISTRO(path)							\
	ATMOS_MAPPING_SCRUBBER(path)						\
	ATMOS_MAPPING_FUEL(path)							\
	ATMOS_MAPPING_AUX(path)								\
	ATMOS_MAPPING_GENERAL(path)

/// Registers a path for every valid pipe color
#define ATMOS_MAPPING_COLORS(path)									\
	##path/visible {												\
		level = PIPE_VISIBLE_LEVEL;									\
	}																\
	ATMOS_MAPPING_COLOR_INT(path, grey, PIPE_COLOR_GREY)			\
	ATMOS_MAPPING_COLOR_INT(path, yello, PIPE_COLOR_YELLOW)			\
	ATMOS_MAPPING_COLOR_INT(path, cyan, PIPE_COLOR_CYAN)			\
	ATMOS_MAPPING_COLOR_INT(path, green, PIPE_COLOR_GREEN)			\
	ATMOS_MAPPING_COLOR_INT(path, orange, PIPE_COLOR_ORANGE)		\
	ATMOS_MAPPING_COLOR_INT(path, purple, PIPE_COLOR_PURPLE)		\
	ATMOS_MAPPING_COLOR_INT(path, dark, PIPE_COLOR_DARK)			\
	ATMOS_MAPPING_COLOR_INT(path, brown, PIPE_COLOR_BROWN)			\
	ATMOS_MAPPING_COLOR_INT(path, violet, PIPE_COLOR_VIOLET)		\
	ATMOS_MAPPING_COLOR_INT(path, red, PIPE_COLOR_RED)				\
	ATMOS_MAPPING_COLOR_INT(path, blue, PIPE_COLOR_BLUE)			\
	ATMOS_MAPPING_COLOR_INT(path, amethyst, PIPE_COLOR_AMETHYST)	\

#define ATMOS_MAPPING_COLOR_INT(path, color, real) ##path/##color/pipe_color = real; ##path/visible/##color/pipe_color = real;

/// Registers a path for every pipe layer. Used for pipes that use pixel-shifting to visualize layers. Includes standard lines.
#define ATMOS_MAPPING_LAYERS_PX_DOUBLE(path)					\
	ATMOS_MAPPING_LAYERS_PX_INT(path)

/// Registers a path for every pipe layer. Used for pipes that use icon-# state changes to visualize layers. Includes standard lines.
#define ATMOS_MAPPING_LAYERS_IX(path, iconbase)					\
	ATMOS_MAPPING_LAYERS_IX_INT(path, iconbase)

#define ATMOS_MAPPING_LAYERS_PX_INT(path)						\
	##path/layer1 {												\
		pipe_layer = 1;											\
		pixel_x = PIPE_LAYER_P_X * (1 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (1 - PIPE_LAYER_DEFAULT);	\
	}															\
	##path/layer2 {												\
		pipe_layer = 2;											\
		pixel_x = PIPE_LAYER_P_X * (2 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (2 - PIPE_LAYER_DEFAULT);	\
	}															\
	##path/layer3 {												\
		pipe_layer = 3;											\
		pixel_x = PIPE_LAYER_P_X * (3 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (3 - PIPE_LAYER_DEFAULT);	\
	}															\
	##path/layer4 {												\
		pipe_layer = 4;											\
		pixel_x = PIPE_LAYER_P_X * (4 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (4 - PIPE_LAYER_DEFAULT);	\
	}															\
	##path/layer5 {												\
		pipe_layer = 5;											\
		pixel_x = PIPE_LAYER_P_X * (5 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (5 - PIPE_LAYER_DEFAULT);	\
	}

#define ATMOS_MAPPING_LAYERS_IX_INT(path, iconbase)	\
	##path/layer1 {									\
		pipe_layer = 1;								\
		icon_state = iconbase + "-1"				\
	}												\
	##path/layer2 {									\
		pipe_layer = 2;								\
		icon_state = iconbase + "-2"				\
	}												\
	##path/layer3 {									\
		pipe_layer = 3;								\
		icon_state = iconbase + "-3"				\
	}												\
	##path/layer4 {									\
		pipe_layer = 4;								\
		icon_state = iconbase + "-4"				\
	}												\
	##path/layer5 {									\
		pipe_layer = 5;								\
		icon_state = iconbase + "-5"				\
	}

#define ATMOS_MAPPING_LAYERS_PX_COLORS_INT(path)				\
	##path/layer1 {												\
		pipe_layer = 1;											\
		pixel_x = PIPE_LAYER_P_X * (1 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (1 - PIPE_LAYER_DEFAULT);	\
	}															\
	##path/layer2 {												\
		pipe_layer = 2;											\
		pixel_x = PIPE_LAYER_P_X * (2 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (2 - PIPE_LAYER_DEFAULT);	\
	}															\
	##path/layer3 {												\
		pipe_layer = 3;											\
		pixel_x = PIPE_LAYER_P_X * (3 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (3 - PIPE_LAYER_DEFAULT);	\
	}															\
	##path/layer4 {												\
		pipe_layer = 4;											\
		pixel_x = PIPE_LAYER_P_X * (4 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (4 - PIPE_LAYER_DEFAULT);	\
	}															\
	##path/layer5 {												\
		pipe_layer = 5;											\
		pixel_x = PIPE_LAYER_P_X * (5 - PIPE_LAYER_DEFAULT);	\
		pixel_y = PIPE_LAYER_P_Y * (5 - PIPE_LAYER_DEFAULT);	\
	}															\
	ATMOS_MAPPING_COLORS(path/layer1)							\
	ATMOS_MAPPING_COLORS(path/layer2)							\
	ATMOS_MAPPING_COLORS(path/layer3)							\
	ATMOS_MAPPING_COLORS(path/layer4)							\
	ATMOS_MAPPING_COLORS(path/layer5)

#define ATMOS_MAPPING_LAYERS_IX_COLORS_INT(path)	\
	##path/layer1 {									\
		pipe_layer = 1;								\
		icon_state = iconbase + "-1"				\
	}												\
	##path/layer2 {									\
		pipe_layer = 2;								\
		icon_state = iconbase + "-2"				\
	}												\
	##path/layer3 {									\
		pipe_layer = 3;								\
		icon_state = iconbase + "-3"				\
	}												\
	##path/layer4 {									\
		pipe_layer = 4;								\
		icon_state = iconbase + "-4"				\
	}												\
	##path/layer5 {									\
		pipe_layer = 5;								\
		icon_state = iconbase + "-5"				\
	}
	ATMOS_MAPPING_COLORS(path/layer1)							\
	ATMOS_MAPPING_COLORS(path/layer2)							\
	ATMOS_MAPPING_COLORS(path/layer3)							\
	ATMOS_MAPPING_COLORS(path/layer4)							\
	ATMOS_MAPPING_COLORS(path/layer5)

/// Registers a path for default layer and color only, without more colors/layers
#define ATMOS_MAPPING_MINIMAL(path)		\
	##path/visible {					\
		level = PIPE_VISIBLE_LEVEL		\
	}									\
	##path/hidden {						\
		level = PIPE_HIDDEN_LEVEL		\
	}

#define ATMOS_MAPPING_DISTRO(path)		\
	##path/distro {						\
		pipe_color = PIPE_COLOR_BLUE;	\
		pipe_layer = 2;					\
	}									\
	ATMOS_MAPPING_MINIMAL(path/distro)

#define ATMOS_MAPPING_SCRUBBER(path)	\
	##path/scrubber {					\
		pipe_color = PIPE_COLOR_RED;	\
		pipe_layer = 4;					\
	}									\
	ATMOS_MAPPING_MINIMAL(path/scrubber)

#define ATMOS_MAPPING_FUEL(path)		\
	##path/fuel {						\
		pipe_color = PIPE_COLOR_YELLOW;	\
		pipe_layer = 1;					\
	}									\
	ATMOS_MAPPING_MINIMAL(path/fuel)

#define ATMOS_MAPPING_AUX(path)			\
	##path/aux {						\
		pipe_color = PIPE_COLOR_VIOLET;	\
		pipe_layer = 5;					\
	}									\
	ATMOS_MAPPING_MINIMAL(path/aux)

#define ATMOS_MAPPING_GENERAL(path)		\
	##path/general {					\
		pipe_color = PIPE_COLOR_GREY;	\
		pipe_layer = 3;					\
	}									\
	ATMOS_MAPPING_MINIMAL(path/general)
