//include unit test files in this module in this ifdef
//Keep this sorted alphabetically

#ifdef UNIT_TESTS
/// Asserts that a condition is true
/// If the condition is not true, fails the test
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: [reason || "No reason"]") }

/// Asserts that the two parameters passed are equal, fails otherwise
/// Optionally allows an additional message in the case of a failure
#define TEST_ASSERT_EQUAL(a, b, message) if ((a) != (b)) { return Fail("Expected [isnull(a) ? "null" : a] to be equal to [isnull(b) ? "null" : b].[message ? " [message]" : ""]") }

#include "anchored_mobs.dm"
#include "bespoke_id.dm"
// #include "binary_insert.dm"
// #include "card_mismatch.dm" shame we don't have this!
#include "chain_pull_through_space.dm"
#include "character_saving.dm"
#include "component_tests.dm"
// #include "confusion.dm"
// #include "keybinding_init.dm"
#include "machine_disassembly.dm"
#include "medical_wounds.dm"
// #include "metabolizing.dm"
// #include "outfit_sanity.dm"
// #include "plantgrowth_tests.dm"
// #include "quick_swap_sanity.dm" - we don't have quick swap yet
#include "reagent_id_typos.dm"
#include "reagent_recipe_collisions.dm"
#include "resist.dm"
// #include "say.dm" //no saymods, someone update saycode please.
// #include "siunit.dm"
#include "spawn_humans.dm"
// #include "species_whitelists.dm"
#include "subsystem_init.dm"
// #include "surgeries.dm" // fails at random due to a race condition, commented out for now
#include "timer_sanity.dm"
#include "unit_test.dm"

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#endif
