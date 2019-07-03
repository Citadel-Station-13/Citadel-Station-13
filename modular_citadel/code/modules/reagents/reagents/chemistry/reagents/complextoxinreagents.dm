
/datum/reagent/fermi/iodomethane
  name = "Methyl Iodide"  //rocket fuel precursor time
  id = "iodomethane"
  description = "A potent toxin created by adding iodine to methanol and phosphorus."
  color = "#00000000" // rgb: 0, 0, 0, 0
  taste_description = "water"
  taste_mult = 0
  metabolization_rate = 0.6 * REAGENTS_METABOLISM
  var/toxpwr = 4.5

/datum/reagent/fermi/dimethylmercury
  name = "Dimethylmercury"  //Rocket fuel time
  id = "dimethylmercury"
  description = "An extremely potent toxin and explosive declared too dangerous for use even as a rocket fuel."
  color = "#00000000" // rgb: 0, 0, 0, 0
  taste_description = "sweet, sweet death"
  metabolization_rate = 0.7 * REAGENTS_METABOLISM
  var/toxpwr = 9
