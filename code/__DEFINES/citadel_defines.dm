//Global defines for most of the unmentionables.
//Be sure to update the min/max of these if you do change them.
//Measurements are in imperial units. Inches, feet, yards, miles. Tsp, tbsp, cups, quarts, gallons, etc

//arousal HUD location
#define  ui_arousal "EAST-1:28,CENTER-3:11"//Below the health doll


//organ defines
#define COCK_SIZE_MIN		1
#define COCK_SIZE_MAX		20

#define COCK_GIRTH_RATIO_MAX		1.25
#define COCK_GIRTH_RATIO_DEF		0.75
#define COCK_GIRTH_RATIO_MIN		0.5

#define KNOT_GIRTH_RATIO_MAX		3
#define KNOT_GIRTH_RATIO_DEF		2.1
#define KNOT_GIRTH_RATIO_MIN		1.25

#define BALLS_VOLUME_BASE	25
#define BALLS_VOLUME_MULT	1

#define BALLS_SIZE_MIN		1
#define BALLS_SIZE_DEF	3
#define BALLS_SIZE_MAX		7

#define BALLS_SACK_SIZE_MIN 1
#define BALLS_SACK_SIZE_DEF	8
#define BALLS_SACK_SIZE_MAX 40

#define CUM_RATE			5
#define CUM_RATE_MULT		1
#define CUM_EFFICIENCY		1//amount of nutrition required per life()

#define EGG_GIRTH_MIN		1//inches
#define EGG_GIRTH_DEF		6
#define EGG_GIRTH_MAX		16

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
#define BREASTS_SIZE_DEF	BREASTS_SIZE_C
#define BREASTS_SIZE_MAX 	BREASTS_SIZE_HH

#define MILK_RATE			5
#define MILK_RATE_MULT		1
#define MILK_EFFICIENCY		1

//Individual logging define
#define INDIVIDUAL_LOOC_LOG "LOOC log"

#define ADMIN_MARKREAD(client) "(<a href='?_src_=holder;markedread=\ref[client]'>MARK READ</a>)"//marks an adminhelp as read and under investigation
#define ADMIN_IC(client) "(<a href='?_src_=holder;icissue=\ref[client]'>IC</a>)"//marks and adminhelp as an IC issue
#define ADMIN_REJECT(client) "(<a href='?_src_=holder;rejectadminhelp=\ref[client]'>REJT</a>)"//Rejects an adminhelp for being unclear or otherwise unhelpful. resets their adminhelp timer
