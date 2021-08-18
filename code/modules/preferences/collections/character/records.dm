/datum/preferences_collection/character/records
	save_key = PREFERENCES_SAVE_KEY_RECORDS
	sort_order = 6



	/// Security record note section
	var/security_records
	/// Medical record note section
	var/medical_records


			dat += "<br>Records</b><br>"
			dat += "<br><a href='?_src_=prefs;preference=security_records;task=input'><b>Security Records</b></a><br>"
			if(length_char(security_records) <= 40)
				if(!length(security_records))
					dat += "\[...\]"
				else
					dat += "[security_records]"
			else
				dat += "[TextPreview(security_records)]...<BR>"

			dat += "<br><a href='?_src_=prefs;preference=medical_records;task=input'><b>Medical Records</b></a><br>"
			if(length_char(medical_records) <= 40)
				if(!length(medical_records))
					dat += "\[...\]<br>"
				else
					dat += "[medical_records]"
			else
				dat += "[TextPreview(medical_records)]...<BR>"
			dat += "</tr></table>"


	//Records
	S["security_records"]			>>			security_records
	S["medical_records"]			>>			medical_records

				if("security_records")
					var/rec = stripped_multiline_input(usr, "Set your security record note section. This should be IC!", "Security Records", html_decode(security_records), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(rec))
						security_records = rec

				if("medical_records")
					var/rec = stripped_multiline_input(usr, "Set your medical record note section. This should be IC!", "Security Records", html_decode(medical_records), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(rec))
						medical_records = rec
