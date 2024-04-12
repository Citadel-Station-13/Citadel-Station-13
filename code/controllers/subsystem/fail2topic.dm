SUBSYSTEM_DEF(fail2topic)
	name = "Fail2Topic"
	init_order = INIT_ORDER_FAIL2TOPIC
	flags = SS_BACKGROUND
	runlevels = ALL

	var/list/rate_limiting = list()
	var/list/fail_counts = list()
	var/list/active_bans = list()

	var/rate_limit
	var/max_fails
	var/rule_name
	var/enabled = FALSE

/datum/controller/subsystem/fail2topic/Initialize(timeofday)
	rate_limit = CONFIG_GET(number/fail2topic_rate_limit)
	max_fails = CONFIG_GET(number/fail2topic_max_fails)
	rule_name = CONFIG_GET(string/fail2topic_rule_name)
	enabled = CONFIG_GET(flag/fail2topic_enabled)

	DropFirewallRule() // Clear the old bans if any still remain

	if(!enabled)
		flags |= SS_NO_FIRE
		can_fire = FALSE

	return ..()

/datum/controller/subsystem/fail2topic/fire()
	if(length(rate_limiting))
		var/i = 1
		while(i <= length(rate_limiting))
			var/ip = rate_limiting[i]
			var/last_attempt = rate_limiting[ip]
			if(REALTIMEOFDAY - last_attempt > rate_limit)
				rate_limiting -= ip
				fail_counts -= ip
			else		//if we remove that, and the next element is in its place. check that instead of incrementing.
				++i
			if(MC_TICK_CHECK)
				return

/datum/controller/subsystem/fail2topic/Shutdown()
	DropFirewallRule()

/datum/controller/subsystem/fail2topic/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, rule_name))
		return FALSE
	return ..()

/datum/controller/subsystem/fail2topic/CanProcCall(procname)
	. = ..()
	if(.)
		switch(procname)
			if("IsRateLimited")
				return FALSE
			if("BanFromFirewall")
				return FALSE

/datum/controller/subsystem/fail2topic/proc/IsRateLimited(ip)
	if(IsAdminAdvancedProcCall())
		return FALSE

	var/last_attempt = rate_limiting[ip]

	var/static/datum/config_entry/keyed_list/topic_rate_limit_whitelist/cached_whitelist_entry
	if(!istype(cached_whitelist_entry))
		cached_whitelist_entry = CONFIG_GET(keyed_list/topic_rate_limit_whitelist)

	if(istype(cached_whitelist_entry))
		if(cached_whitelist_entry.config_entry_value[ip])
			return FALSE

	if (active_bans[ip])
		return TRUE

	rate_limiting[ip] = REALTIMEOFDAY

	if (isnull(last_attempt))
		return FALSE

	if (REALTIMEOFDAY - last_attempt > rate_limit)
		fail_counts -= ip
		return FALSE
	else
		var/failures = fail_counts[ip]

		if (isnull(failures))
			fail_counts[ip] = 1
			return TRUE
		else if (failures > max_fails)
			BanFromFirewall(ip)
			return TRUE
		else
			fail_counts[ip] = failures + 1
			return TRUE

/datum/controller/subsystem/fail2topic/proc/BanFromFirewall(ip)
	if (!enabled)
		return
	if(IsAdminAdvancedProcCall())
		return

	active_bans[ip] = REALTIMEOFDAY
	fail_counts -= ip
	rate_limiting -= ip

	if (world.system_type == UNIX)
		. = shell("iptables -A [rule_name] -s [ip] -j DROP")
	else
		. = shell("netsh advfirewall firewall add rule name=\"[rule_name]\" dir=in interface=any action=block remoteip=[ip]")

	if (.)
		subsystem_log("Failed to ban [ip]. Exit code: [.].")
	else if (isnull(.))
		subsystem_log("Failed to invoke shell to ban [ip].")
	else
		subsystem_log("Banned [ip].")

/datum/controller/subsystem/fail2topic/proc/DropFirewallRule()
	if (!enabled)
		return

	active_bans = list()

	if (world.system_type == UNIX)
		. = shell("iptables -F [rule_name]") //Let's just assume that folks running linux are smart enough to have a dedicated chain configured for this.
	else
		. = shell("netsh advfirewall firewall delete rule name=\"[rule_name]\"")

	if (.)
		subsystem_log("Failed to drop firewall rule. Exit code: [.].")
	else if (isnull(.))
		subsystem_log("Failed to invoke shell for firewall rule drop.")
	else
		subsystem_log("Firewall rule dropped.")
