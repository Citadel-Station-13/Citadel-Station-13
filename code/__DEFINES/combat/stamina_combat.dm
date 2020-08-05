// Stamina Buffer
/// Stamina buffer amount
#define STAMINA_BUFFER_CAPACITY 35
/// Stamina buffer regen per decisecond
#define STAMINA_BUFFER_REGEN_DS 0.1
/// Stamina buffer regen multiplier while in combat mode
#define STAMINA_BUFFER_REGEN_COMBAT_MULT 3
/// Linear scaling minimum for stamina buffer regen in percentage at stamcrit
#define STAMINA_BUFFER_STAMCRIT_PENALTY_REGEN 0.75
/// Linear scaling minimum for stamina buffer capacity in percentage at stamcrit
#define STAMINA_BUFFER_STAMCRIT_PENALTY_CAPACITY 0.5

// Standard amounts for stamina usage

// Multipliers
/// Base stamina cost for an item of a certain w_class without total_mass set.
#define STAM_COST_W_CLASS_MULT			1.25

// Flat amounts
/// Usage for eyestabbing with a screwdriver
#define STAMINA_COST_ITEM_EYESTAB		7.5
/// Usage for shoving yourself off the ground instantly
#define STAMINA_COST_SHOVE_UP			10

//items total mass, used to calculate their attacks' stamina costs. If not defined, the cost will be (w_class * 1.25)
#define TOTAL_MASS_TINY_ITEM		1.25
#define TOTAL_MASS_SMALL_ITEM		2.5
#define TOTAL_MASS_NORMAL_ITEM		3.75
#define TOTAL_MASS_BULKY_ITEM		5
#define TOTAL_MASS_HUGE_ITEM		6.25
#define TOTAL_MASS_GIGANTIC_ITEM	7.5

#define TOTAL_MASS_HAND_REPLACEMENT	5 //standard punching stamina cost. most hand replacements are huge items anyway.
#define TOTAL_MASS_MEDIEVAL_WEAPON	3.6 //very, very generic average sword/warpick/etc. weight in pounds.
#define TOTAL_MASS_TOY_SWORD 1.5

//stamina cost defines.
#define STAM_COST_ATTACK_OBJ_MULT	1.2
#define STAM_COST_ATTACK_MOB_MULT	1
#define STAM_COST_BATON_MOB_MULT	1
#define STAM_COST_THROW_MULT		2
#define STAM_COST_THROW_MOB			2.5 //multiplied by (mob size + 1)^2.

/// Damage penalty when fighting prone.
#define LYING_DAMAGE_PENALTY			0.7
