
//How experience levels are calculated.
#define XP_LEVEL(std, multi, lvl) (std*((multi**lvl)/(multi-1))-std/(multi-1)) //don't use 1 as multi, you'll get division by zero errors
#define DORF_XP_LEVEL(std, extra, lvl) (std*lvl+extra*(lvl*(lvl/2+0.5)))

//More experience value getter macros
#define GET_STANDARD_LVL(lvl) XP_LEVEL(STD_XP_LVL_UP, STD_XP_LVL_MULTI, lvl)
#define GET_DORF_LVL(lvl) DORF_XP_LEVEL(DORF_XP_LVL_UP, DORF_XP_LVL_MULTI, lvl)
