// Control flags
/// Default control flags
#define RIG_CONTROL_DEFAULT						ALL
/// Can move the suit
#define RIG_CONTROL_MOVEMENT					(1<<0)
/// Can use hands
#define RIG_CONTROL_HANDS						(1<<1)
/// Can activate/deactivate the rig
#define RIG_CONTROL_ACTIVATION					(1<<2)
/// Can view UI
#define RIG_CONTROL_UI_VIEW						(1<<3)
/// Can control UI other than modules (modules is UI_MODULES)
#define RIG_CONTROL_UI_CONTROL					(1<<4)
/// Can interact with hotbinds
#define RIG_CONTROL_USE_HOTBINDS				(1<<4)
/// Can activate non hotbound modules
#define RIG_CONTROL_UI_MODULES					(1<<5)
/// Can deploy/undeploy pieces
#define RIG_CONTROL_DEPLOY						(1<<6)
