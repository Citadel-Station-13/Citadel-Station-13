#define PLURALITY_VOTING "PLURALITY"
#define APPROVAL_VOTING "APPROVAL"
#define SCHULZE_VOTING "SCHULZE"
#define SCORE_VOTING "SCORE"
#define HIGHEST_MEDIAN_VOTING "HIGHEST_MEDIAN"
#define INSTANT_RUNOFF_VOTING "IRV"

#define SHOW_RESULTS (1<<0)
#define SHOW_VOTES (1<<1)
#define SHOW_WINNER (1<<2)
#define SHOW_ABSTENTION (1<<3)

GLOBAL_LIST_INIT(vote_score_options,list("Bad","Poor","Acceptable","Good","Great"))

GLOBAL_LIST_INIT(vote_type_names,list(\
"Plurality (default)" = PLURALITY_VOTING,\
"Approval" = APPROVAL_VOTING,\
"IRV (single winner ranked choice)" = INSTANT_RUNOFF_VOTING,\
"Schulze (ranked choice, higher result=better)" = SCHULZE_VOTING,\
"Raw Score (returns results from 0 to 1, winner is 1)" = SCORE_VOTING,\
"Highest Median (single-winner score voting)" = HIGHEST_MEDIAN_VOTING,\
))

GLOBAL_LIST_INIT(display_vote_settings, list(\
"Results" = SHOW_RESULTS,
"Ongoing Votes" = SHOW_VOTES,
"Winner" =  SHOW_WINNER,
"Abstainers" = SHOW_ABSTENTION
))
