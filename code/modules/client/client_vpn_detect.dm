/client/proc/IsVPN()
	var/datum/ipintel/res = get_ip_intel(address)
	return res.intel >= CONFIG_GET(number/ipintel_rating_bad)
