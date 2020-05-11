//MULTIPIPES
//IF YOU EVER CHANGE THESE CHANGE SPRITES TO MATCH.
/// Minimum piping layer
#define PIPING_LAYER_MIN 1
/// Maximum piping layer
#define PIPING_LAYER_MAX 3
/// Default piping layer
#define PIPING_LAYER_DEFAULT 2
/// How much to shift pixel x per layer
#define PIPING_LAYER_P_X 5
/// How much to shift pixel y per layer
#define PIPING_LAYER_P_Y 5
/// How much to change byond rendering layer variable per layer
#define PIPING_LAYER_LCHANGE 0.05

//HELPERS
/// Shift T pixel x OR pixel y perpendicular to direction based on pipping layer
#define PIPING_LAYER_SHIFT(T, PipingLayer) \
	if(T.dir & (NORTH|SOUTH)) {									\
		T.pixel_x = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X;\
	}																		\
	if(T.dir & (WEST|EAST)) {										\
		T.pixel_y = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y;\
	}

/// Shift T pixel x and y by piping layer
#define PIPING_LAYER_DOUBLE_SHIFT(T, PipingLayer) \
	T.pixel_x = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X;\
	T.pixel_y = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y;
