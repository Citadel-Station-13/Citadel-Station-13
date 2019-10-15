/*
Bacterial infections of organs, an expanded subtype of organ trauma, while still quite limited.
Basically, all that differs is a list of resistances (bacteria are treated with antibiotics)
Growth can be limited by Temperature
*/

/datum/bacterium
	var/name = "Bacteria"
    var/antibiotic_resistance = list() //What antibiotics the infection is resistant to, either innately or otherwise
    var/optimal_temp = 310
    var/optimal_temp_Drange = 10 //delta range of plateu phase
    var/inoptimal_temp_Drange = 25 //liner decline to inverse growth

    var/microscope_image //The PNG of the bacteria
    var/microscope_description //The string of the image for the book
