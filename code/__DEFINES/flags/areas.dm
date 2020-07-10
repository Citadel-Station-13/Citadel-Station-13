/// atmospheric_danger_flags variable
/// Fire (fire alarms trigger this)
#define ATMOSPHERIC_DANGER_FIRE			(1<<0)
/// Breach (super cold temperatures or pressures trigger this)
#define ATMOSPHERIC_DANGER_BREACH		(1<<1)
/// Other (TLV danger levels trigger this)
#define ATMOSPHERIC_DANGER_OTHER		(1<<2)
/// Warn - TLV warning threshold met
#define ATMOSPHERIC_DANGER_WARNING		(1<<3)
