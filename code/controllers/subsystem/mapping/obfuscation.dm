/**
 * Obfuscation module
 *
 * Allows for generating arbitrary obfuscation IDs from static mapload time IDs, that are deterministic within a round.
 */
/datum/controller/subsystem/mapping/PreInit()
	. = ..()
	if(!obfuscation_secret)
		obfuscation_secret = md5(GUID())

/**
 * Generates an obfuscated but constant ID for an original ID for cases where you don't want players codediving for an ID.
 * This is slightly more expensive but is unique for an id/idtype combo, meaning it's safe to reveal - use in cases where you want to allow a player to reverse engineer,
 * but want them to find out ICly rather than codedive for an ID
 *
 * Both original and id_type are CASE INSENSITIVE.
 */
/datum/controller/subsystem/mapping/proc/get_obfuscated_id(original, id_type = "GENERAL")
	if(!original)
		return	// no.
	return md5("[obfuscation_secret]%[lowertext(original)]%[lowertext(id_type)]")
