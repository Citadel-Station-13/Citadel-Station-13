//include unit test files in this module in this ifdef
// CITADEL EDIT add vore_tests.dm
#ifdef UNIT_TESTS
#include "unit_test.dm"
#include "reagent_recipe_collisions.dm"
#include "reagent_id_typos.dm"
<<<<<<< HEAD
//#include "vore_tests.dm"
=======
#include "subsystem_init.dm"
>>>>>>> 70beb65... Unit test to make sure all subsystems which initialize call parent (#36466)
#endif
