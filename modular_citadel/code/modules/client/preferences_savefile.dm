/datum/preferences/proc/cit_character_pref_load(savefile/S)
	//ipcs
	S["feature_ipc_screen"] >> features["ipc_screen"]
	S["feature_ipc_antenna"] >> features["ipc_antenna"]

	features["ipc_screen"] 	= sanitize_inlist(features["ipc_screen"], GLOB.ipc_screens_list)
	features["ipc_antenna"] 	= sanitize_inlist(features["ipc_antenna"], GLOB.ipc_antennas_list)
	//Citadel
	features["flavor_text"]		= sanitize_text(features["flavor_text"], initial(features["flavor_text"]))
	features["ooc_text"]		= sanitize_text(features["ooc_text"], initial(features["ooc_text"]))
	if(!features["mcolor2"] || features["mcolor"] == "#000")
		features["mcolor2"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!features["mcolor3"] || features["mcolor"] == "#000")
		features["mcolor3"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	features["mcolor2"]	= sanitize_hexcolor(features["mcolor2"], 3, 0)
	features["mcolor3"]	= sanitize_hexcolor(features["mcolor3"], 3, 0)

	S["alt_titles_preferences"] 		>> alt_titles_preferences
	alt_titles_preferences = SANITIZE_LIST(alt_titles_preferences)
	if(SSjob)
		for(var/datum/job/job in SSjob.occupations)
			if(alt_titles_preferences[job.title])
				if(!(alt_titles_preferences[job.title] in job.alt_titles))
					alt_titles_preferences.Remove(job.title)

	//gear loadout
	var/text_to_load
	S["loadout"] >> text_to_load
	var/list/saved_loadout_paths = splittext(text_to_load, "|")
	LAZYCLEARLIST(chosen_gear)
	gear_points = initial(gear_points)
	for(var/i in saved_loadout_paths)
		var/datum/gear/path = text2path(i)
		if(path)
			LAZYADD(chosen_gear, path)
			gear_points -= initial(path.cost)

/datum/preferences/proc/cit_character_pref_save(savefile/S)
	//ipcs
	WRITE_FILE(S["feature_ipc_screen"], features["ipc_screen"])
	WRITE_FILE(S["feature_ipc_antenna"], features["ipc_antenna"])
	//Citadel
	WRITE_FILE(S["feature_genitals_use_skintone"], features["genitals_use_skintone"])
	WRITE_FILE(S["feature_exhibitionist"], features["exhibitionist"])
	WRITE_FILE(S["feature_mcolor2"], features["mcolor2"])
	WRITE_FILE(S["feature_mcolor3"], features["mcolor3"])
	WRITE_FILE(S["feature_mam_body_markings"], features["mam_body_markings"])
	WRITE_FILE(S["feature_mam_tail"], features["mam_tail"])
	WRITE_FILE(S["feature_mam_ears"], features["mam_ears"])
	WRITE_FILE(S["feature_mam_tail_animated"], features["mam_tail_animated"])
	WRITE_FILE(S["feature_taur"], features["taur"])
	WRITE_FILE(S["feature_mam_snouts"],	features["mam_snouts"])
	//Xeno features
	WRITE_FILE(S["feature_xeno_tail"], features["xenotail"])
	WRITE_FILE(S["feature_xeno_dors"], features["xenodorsal"])
	WRITE_FILE(S["feature_xeno_head"], features["xenohead"])
	//cock features
	WRITE_FILE(S["feature_has_cock"], features["has_cock"])
	WRITE_FILE(S["feature_cock_shape"], features["cock_shape"])
	WRITE_FILE(S["feature_cock_color"], features["cock_color"])
	WRITE_FILE(S["feature_cock_length"], features["cock_length"])
	WRITE_FILE(S["feature_cock_girth"], features["cock_girth"])
	WRITE_FILE(S["feature_cock_girth_ratio"], features["cock_girth_ratio"])
	WRITE_FILE(S["feature_has_sheath"], features["sheath_color"])
	//balls features
	WRITE_FILE(S["feature_has_balls"], features["has_balls"])
	WRITE_FILE(S["feature_balls_color"], features["balls_color"])
	WRITE_FILE(S["feature_balls_size"], features["balls_size"])
	WRITE_FILE(S["feature_balls_shape"], features["balls_shape"])
	WRITE_FILE(S["feature_balls_sack_size"], features["balls_sack_size"])
	WRITE_FILE(S["feature_balls_fluid"], features["balls_fluid"])
	//breasts features
	WRITE_FILE(S["feature_has_breasts"], features["has_breasts"])
	WRITE_FILE(S["feature_breasts_size"], features["breasts_size"])
	WRITE_FILE(S["feature_breasts_shape"], features["breasts_shape"])
	WRITE_FILE(S["feature_breasts_color"], features["breasts_color"])
	WRITE_FILE(S["feature_breasts_fluid"], features["breasts_fluid"])
	WRITE_FILE(S["feature_breasts_producing"], features["breasts_producing"])
	//vagina features
	WRITE_FILE(S["feature_has_vag"], features["has_vag"])
	WRITE_FILE(S["feature_vag_shape"], features["vag_shape"])
	WRITE_FILE(S["feature_vag_color"], features["vag_color"])
	//womb features
	WRITE_FILE(S["feature_has_womb"], features["has_womb"])
	//pregnancy features
	WRITE_FILE(S["feature_can_get_preg"], features["can_get_preg"])
	//flavor text
	WRITE_FILE(S["feature_flavor_text"], features["flavor_text"])
	WRITE_FILE(S["feature_silicon_flavor_text"], features["silicon_flavor_text"])
	WRITE_FILE(S["feature_ooc_text"], features["ooc_text"])
	//custom job titles
	WRITE_FILE(S["alt_titles_preferences"], alt_titles_preferences)
	//belly features
	WRITE_FILE(S["feature_has_belly"], features["has_belly"])
	WRITE_FILE(S["feature_belly_size"], features["belly_size"])
	WRITE_FILE(S["feature_belly_color"], features["belly_color"])
	WRITE_FILE(S["feature_hide_belly"], features["hide_belly"])
	WRITE_FILE(S["feature_inflatable_belly"], features["inflatable_belly"])
	//butt features
	WRITE_FILE(S["feature_has_anus"], features["has_anus"])
	WRITE_FILE(S["feature_butt_size"], features["butt_size"])
	WRITE_FILE(S["feature_butt_color"], features["butt_color"])
	//pins
	WRITE_FILE(S["pins"], pins)

	//gear loadout
	if(islist(chosen_gear))
		if(chosen_gear.len)
			var/text_to_save = chosen_gear.Join("|")
			S["loadout"] << text_to_save
		else
			S["loadout"] << "" //empty string to reset the value
