#define INSTRUMENT_MIN_OCTAVE 1
#define INSTRUMENT_MAX_OCTAVE 9
#define INSTRUMENT_MAX_SUSTAIN 50		//Synth samples are only 50 ds long!
#define INSTRUMENT_MIN_EXP_DECAY 1.07
#define INSTRUMENT_MAX_EXP_DECAY 10
#define INSTRUMENT_MIN_VOLUME 25
#define INSTRUMENT_MAX_VOLUME 100

#define SUSTAIN_LINEAR 1
#define SUSTAIN_EXPONENTIAL 2

// /datum/instrument instrument_flags
#define INSTRUMENT_LEGACY (1<<0)					//Legacy instrument. Implies INSTRUMENT_DO_NOT_AUTOSAMPLE
#define INSTRUMENT_DO_NOT_AUTOSAMPLE (1<<1)			//Do not automatically sample
