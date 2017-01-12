//Global defines for most of the unmentionables.
//Be sure to update the min/max of these if you do change them.
//Measurements are in imperial units. Inches, feet, yards, miles. Tsp, tbsp, cups, quarts, gallons. etc
#define COCK_SIZE_BASE		3 //length in inches which is multiplied by the values below to estimate length and to generate a sprite for the mob
#define COCK_SIZE_SMALL 	1	//3"-
#define COCK_SIZE_NORMAL 	2	//6"
#define COCK_SIZE_BIG 		3	//9"
#define COCK_SIZE_BIGGER	4	//12"
#define COCK_SIZE_BIGGEST	5	//15"+

#define COCK_SIZE_MIN		1
#define COCK_SIZE_MAX		5

#define COCK_GIRTH_RATIO_MAX		1.25
#define COCK_GIRTH_RATIO_DEF		0.75
#define COCK_GIRTH_RATIO_MIN		0.5

#define KNOT_GIRTH_RATIO_MAX		3
#define KNOT_GIRTH_RATIO_DEF		2.1
#define KNOT_GIRTH_RATIO_MIN		1.25

#define BALLS_VOLUME_BASE	50
#define BALLS_VOLUME_MULT	1

#define BALLS_SIZE_MIN		1
#define BALLS_SIZE_SMALL	1
#define BALLS_SIZE_NORMAL	2
#define BALLS_SIZE_BIG		3
#define BALLS_SIZE_BIGGER	4
#define BALLS_SIZE_BIGGEST	5
#define BALLS_SIZE_MAX		5

#define BALLS_SACK_SIZE_DEF	8

#define CUM_RATE			5
#define CUM_RATE_MULT		1
#define CUM_EFFICIENCY		1//amount of nutrition required per life()

#define EGG_GIRTH_MIN		1//inches
#define EGG_GIRTH_DEF		6
#define EGG_GIRTH_MAX		16

#define EGG_SIZE_SMALL		1
#define EGG_SIZE_NORMAL		2
#define EGG_SIZE_BIG		3

#define BREASTS_VOLUME_BASE	50	//base volume for the reagents in the breasts, multiplied by the size then multiplier. 50u for A cups, 850u for HH cups.
#define BREASTS_VOLUME_MULT	1	//global multiplier for breast volume.
#define BREASTS_SIZE_FLAT	0
#define BREASTS_SIZE_A		1
#define BREASTS_SIZE_AA		1.5
#define BREASTS_SIZE_B		2
#define BREASTS_SIZE_BB		2.5
#define BREASTS_SIZE_C		3
#define BREASTS_SIZE_CC		3.5
#define BREASTS_SIZE_D		4
#define BREASTS_SIZE_DD		4.5
#define BREASTS_SIZE_E		5
#define BREASTS_SIZE_EE		5.5
#define BREASTS_SIZE_F		6
#define BREASTS_SIZE_FF		6.5
#define BREASTS_SIZE_G		7
#define BREASTS_SIZE_GG		7.5//Are these even real sizes? The world may never know because cup sizes make no fucking sense.
#define BREASTS_SIZE_H		8
#define BREASTS_SIZE_HH		8.5//Largest size, ever. For now.

#define BREASTS_SIZE_MIN 	BREASTS_SIZE_A
#define BREASTS_SIZE_MAX 	BREASTS_SIZE_HH

#define MILK_RATE			5
#define MILK_RATE_MULT		1
#define MILK_EFFICIENCY		1

#define VAG_VIRGIN			1
#define VAG_TIGHT			2
#define VAG_NORMAL			3
#define VAG_LOOSE			4
#define VAG_VERYLOOSE		5
#define VAG_GAPING			6

#define SIZEPLAY_TINY 		1
#define SIZEPLAY_MICRO		2
#define SIZEPLAY_NORMAL		3
#define SIZEPLAY_MACRO		4
#define SIZEPLAY_BIGGER		5
