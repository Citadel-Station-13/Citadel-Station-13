#define PLAYERPOLL_INSTANT_RUNOFF			1		//Single question, multiple choices, Full fledged IRV
#define PLAYERPOLL_TEXT_RESPONSE			2		//Single question, single freeform text response
#define PLAYERPOLL_CHOICES					3		//Single question, variable choices, choose variable amount
#define PLAYERPOLL_RATING					5		//Single question, variable choices, rate variable number

#define PLAYERPOLL_TABLENAME_OPTIONS "poll_options"
#define PLAYERPOLL_TABLENAME_POLLS "polls"
#define PLAYERPOLL_TABLENAME_RESPONSES "poll_responses"

#define PLAYERPOLL_TABLENAMEF_OPTIONS PLAYERPOLL_FORMAT_TABLE_NAME("poll_options")
#define PLAYERPOLL_TABLENAMEF_POLLS PLAYERPOLL_FORMAT_TABLE_NAME("polls")
#define PLAYERPOLL_TABLENAMEF_RESPONSES PLAYERPOLL_FORMAT_TABLE_NAME("poll_responses")

#define PLAYERPOLL_RATING_MIN 1
#define PLAYERPOLL_RATING_MAX 5
