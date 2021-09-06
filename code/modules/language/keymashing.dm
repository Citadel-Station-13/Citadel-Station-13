/datum/language/keymashing
    name = "Keymashing"
    desc = "Spoken by subs."
    speech_verb = "whimsies"
    exclaim_verb = "yelps"
    whisper_verb = "tildes"

/datum/language/keymash/scramble(input)
    . = list()
    for(var/i in 1 to length_char(input))
        . += ascii2text(rand(97, 122))
    return jointext(., "")
