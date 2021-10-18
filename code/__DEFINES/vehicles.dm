//Vehicle control flags. control flags describe access to actions in a vehicle.

///controls the vehicles movement
#define VEHICLE_CONTROL_DRIVE (1<<0)
///Can't leave vehicle voluntarily, has to resist.
#define VEHICLE_CONTROL_KIDNAPPED (1<<1)
///melee attacks/shoves a vehicle may have
#define VEHICLE_CONTROL_MELEE (1<<2)
///using equipment/weapons on the vehicle
#define VEHICLE_CONTROL_EQUIPMENT (1<<3)
///changing around settings and the like.
#define VEHICLE_CONTROL_SETTINGS (1<<4)

//car_traits flags
///Will this car kidnap people by ramming into them?
#define CAN_KIDNAP (1<<0)

#define CLOWN_CANNON_INACTIVE 0
#define CLOWN_CANNON_BUSY 1
#define CLOWN_CANNON_READY 2
