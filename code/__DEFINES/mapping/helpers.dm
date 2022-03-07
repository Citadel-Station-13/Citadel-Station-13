/// get step taking into account world structs. border for transitions is 2 away.
#define GET_VIRTUAL_STEP(A, dir) ((SSmapping.managed_z_levels[A.z] && ((A.x <= 2) || (A.y <= 2) || (A.x >= (world.maxx - 1)) || (A.y >= (world.maxy - 1))))? SSmapping.GetVirtualStep(A, dir) : get_step(A, dir))
