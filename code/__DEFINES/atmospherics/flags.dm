// pipe_flags variable
#define PIPING_ALL_LAYER				(1<<0)	//intended to connect with all layers, check for all instead of just one.
#define PIPING_ONE_PER_TURF				(1<<1) 	//can only be built if nothing else with this flag is on the tile already.
#define PIPING_DEFAULT_LAYER_ONLY		(1<<2)	//can only exist at PIPING_LAYER_DEFAULT
#define PIPING_CARDINAL_AUTONORMALIZE	(1<<3)	//north/south east/west doesn't matter, auto normalize on build.
/// Automatically shift both pixel x and y for piping layer rather than just the one perpendicular to direction on update_icon().
#define PIPING_AUTO_DOUBLE_SHIFT_OFFSETS		(1<<4)
/// Automatically shift pixel x OR pixel y depending on direction on update_icon().
#define PIPING_AUTO_SHIFT_OFFSETS				(1<<5)
/// Either already attached or attaching into a stationary, networked pipe.
#define PIPING_NETWORK_JOINED					(1<<6)

// pipenet_flags variable on components
/// This component directly attaches to a pipnet and accesses pipenet's air datum, rather than relying on equalization ticks to airflow.
#define PIPENET_DIRECT_ATTACH			(1<<0)
/// This component is potentially going to allow straight-pipe like direct airflow, and should be asked if the pipenet should be expanding past it on equalization_tick()
#define PIPENET_POTENTIAL_VALVE			(1<<1)
