#define PLURALITY_VOTING 0
#define APPROVAL_VOTING 1
#define SCHULZE_VOTING 2
#define SCORE_VOTING 3
#define MAJORITY_JUDGEMENT_VOTING 4
#define INSTANT_RUNOFF_VOTING 5

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
"Majority Judgement (single-winner score voting)" = MAJORITY_JUDGEMENT_VOTING,\
))

GLOBAL_LIST_INIT(display_vote_settings, list(\
"Results" = SHOW_RESULTS,
"Ongoing Votes" = SHOW_VOTES,
"Winner" =  SHOW_WINNER,
"Abstainers" = SHOW_ABSTENTION
))