/**
 * Body types, used in sprites and clothing
 */

// Body types - use as single value if passed in as request, use as flag in /obj/item's worn_bodytypes
/// normal
#define BODY_TYPE_DEFAULT			(1<<0)

// *sighs*
/proc/body_type_define_to_state_append(define)
	switch(define)
		if(BODY_TYPE_DEFAULT)
			return ""

// /obj/item worn_bodytype_support
/// entirely ignore bodytype param, always render as default
#define BODYTYPE_SUPPORT_IGNORE			"ignore"
/// only has default, always force to default. the difference is if a codebase wants to add bodytype support they can use this vs ignore. do not append anything to state.
#define BODYTYPE_SUPPORT_NONE			"none"
/// use flags
#define BODYTYPE_SUPPORT_FLAGS			"flags"

// /obj/item/mutantrace_support - ONLY VALID ON BODY_TYPE_DEFAULT
/// digitigrades
#define MUTANT_DIGITIGRADE			(1<<1)
/// snouts
#define MUTANT_SNOUT				(1<<3)
/// hooved taur
#define MUTANT_TAUR_HOOVED			(1<<4)
/// naga taur
#define MUTANT_TAUR_NAGA			(1<<5)
/// paw taur
#define MUTANT_TAUR_PAW				(1<<6)

// *sighs* x2
/proc/mutantrace_support_define_to_state_append(define)
	switch(define)
		if(MUTANT_DIGITIGRADE)
			return "_digi"
		if(MUTANT_TAUR_HOOVED)
			return "_hooves"
		if(MUTANT_TAUR_NAGA)
			return "_naga"
		if(MUTANT_TAUR_PAW)
			return "_paw"
		if(MUTANT_SNOUT)
			return "_snout"
