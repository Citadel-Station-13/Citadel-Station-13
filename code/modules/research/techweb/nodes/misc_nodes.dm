
/////////////////////////data theory tech/////////////////////////
/datum/techweb_node/datatheory //Computer science
	id = "datatheory"
	display_name = "Data Theory"
	description = "Big Data, in space!"
	prereq_ids = list("base")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/adv_datatheory
	id = "adv_datatheory"
	display_name = "Advanced Data Theory"
	description = "Better insight into programming and data."
	prereq_ids = list("datatheory")
	design_ids = list("icprinter", "icupgadv", "icupgclo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/////////////////////////plasma tech/////////////////////////
/datum/techweb_node/basic_plasma
	id = "basic_plasma"
	display_name = "Basic Plasma Research"
	description = "Research into the mysterious and dangerous substance, plasma."
	prereq_ids = list("engineering")
	design_ids = list("mech_generator")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/adv_plasma
	id = "adv_plasma"
	display_name = "Advanced Plasma Research"
	description = "Research on how to fully exploit the power of plasma."
	prereq_ids = list("basic_plasma")
	design_ids = list("mech_plasma_cutter")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/////////////////////////EMP tech/////////////////////////
/datum/techweb_node/emp_basic //EMP tech for some reason
	id = "emp_basic"
	display_name = "Electromagnetic Theory"
	description = "Study into usage of frequencies in the electromagnetic spectrum."
	prereq_ids = list("base")
	design_ids = list("holosign", "holosignsec", "holosignengi", "holosignatmos", "holosignfirelock", "inducer", "tray_goggles", "holopad")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/emp_adv
	id = "emp_adv"
	display_name = "Advanced Electromagnetic Theory"
	description = "Determining whether reversing the polarity will actually help in a given situation."
	prereq_ids = list("emp_basic")
	design_ids = list("ultra_micro_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/datum/techweb_node/emp_super
	id = "emp_super"
	display_name = "Quantum Electromagnetic Technology"	//bs
	description = "Even better electromagnetic technology."
	prereq_ids = list("emp_adv")
	design_ids = list("quadultra_micro_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/////////////////////////Clown tech/////////////////////////
/datum/techweb_node/clown
	id = "clown"
	display_name = "Clown Technology"
	description = "Honk?!"
	prereq_ids = list("base")
	design_ids = list("air_horn", "honker_main", "honker_peri", "honker_targ", "honk_chassis", "honk_head", "honk_torso", "honk_left_arm", "honk_right_arm",
	"honk_left_leg", "honk_right_leg", "mech_banana_mortar", "mech_mousetrap_mortar", "mech_honker", "mech_punching_face", "implant_trombone", "borg_transform_clown")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
