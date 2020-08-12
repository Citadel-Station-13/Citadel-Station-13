// Everyone, but Civilian and Service
#define NOCIV_ROLES list(\
						"Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Quartermaster",\
						"Medical Doctor", "Chemist", "Paramedic", "Virologist", "Geneticist", "Scientist", "Roboticist",\
						"Atmospheric Technician", "Station Engineer", "Warden", "Detective", "Security Officer", "Blueshield", "Brig Physician",\
						"Cargo Technician", "Shaft Miner"\
						)

// Literally everyone, but Prisoners. Hopefully tempoary, until proper blacklist.
#define NOPRISON_ROLES list(\
							"Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Quartermaster",\
							"Medical Doctor", "Chemist", "Paramedic", "Virologist", "Geneticist", "Scientist", "Roboticist",\
							"Atmospheric Technician", "Station Engineer", "Warden", "Detective", "Security Officer", "Blueshield", "Brig Physician",\
							"Cargo Technician", "Shaft Miner", "Bartender", "Botanist", "Cook", "Curator", "Chaplain", "Janitor",\
							"Clown", "Mime", "Lawyer", "Assistant"\
							)

// Some of these might be left unused, but still it's nice to have them around.
#define CMD_ROLES list("Captain", "Head of Personnel", "Head of Security", "Chief Engineer", "Research Director", "Chief Medical Officer", "Quartermaster")
#define MED_ROLES list("Chief Medical Officer", "Medical Doctor", "Virologist", "Chemist", "Geneticist", "Paramedic", "Brig Physician")
#define SCI_ROLES list("Research Director", "Scientist", "Roboticist")
#define SEC_ROLES list("Head of Security", "Security Officer", "Warden", "Brig Physician", "Blueshield")
#define ENG_ROLES list("Chief Engineer", "Atmospheric Technician", "Station Engineer")
#define CRG_ROLES list("Quartermaster", "Cargo Technician", "Shaft Miner")
#define CIV_ROLES list("Head of Personnel", "Bartender", "Botanist", "Cook", "Curator", "Chaplain", "Janitor", "Clown", "Mime", "Lawyer", "Assistant")
#define FUN_ROLES list("Clown", "Mime")

// Hybrids. Might be left unused even more, aside from OrviTrek-like stuff. As for OPRS it is ENG+SEC+CRG.
#define MEDSCI_ROLES list(\
						"Chief Medical Officer", "Medical Doctor", "Virologist", "Chemist", "Geneticist", "Paramedic",\
						"Research Director", "Scientist", "Roboticist"\
						)
#define OPRS_ROLES list(\
						"Head of Security", "Security Officer", "Warden", "Brig Physician", "Blueshield",\
						"Chief Engineer", "Atmospheric Technician", "Station Engineer",\
						"Quartermaster", "Cargo Technician", "Shaft Miner"\
						)
