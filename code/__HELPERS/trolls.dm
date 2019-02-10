//coisas do sangue wip aqui ok

/proc/random_troll_caste()
	return pick(GLOB.troll_castes)

/proc/random_troll_horns()
	return pick(GLOB.alternian_horns_list)

/proc/get_color_from_caste(troll_caste)
	switch(troll_caste)
		if("burgundy")
			return "a10000"
		if("brown")
			return "a25203"
		if("yellow")
			return "a1a100"
		if("lime")
			return "658200"
		if("olive")
			return "416600"
		if("jade")
			return "078446"
		if("teal")
			return "008282"
		if("cerulean")
			return "004182"
		if("indigo")
			return "0021cb"
		if("purple")
			return "631db4"
		if("violet")
			return "6a006a"
		if("fuschia")
			return "99004d"

GLOBAL_LIST_INIT(troll_castes, list(
	"burgundy",
	"brown",
	"yellow",
	"lime",
	"olive",
	"jade",
	"teal",
	"cerulean",
	"indigo",
	"purple",
	"violet",
	"fuschia"
	))