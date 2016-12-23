var/datum/subsystem/parallax/SSparallax

/datum/subsystem/parallax
    name = "Space Parallax"
    init_order = 18
    flags = SS_NO_FIRE

/datum/subsystem/parallax/New()
    NEW_SS_GLOBAL(SSparallax)

/datum/subsystem/parallax/Initialize()
    create_global_parallax_icons()
