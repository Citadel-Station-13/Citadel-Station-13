#define STARTING_PAYCHECKS 5

#define PAYCHECK_ASSISTANT 25
#define PAYCHECK_MINIMAL 75
#define PAYCHECK_EASY 125
#define PAYCHECK_MEDIUM 175
#define PAYCHECK_HARD 200
#define PAYCHECK_COMMAND 250

#define MAX_GRANT_CIV 2500
#define MAX_GRANT_ENG 3000
#define MAX_GRANT_SCI 5000
#define MAX_GRANT_SECMEDSRV 3000

//What should vending machines charge when you buy something in-department.
#define VENDING_DISCOUNT 0 // price * discount so 0 = 0

#define ACCOUNT_CIV "CIV"
#define ACCOUNT_CIV_NAME "Civil Budget"
#define ACCOUNT_ENG "ENG"
#define ACCOUNT_ENG_NAME "Engineering Budget"
#define ACCOUNT_SCI "SCI"
#define ACCOUNT_SCI_NAME "Scientific Budget"
#define ACCOUNT_MED "MED"
#define ACCOUNT_MED_NAME "Medical Budget"
#define ACCOUNT_SRV "SRV"
#define ACCOUNT_SRV_NAME "Service Budget"
#define ACCOUNT_CAR "CAR"
#define ACCOUNT_CAR_NAME "Cargo Budget"
#define ACCOUNT_SEC "SEC"
#define ACCOUNT_SEC_NAME "Defense Budget"

#define NO_FREEBIES "commies go home"

//ID bank account support defines.
#define ID_NO_BANK_ACCOUNT		0
#define ID_FREE_BANK_ACCOUNT	1
#define ID_LOCKED_BANK_ACCOUNT	2

//Some price defines to help standarize the intended vending value of items. Do not bother adding too many examples.
#define PRICE_FREE				0 // Sustainance/soviet vendor stuff.
#define PRICE_CHEAP_AS_FREE		10 // Cheap lighters, syringes, soft drinks etc.
#define PRICE_REALLY_CHEAP		20 // Snacks, hot drinks, tools.
#define PRICE_PRETTY_CHEAP		30 // Some snacks, beer.
#define PRICE_CHEAP				40 // Clothings. some electronics
#define PRICE_ALMOST_CHEAP		60 // Fancy clothing, cig packs, booze-o-mat, seeds, medical.
#define PRICE_BELOW_NORMAL		80 // Clothesmate and kinkmate premium stuff.
#define PRICE_NORMAL			100 // Kitchen knife, other stuff.
#define PRICE_ABOVE_NORMAL		150 // Liberation (capitalism ahoy) and donksoft vendors.
#define PRICE_ALMOST_EXPENSIVE	200 // Butcher knife, cartridges, some premium stuff.
#define PRICE_EXPENSIVE			325 // Premium stuff.
#define PRICE_ABOVE_EXPENSIVE	500 // RCD, Crew pinpointer/monitor, galoshes
#define PRICE_REALLY_EXPENSIVE	700 // More premium stuff.
#define PRICE_ALMOST_ONE_GRAND	900 // $$$ Insulated gloves, backpack water-tank spray $$$
