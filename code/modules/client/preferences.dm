		/* CAUTION! CAUTION! CAUTION! CAUTION! CAUTION! *\
		|		THIS FILE CONTAINS HOOKS FOR FOR		 |
		|		CHANGES SPECIFIC TO CITADEL. IF			 |
		|		 YOU'RE FIXING A MERGE CONFLICT			 |
		|		HERE, PLEASE ASK FOR REVIEW FROM		 |
		|		ANOTHER MAINTAINER TO ENSURE YOU		 |
		|		  DON'T INTRODUCE REGRESSIONS.			 |
		\*												*/

GLOBAL_LIST_EMPTY(preferences_datums)

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/clientckey
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_save_slots = 8

	//non-preference stuff
	var/muted = 0
	var/last_ip
	var/last_id

	//Cooldowns for saving/loading. These are four are all separate due to loading code calling these one after another
	var/saveprefcooldown
	var/loadprefcooldown
	var/savecharcooldown
	var/loadcharcooldown

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#c43b23"
	var/aooccolor = "#ce254f"
	var/enable_tips = TRUE
	var/tip_delay = 500 //tip delay in milliseconds

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.


	var/UI_style = null
	var/buttons_locked = FALSE
	var/hotkeys = FALSE
	var/chat_on_map = TRUE
	var/autocorrect = TRUE
	var/radiosounds = TRUE
	var/max_chat_length = CHAT_MESSAGE_MAX_LENGTH
	var/see_chat_non_mob = TRUE
	var/tgui_fancy = TRUE
	var/tgui_lock = TRUE
	var/windowflashing = TRUE
	var/toggles = TOGGLES_DEFAULT
	var/db_flags
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null
	var/pda_style = MONO
	var/pda_color = "#808000"
	var/pda_skin = PDA_SKIN_ALT

	var/list/alt_titles_preferences = list()
	var/static/preview_job_outfit = TRUE	//shouldn't be something that's saved, but this is a preference option

	var/uses_glasses_colour = 0

	//character preferences
	var/real_name						//our character's name
	var/nameless = FALSE				//whether or not our character is nameless
	var/be_random_name = 0				//whether we'll have a random name every round
	var/be_random_body = 0				//whether we'll have a random body every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/underwear = "Nude"				//underwear type
	var/undie_color = "FFF"
	var/undershirt = "Nude"				//undershirt type
	var/shirt_color = "FFF"
	var/socks = "Nude"					//socks type
	var/socks_color = "FFF"
	var/backbag = DBACKPACK				//backpack type
	var/jumpsuit_style = PREF_SUIT		//suit/skirt
	var/hair_style = "Bald"				//Hair type
	var/hair_color = "000"				//Hair color
	var/facial_hair_style = "Shaved"	//Face hair type
	var/facial_hair_color = "000"		//Facial hair color
	var/skin_tone = "caucasian1"		//Skin color
	var/eye_color = "000"				//Eye color
	var/wing_color = "fff"				//Wing color

	var/grad_style						//Hair gradient style
	var/grad_color = "FFFFFF"			//Hair gradient color

	//HS13
	var/body_size = 100					//Body Size in percent
	var/can_get_preg = 0				//if they can get preggers

	//HS13 jobs
	var/sillyroles = FALSE //for clown and mime
	var/roleplayroles = FALSE //for the roleplay roles
	var/importantroles = FALSE //for things that define as important.


	var/datum/species/pref_species = new /datum/species/human()	//Mutant race
	var/list/features = list("mcolor" = "FFF",
		"tail_lizard" = "Smooth",
		"tail_human" = "None",
		"snout" = "Round",
		"horns" = "None",
		"ears" = "None",
		"wings" = "None",
		"frills" = "None",
		"deco_wings" = "None",
		"spines" = "None",
		"body_markings" = "None",
		"legs" = "Normal Legs",
		"moth_wings" = "Plain",
		"moth_fluff" = "None",
		"moth_markings" = "None",
		"mcolor2" = "FFF",
		"mcolor3" = "FFF",
		"mam_body_markings" = "Plain",
		"mam_ears" = "None",
		"mam_snouts" = "None",
		"mam_tail" = "None",
		"mam_tail_animated" = "None",
		"xenodorsal" = "Standard",
		"xenohead" = "Standard",
		"xenotail" = "Xenomorph Tail",
		"taur" = "None",
		"exhibitionist" = FALSE,
		"genitals_use_skintone" = FALSE,
		"has_cock" = FALSE,
		"cock_shape" = "Human",
		"cock_length" = 6,
		"belly_size" = 1,
		"butt_size" = 1,
		"cock_girth_ratio" = 0.25,
		"cock_color" = "fff",
		"has_sheath" = FALSE,
		"sheath_color" = "fff",
		"has_belly" = FALSE,
		"hide_belly" = FALSE,
		"inflatable_belly" = FALSE,
		"belly_color" = "fff",
		"has_anus" = FALSE,
		"butt_color" = "fff",
		"has_balls" = FALSE,
		"balls_internal" = FALSE,
		"balls_color" = "fff",
		"balls_amount" = 2,
		"balls_sack_size" = BALLS_SACK_SIZE_DEF,
		"balls_shape" = "Single",
		"balls_size" = BALLS_SIZE_DEF,
		"balls_cum_rate" = CUM_RATE,
		"balls_cum_mult" = CUM_RATE_MULT,
		"balls_efficiency" = CUM_EFFICIENCY,
		"balls_fluid" = /datum/reagent/consumable/semen,
		"has_ovi" = FALSE,
		"ovi_shape" = "knotted",
		"ovi_length" = 6,
		"ovi_color" = "fff",
		"has_eggsack" = FALSE,
		"eggsack_internal" = TRUE,
		"eggsack_color" = "fff",
		"eggsack_size" = BALLS_SACK_SIZE_DEF,
		"eggsack_egg_color" = "fff",
		"eggsack_egg_size" = EGG_GIRTH_DEF,
		"has_breasts" = FALSE,
		"breasts_color" = "fff",
		"breasts_size" = "C",
		"breasts_shape" = "Pair",
		"breasts_fluid" = /datum/reagent/consumable/milk,
		"breasts_producing" = FALSE,
		"has_vag" = FALSE,
		"vag_shape" = "Human",
		"vag_color" = "fff",
		"vag_clits" = 1,
		"vag_clit_diam" = 0.25,
		"has_womb" = FALSE,
		"can_get_preg" = FALSE,
		"womb_cum_rate" = CUM_RATE,
		"womb_cum_mult" = CUM_RATE_MULT,
		"womb_efficiency" = CUM_EFFICIENCY,
		"womb_fluid" = /datum/reagent/consumable/femcum,
		"ipc_screen" = "Sunburst",
		"ipc_antenna" = "None",
		"flavor_text" = "",
		"silicon_flavor_text" = "",
		"ooc_text" = "",
		"front_genitals_over_hair" = FALSE
		)

	/// Security record note section
	var/security_records
	/// Medical record note section
	var/medical_records

	var/custom_speech_verb = "default" //if your say_mod is to be something other than your races
	var/custom_tongue = "default" //if your tongue is to be something other than your races

	var/list/custom_names = list()
	var/preferred_ai_core_display = "Blue"
	var/prefered_security_department = SEC_DEPT_RANDOM
	var/custom_species = null

	var/list/all_quirks = list()
	var/compressed_quirks = FALSE	//Hyperstation edit: Use a smaller font for the quirks list
	var/old_view = FALSE			//Hyperstation edit: toggle for sorting by category

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

		// Want randomjob if preferences already filled - Donkie
	var/joblessrole = BERANDOMJOB  //defaults to 1 for fewer assistants

	// 0 = character settings, 1 = game preferences
	var/current_tab = 0

	var/unlock_content = 0
	var/vip = 0

	//visable pins!
	var/list/pins = list()

	var/list/ignoring = list()

	var/clientfps = 60


	var/parallax

	var/ambientocclusion = TRUE
	var/auto_fit_viewport = TRUE

	var/uplink_spawn_loc = UPLINK_PDA

	var/sprint_spacebar = FALSE
	var/sprint_toggle = FALSE

	var/list/exp = list()
	var/list/menuoptions

	var/action_buttons_screen_locs = list()

	//backgrounds
	var/mutable_appearance/character_background
	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "hiro", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

	var/show_mismatched_markings = FALSE //determines whether or not the markings lists should show markings that don't match the currently selected species. Intentionally left unsaved.
	var/hide_ckey = FALSE //pref for hiding if your ckey shows round-end or not

/datum/preferences/New(client/C)
	parent = C
	clientfps = world.fps*2
	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	UI_style = GLOB.available_ui_styles[1]
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			clientckey = C.ckey
			unlock_content = C.IsByondMember()
			if(unlock_content)
				max_save_slots = 16
			if(clientckey in GLOB.patreons)
				vip = 1
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return
	//we couldn't load character data so just randomize the character appearance + name
	random_character()		//let's create a random character then - rather than a fat, bald and naked man.
	real_name = pref_species.random_name(gender,1)
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	return

#define APPEARANCE_CATEGORY_COLUMN "<td valign='top' width='17%'>"
#define MAX_MUTANT_ROWS 4

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return
	update_preview_icon()
	var/list/dat = list("<center>")

	dat += "<a href='?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Character Settings</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>Character Appearance</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=3' [current_tab == 3 ? "class='linkOn'" : ""]>Loadout</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>Game Preferences</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=4' [current_tab == 4 ? "class='linkOn'" : ""]>Antagonist Preferences</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=5' [current_tab == 5 ? "class='linkOn'" : ""]>Content Preferences</a>"

	if(!path)
		dat += "<div class='notice'>Please create an account to save your preferences</div>"

//H13 make body size compatable with the current save.
	if (body_size == null)
		body_size = 100

	dat += "</center>"

	dat += "<HR>"

	if(path)	//Show list of characters
		var/savefile/S = new /savefile(path)
		if(S)
			dat += "<center>"
			var/name
			var/unspaced_slots = 0
			for(var/i=1, i<=max_save_slots, i++)
				unspaced_slots++
				if(unspaced_slots > 4)
					dat += "<br>"
					unspaced_slots = 0
				S.cd = "/character[i]"
				S["real_name"] >> name
				if(!name)
					name = "+"
				dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=changeslot;num=[i];' [i == default_slot ? "class='linkOn'" : ""]>[name]</a> "
			dat += "</center>"

	switch(current_tab)
		if (0) // Character Settings
			dat += "<center><h2>Occupation Choices</h2>"
			dat += "<a href='?_src_=prefs;preference=job;task=menu'>Set Occupation Preferences</a><br></center>"
			if(CONFIG_GET(flag/roundstart_traits))
				dat += "<center><h2>Quirk Setup</h2>"
				dat += "<a href='?_src_=prefs;preference=trait;task=menu'>Configure Quirks</a><br></center>"
				dat += "<center><b>Current Quirks:</b> [all_quirks.len ? all_quirks.Join(", ") : "None"]</center>"
			dat += "<h2>Identity</h2>"
			dat += "<table width='100%'><tr><td width='75%' valign='top'>"
			if(jobban_isbanned(user, "appearance"))
				dat += "<b>You are banned from using custom names and appearances. You can continue to adjust your characters, but you will be randomised once you join the game.</b><br>"
			dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=name;task=random'>Random Name</A> "
			dat += "<b>Always Random Name:</b><a style='display:block;width:30px' href='?_src_=prefs;preference=name'>[be_random_name ? "Yes" : "No"]</a><BR>"

			dat += "<b>[nameless ? "Default designation" : "Name"]:</b>"
			dat += "<a href='?_src_=prefs;preference=name;task=input'>[real_name]</a><BR>"
			dat += "<a href='?_src_=prefs;preference=nameless'>Be nameless: [nameless ? "Yes" : "No"]</a><BR>"

			dat += "<b>Gender:</b> <a href='?_src_=prefs;preference=gender'>[gender == MALE ? "Male" : (gender == FEMALE ? "Female" : (gender == PLURAL ? "Non-binary" : "Object"))]</a><BR>"
			dat += "<b>Age:</b> <a style='display:block;width:30px' href='?_src_=prefs;preference=age;task=input'>[age]</a><BR>"

			dat += "<b>Special Names:</b><BR>"
			var/old_group
			for(var/custom_name_id in GLOB.preferences_custom_names)
				var/namedata = GLOB.preferences_custom_names[custom_name_id]
				if(!old_group)
					old_group = namedata["group"]
				else if(old_group != namedata["group"])
					old_group = namedata["group"]
					dat += "<br>"
				dat += "<a href ='?_src_=prefs;preference=[custom_name_id];task=input'><b>[namedata["pref_name"]]:</b> [custom_names[custom_name_id]]</a> "
			dat += "<br><br>"

			dat += "<b>Custom job preferences:</b><BR>"
			dat += "<a href='?_src_=prefs;preference=ai_core_icon;task=input'><b>Preferred AI Core Display:</b> [preferred_ai_core_display]</a><br>"
			dat += "<a href='?_src_=prefs;preference=sec_dept;task=input'><b>Preferred Security Department:</b> [prefered_security_department]</a><BR></td>"
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
			dat += "<br><a href='?_src_=prefs;preference=hide_ckey;task=input'><b>Hide ckey: [hide_ckey ? "Enabled" : "Disabled"]</b></a><br>"
			dat += "</tr></table>"

		//Character Appearance
		if(2)
			update_preview_icon()
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>General Examine Text</h2>"
			dat += "<a href='?_src_=prefs;preference=flavor_text;task=input'><b>Set Examine Text</b></a><br>"
			if(length(features["flavor_text"]) <= 40)
				if(!length(features["flavor_text"]))
					dat += "\[...\]"
				else
					dat += "[features["flavor_text"]]"
			else
				dat += "[TextPreview(features["flavor_text"])]...<BR>"
			dat += "<h2>Silicon Flavor Text</h2>"
			dat += "<a href='?_src_=prefs;preference=silicon_flavor_text;task=input'><b>Set Silicon Examine Text</b></a><br>"
			if(length(features["silicon_flavor_text"]) <= 40)
				if(!length(features["silicon_flavor_text"]))
					dat += "\[...\]"
				else
					dat += "[features["silicon_flavor_text"]]"
			else
				dat += "[TextPreview(features["silicon_flavor_text"])]...<BR>"
			dat += "<h2>OOC Text</h2>"
			dat += "<a href='?_src_=prefs;preference=ooc_text;task=input'><b>Set OOC Text</b></a><br>"
			if(length(features["ooc_text"]) <= 40)
				if(!length(features["ooc_text"]))
					dat += "\[...\]"
				else
					dat += "[features["ooc_text"]]"
			else
				dat += "[TextPreview(features["ooc_text"])]...<BR>"

			dat += "<h2>Body</h2>"
			dat += "<b>Gender:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=gender'>[gender == MALE ? "Male" : (gender == FEMALE ? "Female" : (gender == PLURAL ? "Non-binary" : "Object"))]</a><BR>"
			dat += "<b>Species:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=species;task=input'>[pref_species.id]</a><BR>"
			dat += "<b>Custom Species Name:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=custom_species;task=input'>[custom_species ? custom_species : "None"]</a><BR>"
			dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=all;task=random'>Random Body</A><BR>"
			dat += "<b>Always Random Body:</b><a href='?_src_=prefs;preference=all'>[be_random_body ? "Yes" : "No"]</A><BR>"
			dat += "<br><b>Cycle background:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=cycle_bg;task=input'>[bgstate]</a><BR>"
			dat += "<b>Render front genitals over hair:</b><a href='?_src_=prefs;task=front_genitals_over_hair'>[features["front_genitals_over_hair"] ? "Yes" : "No"]</A><BR>"

			var/use_skintones = pref_species.use_skintones
			if(use_skintones)
				dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Skin Tone</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=s_tone;task=input'>[skin_tone]</a><BR>"

			var/mutant_colors
			if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))
				if(!use_skintones)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h2>Body</h2>"

				dat += "<b>Primary Color:</b><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color;task=input'>Change</a><BR>"

				dat += "<b>Secondary Color:</b><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor2"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color2;task=input'>Change</a><BR>"

				dat += "<b>Tertiary Color:</b><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor3"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color3;task=input'>Change</a><BR>"
				mutant_colors = TRUE

			//HS13 body size
			if (body_size > 0)
				dat += "<b>Sprite Size:</b> <a href='?_src_=prefs;preference=bodysize;task=input'>[body_size]%</a><br>"
			if (body_size == null)
				dat += "<b>Sprite Size:</b> <a href='?_src_=prefs;preference=bodysize;task=input'>[body_size]%</a><br>"
				mutant_colors = TRUE

			if((EYECOLOR in pref_species.species_traits) && !(NOEYES in pref_species.species_traits))

				if(!use_skintones && !mutant_colors)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Eye Color</h3>"

				dat += "<span style='border: 1px solid #161616; background-color: #[eye_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eyes;task=input'>Change</a><BR>"

				dat += "</td>"
			else if(use_skintones || mutant_colors)
				dat += "</td>"

			dat += APPEARANCE_CATEGORY_COLUMN
			dat += "<h2>Speech preferences</h2>"
			dat += "<b>Custom Speech Verb:</b><BR>"
			dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=speech_verb;task=input'>[custom_speech_verb]</a><BR>"
			dat += "<b>Custom Tongue:</b><BR>"
			dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=tongue;task=input'>[custom_tongue]</a><BR>"

			if(HAIR in pref_species.species_traits)

				dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Hair Style</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=hair_style;task=input'>[hair_style]</a>"
				dat += "<a href='?_src_=prefs;preference=previous_hair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_hair_style;task=input'>&gt;</a><BR>"
				dat += "<span style='border:1px solid #161616; background-color: #[hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=hair;task=input'>Change</a><BR>"

				dat += "<h3>Facial Hair Style</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=facial_hair_style;task=input'>[facial_hair_style]</a>"
				dat += "<a href='?_src_=prefs;preference=previous_facehair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_facehair_style;task=input'>&gt;</a><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[facial_hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=facial;task=input'>Change</a><BR>"


				dat += "<h3>Hair Gradient</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=grad_style;task=input'>[grad_style]</a>"
				dat += "<a href='?_src_=prefs;preference=previous_grad_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_grad_style;task=input'>&gt;</a><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[grad_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=grad_color;task=input'>Change</a><BR>"


				dat += "</td>"
			//Mutant stuff
			var/mutant_category = 0

			dat += APPEARANCE_CATEGORY_COLUMN
			dat += "<h3>Show mismatched markings</h3>"
			dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=mismatched_markings;task=input'>[show_mismatched_markings ? "Yes" : "No"]</a>"
			mutant_category++
			if(mutant_category >= MAX_MUTANT_ROWS) //just in case someone sets the max rows to 1 or something dumb like that
				dat += "</td>"
				mutant_category = 0


			if("tail_lizard" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Tail</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=tail_lizard;task=input'>[features["tail_lizard"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if("mam_tail" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Tail</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=mam_tail;task=input'>[features["mam_tail"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if("moth_markings" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Moth markings</h3>"

				dat += "<a href='?_src_=prefs;preference=moth_markings;task=input'>[features["moth_markings"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if("tail_human" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Tail</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=tail_human;task=input'>[features["tail_human"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("snout" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Snout</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=snout;task=input'>[features["snout"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("horns" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Horns</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=horns;task=input'>[features["horns"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
			if("frills" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Frills</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=frills;task=input'>[features["frills"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if("spines" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Spines</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=spines;task=input'>[features["spines"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if("body_markings" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Body Markings</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=body_markings;task=input'>[features["body_markings"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("mam_body_markings" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Species Markings</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=mam_body_markings;task=input'>[features["mam_body_markings"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"

			if("mam_ears" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Ears</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=mam_ears;task=input'>[features["mam_ears"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("ears" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Ears</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=ears;task=input'>[features["ears"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("mam_snouts" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Snout</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=mam_snouts;task=input'>[features["mam_snouts"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("legs" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Legs</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=legs;task=input'>[features["legs"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("deco_wings" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Decorative wings</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=deco_wings;task=input'>[features["deco_wings"]]</a>"
				dat += "<span style='border:1px solid #161616; background-color: #[wing_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=wings_color;task=input'>Change</a><BR>"
			if("moth_wings" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Moth wings</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=moth_wings;task=input'>[features["moth_wings"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("moth_fluff" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Moth Fluff</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=moth_fluffs;task=input'>[features["moth_fluff"]]</a>"
				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("taur" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Tauric Body</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=taur;task=input'>[features["taur"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("wings" in pref_species.mutant_bodyparts && GLOB.r_wings_list.len >1)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Wings</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=wings;task=input'>[features["wings"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("xenohead" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Caste Head</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=xenohead;task=input'>[features["xenohead"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("xenotail" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Tail</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=xenotail;task=input'>[features["xenotail"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("xenodorsal" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Dorsal Spines</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=xenodorsal;task=input'>[features["xenodorsal"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("ipc_screen" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Screen</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=ipc_screen;task=input'>[features["ipc_screen"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0
			if("ipc_antenna" in pref_species.default_features)
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Antenna</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=ipc_antenna;task=input'>[features["ipc_antenna"]]</a>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(mutant_category)
				dat += "</td>"
				mutant_category = 0

			dat += "</tr></table>"

			dat += "</td>"
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>Clothing & Equipment</h2>"
			dat += "<b>Underwear:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=underwear;task=input'>[underwear]</a>"
			if(UNDIE_COLORABLE(GLOB.underwear_list[underwear]))
				dat += "<b>Underwear Color:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=undie_color;task=input'>[undie_color]</a>"
			dat += "<b>Undershirt:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=undershirt;task=input'>[undershirt]</a>"
			if(UNDIE_COLORABLE(GLOB.undershirt_list[undershirt]))
				dat += "<b>Undershirt Color:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=shirt_color;task=input'>[shirt_color]</a>"
			dat += "<b>Socks:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=socks;task=input'>[socks]</a>"
			if(UNDIE_COLORABLE(GLOB.socks_list[socks]))
				dat += "<b>Socks Color:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=socks_color;task=input'>[socks_color]</a>"
			dat += "<b>Backpack:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=bag;task=input'>[backbag]</a>"
			dat += "<b>Jumpsuit:</b><BR><a href ='?_src_=prefs;preference=suit;task=input'>[jumpsuit_style]</a><BR>"
			dat += "<b>Uplink Location:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=uplink_loc;task=input'>[uplink_spawn_loc]</a>"
			dat += "</td>"

			dat +="<td width='220px' height='300px' valign='top'>"
			if(NOGENITALS in pref_species.species_traits)
				dat += "<b>Your species ([pref_species.name]) does not support genitals!</b><br>"
			else
				if(pref_species.use_skintones)
					dat += "<b>Genitals use skintone:</b><a href='?_src_=prefs;preference=genital_colour'>[features["genitals_use_skintone"] == TRUE ? "Yes" : "No"]</a>"
				dat += "<h3>Penis</h3>"
				dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_cock'>[features["has_cock"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_cock"])
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Penis Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)</a><br>"
					else
						dat += "<b>Penis Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["cock_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=cock_color;task=input'>Change</a><br>"
					dat += "<b>Penis Shape:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=cock_shape;task=input'>[features["cock_shape"]]</a>"
					dat += "<b>Penis Length:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=cock_length;task=input'>[features["cock_length"]] inch(es)</a>"
					dat += "<b>Girth Ratio:</b> <a style='display:block;width:50px' href='?_src_=prefs;preference=cock_girth_ratio;task=input'>[features["cock_girth_ratio"]]</a>"
					dat += "<b>Has Testicles:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=has_balls'>[features["has_balls"] == TRUE ? "Yes" : "No"]</a>"
					if(features["has_balls"])
						if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
							dat += "<b>Testicles Color:</b></a><BR>"
							dat += "<span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<br>"
						else
							dat += "<b>Testicles Color:</b></a><BR>"
							dat += "<span style='border: 1px solid #161616; background-color: #[features["balls_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=balls_color;task=input'>Change</a><br>"
						//dat += "<b>Ball Circumference:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=balls_size;task=input'>[features["balls_size"]] inch(es)</a>" // The menu works but doesn't do anything yet. Need to figure it out.
						dat += "<b>Testicles showing:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=balls_shape;task=input'>[features["balls_shape"]]</a>"
						dat += "<b>Produces:</b>"
						switch(features["balls_fluid"])
							if(/datum/reagent/consumable/milk)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=balls_fluid;task=input'>Milk</a>"
							if(/datum/reagent/water)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=balls_fluid;task=input'>Water</a>"
							if(/datum/reagent/consumable/semen)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=balls_fluid;task=input'>Semen</a>"
							if(/datum/reagent/consumable/femcum)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=balls_fluid;task=input'>Femcum</a>"
							if(/datum/reagent/consumable/alienhoney)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=balls_fluid;task=input'>Honey</a>"
							else
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=balls_fluid;task=input'>Nothing?</a>"
							//This else is a safeguard for errors, and if it happened, they wouldn't be able to change this pref,
							//DO NOT REMOVE IT UNLESS YOU HAVE A GOOD IDEA
				dat += APPEARANCE_CATEGORY_COLUMN
				dat += "<h3>Vagina</h3>"
				dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_vag'>[features["has_vag"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_vag"])
					dat += "<b>Vagina Type:</b> <a style='display:block;width:100px' href='?_src_=prefs;preference=vag_shape;task=input'>[features["vag_shape"]]</a>"
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Vagina Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<br>"
					else
						dat += "<b>Vagina Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["vag_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=vag_color;task=input'>Change</a><br>"
					dat += "<b>Has Womb:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=has_womb'>[features["has_womb"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_womb"])
					dat += "<b>Can Get Pregnant:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=can_get_preg'>[features["can_get_preg"] == TRUE ? "Yes" : "No"]</a>"
				dat += "</td>"
				dat += APPEARANCE_CATEGORY_COLUMN
				dat += "<h3>Breasts</h3>"
				dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_breasts'>[features["has_breasts"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_breasts"])
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<br>"
					else
						dat += "<b>Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["breasts_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=breasts_color;task=input'>Change</a><br>"
					dat += "<b>Cup Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_size;task=input'>[features["breasts_size"]]</a>"
					dat += "<b>Breast Shape:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_shape;task=input'>[features["breasts_shape"]]</a>"
					dat += "<b>Lactates:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_producing'>[features["breasts_producing"] == TRUE ? "Yes" : "No"]</a>"
					if(features["breasts_producing"] == TRUE)
						dat += "<b>Produces:</b>"
						switch(features["breasts_fluid"])
							if(/datum/reagent/consumable/milk)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_fluid;task=input'>Milk</a>"
							if(/datum/reagent/water)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_fluid;task=input'>Water</a>"
							if(/datum/reagent/consumable/semen)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_fluid;task=input'>Semen</a>"
							if(/datum/reagent/consumable/femcum)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_fluid;task=input'>Femcum</a>"
							if(/datum/reagent/consumable/alienhoney)
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_fluid;task=input'>Honey</a>"
							else
								dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_fluid;task=input'>Nothing?</a>"
							//This else is a safeguard for errors, and if it happened, they wouldn't be able to change this pref,
							//DO NOT REMOVE IT UNLESS YOU HAVE A GOOD IDEA
				dat += APPEARANCE_CATEGORY_COLUMN
				dat += "<h3>Belly</h3>"
				dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_belly'>[features["has_belly"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_belly"])
					dat += "<b>Belly Size:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=belly_size;task=input'>[features["belly_size"]]</a>"
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<br>"
					else
						dat += "<b>Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["belly_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=belly_color;task=input'>Change</a><br>"
					dat += "<b>Hide on Round-Start:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=hide_belly'>[features["hide_belly"] == 1 ? "Yes" : "No"]</a>"
					dat += "<b>Inflation (Climax With):</b><a style='display:block;width:50px' href='?_src_=prefs;preference=inflatable_belly'>[features["inflatable_belly"] == 1 ? "Yes" : "No"]</a>"

				dat += "</td>"

				dat += APPEARANCE_CATEGORY_COLUMN
				dat += "<h3>Butt</h3>"
				dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_anus'>[features["has_anus"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_anus"])
					dat += "<b>Butt Size:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=butt_size;task=input'>[features["butt_size"]]</a>"
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<br>"
					else
						dat += "<b>Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["butt_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=butt_color;task=input'>Change</a><br>"

				dat += "</td>"

			dat += "</td>"
			dat += "</tr></table>"

		if (1) // Game Preferences
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>General Settings</h2>"
			dat += "<b>UI Style:</b> <a href='?_src_=prefs;task=input;preference=ui'>[UI_style]</a><br>"
			dat += "<b>tgui Monitors:</b> <a href='?_src_=prefs;preference=tgui_lock'>[(tgui_lock) ? "Primary" : "All"]</a><br>"
			dat += "<b>tgui Style:</b> <a href='?_src_=prefs;preference=tgui_fancy'>[(tgui_fancy) ? "Fancy" : "No Frills"]</a><br>"
			dat += "<b>Chat Bubbles:</b> <a href='?_src_=prefs;preference=chat_on_map'>[chat_on_map ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>Chat Bubbles message char limit:</b> <a href='?_src_=prefs;preference=max_chat_length;task=input'>[max_chat_length]</a><br>"
			dat += "<b>Chat Bubbles for non-mobs:</b> <a href='?_src_=prefs;preference=see_chat_non_mob'>[see_chat_non_mob ? "Enabled" : "Disabled"]</a><br>"
			dat += "<br>"
			dat += "<b>Autocorrect:</b> <a href='?_src_=prefs;preference=autocorrect'>[(autocorrect) ? "On" : "Off"]</a><br>"
			dat += "<b>Radio Sounds:</b> <a href='?_src_=prefs;preference=radiosounds'>[radiosounds ? "Enabled" : "Disabled"]</a><br>"
			dat += "<br>"
			dat += "<b>Action Buttons:</b> <a href='?_src_=prefs;preference=action_buttons'>[(buttons_locked) ? "Locked In Place" : "Unlocked"]</a><br>"
			dat += "<b>Keybindings:</b> <a href='?_src_=prefs;preference=hotkeys'>[(hotkeys) ? "Hotkeys" : "Default"]</a><br>"
			dat += "<br>"
			dat += "<b>PDA Color:</b> <span style='border:1px solid #161616; background-color: [pda_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=pda_color;task=input'>Change</a><BR>"
			dat += "<b>PDA Style:</b> <a href='?_src_=prefs;task=input;preference=pda_style'>[pda_style]</a><br>"
			dat += "<b>PDA Reskin:</b> <a href='?_src_=prefs;task=input;preference=pda_skin'>[pda_skin]</a><br>"
			dat += "<br>"
			dat += "<b>Ghost Ears:</b> <a href='?_src_=prefs;preference=ghost_ears'>[(chat_toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost Radio:</b> <a href='?_src_=prefs;preference=ghost_radio'>[(chat_toggles & CHAT_GHOSTRADIO) ? "All Messages":"No Messages"]</a><br>"
			dat += "<b>Ghost Sight:</b> <a href='?_src_=prefs;preference=ghost_sight'>[(chat_toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost Whispers:</b> <a href='?_src_=prefs;preference=ghost_whispers'>[(chat_toggles & CHAT_GHOSTWHISPER) ? "All Speech" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost PDA:</b> <a href='?_src_=prefs;preference=ghost_pda'>[(chat_toggles & CHAT_GHOSTPDA) ? "All Messages" : "Nearest Creatures"]</a><br>"
			dat += "<b>Window Flashing:</b> <a href='?_src_=prefs;preference=winflash'>[(windowflashing) ? "Enabled":"Disabled"]</a><br>"
			dat += "<br>"
			dat += "<b>Play Admin MIDIs:</b> <a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "Enabled":"Disabled"]</a><br>"
			dat += "<b>Play Lobby Music:</b> <a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Enabled":"Disabled"]</a><br>"
			dat += "<b>See Pull Requests:</b> <a href='?_src_=prefs;preference=pull_requests'>[(chat_toggles & CHAT_PULLR) ? "Enabled":"Disabled"]</a><br>"
			dat += "<br>"
			if(user.client)
				if(unlock_content)
					dat += "<b>BYOND Membership Publicity:</b> <a href='?_src_=prefs;preference=publicity'>[(toggles & MEMBER_PUBLIC) ? "Public" : "Hidden"]</a><br>"
				if(unlock_content || check_rights_for(user.client, R_ADMIN))
					dat += "<b>OOC Color:</b> <span style='border: 1px solid #161616; background-color: [ooccolor ? ooccolor : GLOB.normal_ooc_colour];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=ooccolor;task=input'>Change</a><br>"
					dat += "<b>Antag OOC Color:</b> <span style='border: 1px solid #161616; background-color: [aooccolor ? aooccolor : GLOB.normal_aooc_colour];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=aooccolor;task=input'>Change</a><br>"

			dat += "</td>"
			if(user.client.holder)
				dat +="<td width='300px' height='300px' valign='top'>"
				dat += "<h2>Admin Settings</h2>"
				dat += "<b>Adminhelp Sounds:</b> <a href='?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"Enabled":"Disabled"]</a><br>"
				dat += "<b>Announce Login:</b> <a href='?_src_=prefs;preference=announce_login'>[(toggles & ANNOUNCE_LOGIN)?"Enabled":"Disabled"]</a><br>"
				dat += "<br>"
				dat += "<b>Combo HUD Lighting:</b> <a href = '?_src_=prefs;preference=combohud_lighting'>[(toggles & COMBOHUD_LIGHTING)?"Full-bright":"No Change"]</a><br>"
				dat += "</td>"

			dat +="<td width='300px' height='300px' valign='top'>"
			dat += "<h2>Citadel Preferences</h2>" //Because fuck me if preferences can't be fucking modularized and expected to update in a reasonable timeframe.
			dat += "<b>Widescreen:</b> <a href='?_src_=prefs;preference=widescreenpref'>[widescreenpref ? "Enabled ([CONFIG_GET(string/default_view)])" : "Disabled (15x15)"]</a><br>"
			dat += "<b>Auto stand:</b> <a href='?_src_=prefs;preference=autostand'>[autostand ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>Screen Shake:</b> <a href='?_src_=prefs;preference=screenshake'>[(screenshake==100) ? "Full" : ((screenshake==0) ? "None" : "[screenshake]")]</a><br>"
			if (user && user.client && !user.client.prefs.screenshake==0)
				dat += "<b>Damage Screen Shake:</b> <a href='?_src_=prefs;preference=damagescreenshake'>[(damagescreenshake==1) ? "On" : ((damagescreenshake==0) ? "Off" : "Only when down")]</a><br>"
			//Add the Hyper stuff below here
			dat += "<h2>Hyper Preferences</h2>"
			dat += "<b>NonCon - Bottom:</b><a href='?_src_=prefs;preference=noncon'>[noncon == TRUE ? "Enabled" : "Disabled"]</a><BR>"

			dat += "<h2>Hyper Special Roles</h2>"

			if(jobban_isbanned(user, ROLE_SYNDICATE))
				dat += "<font color=red><b>You are banned from antagonist roles.</b></font>"
				be_special = list()


			for (var/i in GLOB.hyper_special_roles)
				if(jobban_isbanned(user, i))
					dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;jobbancheck=[i]'>BANNED</a><br>"
				else
					var/days_remaining = null
					if(ispath(GLOB.hyper_special_roles[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
						var/mode_path = GLOB.hyper_special_roles[i]
						var/datum/game_mode/temp_mode = new mode_path
						days_remaining = temp_mode.get_remaining_days(user.client)

					if(days_remaining)
						dat += "<b>Be [capitalize(i)]:</b> <font color=red> \[IN [days_remaining] DAYS]</font><br>"
					else
						dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;preference=be_special;be_special_type=[i]'>[(i in be_special) ? "Enabled" : "Disabled"]</a><br>"
			dat += "<br>"
			dat += "</td>"
			dat += "</tr></table>"
			if(unlock_content)
				dat += "<b>Ghost Form:</b> <a href='?_src_=prefs;task=input;preference=ghostform'>[ghost_form]</a><br>"
				dat += "<B>Ghost Orbit: </B> <a href='?_src_=prefs;task=input;preference=ghostorbit'>[ghost_orbit]</a><br>"
			var/button_name = "If you see this something went wrong."
			switch(ghost_accs)
				if(GHOST_ACCS_FULL)
					button_name = GHOST_ACCS_FULL_NAME
				if(GHOST_ACCS_DIR)
					button_name = GHOST_ACCS_DIR_NAME
				if(GHOST_ACCS_NONE)
					button_name = GHOST_ACCS_NONE_NAME

			dat += "<b>Ghost Accessories:</b> <a href='?_src_=prefs;task=input;preference=ghostaccs'>[button_name]</a><br>"
			switch(ghost_others)
				if(GHOST_OTHERS_THEIR_SETTING)
					button_name = GHOST_OTHERS_THEIR_SETTING_NAME
				if(GHOST_OTHERS_DEFAULT_SPRITE)
					button_name = GHOST_OTHERS_DEFAULT_SPRITE_NAME
				if(GHOST_OTHERS_SIMPLE)
					button_name = GHOST_OTHERS_SIMPLE_NAME

			dat += "<b>Ghosts of Others:</b> <a href='?_src_=prefs;task=input;preference=ghostothers'>[button_name]</a><br>"
			dat += "<br>"
			dat += "<b>FPS:</b> <a href='?_src_=prefs;preference=clientfps;task=input'>[clientfps]</a><br>"
			dat += "<b>Parallax (Fancy Space):</b> <a href='?_src_=prefs;preference=parallaxdown' oncontextmenu='window.location.href=\"?_src_=prefs;preference=parallaxup\";return false;'>"
			switch (parallax)
				if (PARALLAX_LOW)
					dat += "Low"
				if (PARALLAX_MED)
					dat += "Medium"
				if (PARALLAX_INSANE)
					dat += "Insane"
				if (PARALLAX_DISABLE)
					dat += "Disabled"
				else
					dat += "High"
			dat += "</a><br>"
			dat += "<b>Ambient Occlusion:</b> <a href='?_src_=prefs;preference=ambientocclusion'>[ambientocclusion ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>Fit Viewport:</b> <a href='?_src_=prefs;preference=auto_fit_viewport'>[auto_fit_viewport ? "Auto" : "Manual"]</a><br>"
			dat += "<b>Sprint Key:</b> <a href='?_src_=prefs;preference=sprint_key'>[sprint_spacebar ? "Space" : "Shift"]</a><br>"
			dat += "<b>Toggle Sprint:</b> <a href='?_src_=prefs;preference=sprint_toggle'>[sprint_toggle ? "Enabled" : "Disabled"]</a><br>"

			if (CONFIG_GET(flag/maprotation) && CONFIG_GET(flag/tgstyle_maprotation))
				var/p_map = preferred_map
				if (!p_map)
					p_map = "Default"
					if (config.defaultmap)
						p_map += " ([config.defaultmap.map_name])"
				else
					if (p_map in config.maplist)
						var/datum/map_config/VM = config.maplist[p_map]
						if (!VM)
							p_map += " (No longer exists)"
						else
							p_map = VM.map_name
					else
						p_map += " (No longer exists)"
				if(CONFIG_GET(flag/allow_map_voting))
					dat += "<b>Preferred Map:</b> <a href='?_src_=prefs;preference=preferred_map;task=input'>[p_map]</a><br>"
			dat += "<br>"

		if(3)	//Item Loadout
			if(!gear_tab)
				gear_tab = GLOB.loadout_items[1]
			dat += "<table align='center' width='100%'>"
			dat += "<tr><td colspan=4><center><b><font color='[gear_points == 0 ? "#E62100" : "#CCDDFF"]'>[gear_points]</font> loadout points remaining.</b> \[<a href='?_src_=prefs;preference=gear;clear_loadout=1'>Clear Loadout</a>\] \[<a href='?_src_=prefs;preference=gear;toggle_outfit_visibility=1'>[preview_job_outfit ? "Enable" : "Disable"] Job Outfit Preview</a>\]</center></td></tr>"
			dat += "<tr><td colspan=4><center>You can only choose two items per category, unless it's an item that spawns in your backpack or hands.</center></td></tr>"
			dat += "<tr><td colspan=4><center><b>"
			var/firstcat = TRUE
			for(var/i in GLOB.loadout_items)
				if(firstcat)
					firstcat = FALSE
				else
					dat += " |"
				if(i == gear_tab)
					dat += " <span class='linkOn'>[i]</span> "
				else
					dat += " <a href='?_src_=prefs;preference=gear;select_category=[i]'>[i]</a> "
			dat += "</b></center></td></tr>"
			dat += "<tr><td colspan=4><hr></td></tr>"
			dat += "<tr><td colspan=4><b><center>[gear_tab]</center></b></td></tr>"
			dat += "<tr><td colspan=4><hr></td></tr>"
			dat += "<tr width=10% style='vertical-align:top;'><td width=15%><b>Name</b></td>"
			dat += "<td style='vertical-align:top'><b>Cost</b></td>"
			dat += "<td width=10%><font size=2><b>Restrictions</b></font></td>"
			dat += "<td width=80%><font size=2><b>Description</b></font></td></tr>"
			for(var/j in GLOB.loadout_items[gear_tab])
				var/datum/gear/gear = GLOB.loadout_items[gear_tab][j]
				var/donoritem
				if(gear.ckeywhitelist && gear.ckeywhitelist.len)
					donoritem = TRUE
					if(!(user.ckey in gear.ckeywhitelist))
						continue
				var/class_link = ""
				if(gear.type in chosen_gear)
					class_link = "style='white-space:normal;' class='linkOn' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(j)];toggle_gear=0'"
				else if(gear_points <= 0)
					class_link = "style='white-space:normal;' class='linkOff'"
				else if(donoritem)
					class_link = "style='white-space:normal;background:#ebc42e;' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(j)];toggle_gear=1'"
				else
					class_link = "style='white-space:normal;' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(j)];toggle_gear=1'"
				dat += "<tr style='vertical-align:top;'><td width=15%><a [class_link]>[j]</a></td>"
				dat += "<td width = 5% style='vertical-align:top'>[gear.cost]</td><td>"
				if(islist(gear.restricted_roles))
					if(gear.restricted_roles.len)
						if(gear.restricted_desc)
							dat += "<font size=2>"
							dat += gear.restricted_desc
							dat += "</font>"
						else
							dat += "<font size=2>"
							dat += gear.restricted_roles.Join(";")
							dat += "</font>"
				dat += "</td><td><font size=2><i>[gear.description]</i></font></td></tr>"
			dat += "</table>"

		if(4)	//Antag Preferences
			dat += "<h1>Special Role Settings</h1>"
			if(jobban_isbanned(user, ROLE_SYNDICATE))
				dat += "<font color=red><h3><b>You are banned from antagonist roles.</b></h3></font>"
				be_special = list()

			for (var/i in GLOB.special_roles)
				if(jobban_isbanned(user, i))
					dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;jobbancheck=[i]'>BANNED</a><br>"
				else
					var/days_remaining = null
					if(ispath(GLOB.special_roles[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
						var/mode_path = GLOB.special_roles[i]
						var/datum/game_mode/temp_mode = new mode_path
						days_remaining = temp_mode.get_remaining_days(user.client)

					if(days_remaining)
						dat += "<b>Be [capitalize(i)]:</b> <font color=red> \[IN [days_remaining] DAYS]</font><br>"
					else
						dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;preference=be_special;be_special_type=[i]'>[(i in be_special) ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>Midround Antagonist:</b> <a href='?_src_=prefs;preference=allow_midround_antag'>[(toggles & MIDROUND_ANTAG) ? "Enabled" : "Disabled"]</a><br>"

		if(5) //Content Preferences
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>Fetish content prefs</h2>"
			dat += "<b>Arousal:</b><a href='?_src_=prefs;preference=arousable'>[arousable == TRUE ? "Enabled" : "Disabled"]</a><BR>"
			dat += "<b>Exhibitionist:</b><a href='?_src_=prefs;preference=exhibitionist'>[features["exhibitionist"] == TRUE ? "Yes" : "No"]</a><BR>"
			dat += "<b>Genital examine text</b>:<a href='?_src_=prefs;preference=genital_examine'>[(cit_toggles & GENITAL_EXAMINE) ? "Enabled" : "Disabled"]</a><BR>"
			dat += "<b>Vore examine text</b>:<a href='?_src_=prefs;preference=vore_examine'>[(cit_toggles & VORE_EXAMINE) ? "Enabled" : "Disabled"]</a><BR>"
			dat += "<b>Voracious MediHound sleepers:</b> <a href='?_src_=prefs;preference=hound_sleeper'>[(cit_toggles & MEDIHOUND_SLEEPER) ? "Yes" : "No"]</a><br>"
			dat += "<b>Hear Vore Sounds:</b> <a href='?_src_=prefs;preference=toggleeatingnoise'>[(cit_toggles & EATING_NOISES) ? "Yes" : "No"]</a><br>"
			dat += "<b>Hear Vore Digestion Sounds:</b> <a href='?_src_=prefs;preference=toggledigestionnoise'>[(cit_toggles & DIGESTION_NOISES) ? "Yes" : "No"]</a><br>"
			dat += "<b>Allow trash forcefeeding (requires Trashcan quirk)</b> <a href='?_src_=prefs;preference=toggleforcefeedtrash'>[(cit_toggles & TRASH_FORCEFEED) ? "Yes" : "No"]</a><br>"
			dat += "<b>Forced Feminization:</b> <a href='?_src_=prefs;preference=feminization'>[(cit_toggles & FORCED_FEM) ? "Allowed" : "Disallowed"]</a><br>"
			dat += "<b>Forced Masculinization:</b> <a href='?_src_=prefs;preference=masculinization'>[(cit_toggles & FORCED_MASC) ? "Allowed" : "Disallowed"]</a><br>"
			dat += "<b>Lewd Hypno:</b> <a href='?_src_=prefs;preference=hypno'>[(cit_toggles & HYPNO) ? "Allowed" : "Disallowed"]</a><br>"
			dat += "</td>"
			dat +="<td width='300px' height='300px' valign='top'>"
			dat += "<h2>Other content prefs</h2>"
			dat += "<b>Breast Enlargement:</b> <a href='?_src_=prefs;preference=breast_enlargement'>[(cit_toggles & BREAST_ENLARGEMENT) ? "Allowed" : "Disallowed"]</a><br>"
			dat += "<b>Penis Enlargement:</b> <a href='?_src_=prefs;preference=penis_enlargement'>[(cit_toggles & PENIS_ENLARGEMENT) ? "Allowed" : "Disallowed"]</a><br>"
			dat += "<b>Ass Enlargement:</b> <a href='?_src_=prefs;preference=ass_enlargement'>[(cit_toggles & ASS_ENLARGEMENT) ? "Allowed" : "Disallowed"]</a><br>"
			dat += "<b>Hypno:</b> <a href='?_src_=prefs;preference=never_hypno'>[(cit_toggles & NEVER_HYPNO) ? "Disallowed" : "Allowed"]</a><br>"
			dat += "<b>Aphrodisiacs:</b> <a href='?_src_=prefs;preference=aphro'>[(cit_toggles & NO_APHRO) ? "Disallowed" : "Allowed"]</a><br>"
			dat += "<b>Ass Slapping:</b> <a href='?_src_=prefs;preference=ass_slap'>[(cit_toggles & NO_ASS_SLAP) ? "Disallowed" : "Allowed"]</a><br>"
			dat += "<b>Automatic Wagging:</b> <a href='?_src_=prefs;preference=auto_wag'>[(cit_toggles & NO_AUTO_WAG) ? "Disallowed" : "Allowed"]</a><br>"
			dat += "<b>Forced UwUspeak:</b> <a href='?_src_=prefs;preference=no_uwu'>[(cit_toggles & NO_UWU) ? "Disallowed" : "Allowed"]</a><br>"
			dat += "</tr></table>"
			dat += "<br>"

	dat += "<hr><center>"

	if(!IsGuestKey(user.key))
		dat += "<a href='?_src_=prefs;preference=load'>Undo</a> "
		dat += "<a href='?_src_=prefs;preference=save'>Save Setup</a> "

	dat += "<a href='?_src_=prefs;preference=reset_all'>Reset Setup</a>"
	dat += "</center>"

	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "<div align='center'>Character Setup</div>", 640, 770)
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(user, "preferences_window", src)

#undef APPEARANCE_CATEGORY_COLUMN
#undef MAX_MUTANT_ROWS

/datum/preferences/proc/SetChoices(mob/user, limit = 22, list/splitJobs = list("Chief Engineer"), widthPerColumn = 295, height = 620)
	if(!SSjob)
		return

	//limit - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//widthPerColumn - Screen's width for every column.
	//height - Screen's height.

	var/width = widthPerColumn

	var/HTML = "<center>"
	if(SSjob.occupations.len <= 0)
		HTML += "The job SSticker is not yet finished creating jobs, please try again later"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.

	else
		HTML += "<b>Choose occupation chances</b><br>"
		HTML += "<div align='center'>Left-click to raise an occupation preference, right-click to lower it.<br></div>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob

		var/datum/job/overflow = SSjob.GetJob(SSjob.overflow_role)

		for(var/datum/job/job in SSjob.occupations)

			index += 1
			if((index >= limit) || (job.title in splitJobs))
				width += widthPerColumn
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			HTML += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
			var/rank = job.title
			var/displayed_rank = rank
			if(job.alt_titles.len && (rank in alt_titles_preferences))
				displayed_rank = alt_titles_preferences[rank]
			lastJob = job
			if(jobban_isbanned(user, rank))
				HTML += "<font color=red>[rank]</font></td><td><a href='?_src_=prefs;jobbancheck=[rank]'> BANNED</a></td></tr>"
				continue
			if((rank in GLOB.silly_positions) && (!sillyroles))
				HTML += "<font color=red>[rank]</font></td><td><a href='?_src_=prefs;jobbancheck=[rank]'> WHITELIST</a></td></tr>"
				continue
			var/required_playtime_remaining = job.required_playtime_remaining(user.client)
			if(required_playtime_remaining)
				HTML += "<font color=red>[rank]</font></td><td><font color=red> \[ [get_exp_format(required_playtime_remaining)] as [job.get_exp_req_type()] \] </font></td></tr>"
				continue
			if(!job.player_old_enough(user.client))
				var/available_in_days = job.available_in_days(user.client)
				HTML += "<font color=red>[rank]</font></td><td><font color=red> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
				continue
			if((job_civilian_low & overflow.flag) && (rank != SSjob.overflow_role) && !jobban_isbanned(user, SSjob.overflow_role))
				HTML += "<font color=orange>[rank]</font></td><td></td></tr>"
				continue
			var/rank_title_line = "[displayed_rank]"
			if((rank in GLOB.command_positions) || (rank == "AI"))//Bold head jobs
				rank_title_line = "<b>[rank_title_line]</b>"
			if(job.alt_titles.len)
				rank_title_line = "<a href='?_src_=prefs;preference=job;task=alt_title;job_title=[job.title]'>[rank_title_line]</a>"
			else
				rank_title_line = "<span class='dark'>[rank_title_line]</span>" //Make it dark if we're not adding a button for alt titles
			HTML += rank_title_line

			HTML += "</td><td width='40%'>"

			var/prefLevelLabel = "ERROR"
			var/prefLevelColor = "pink"
			var/prefUpperLevel = -1 // level to assign on left click
			var/prefLowerLevel = -1 // level to assign on right click

			if(GetJobDepartment(job, 1) & job.flag)
				prefLevelLabel = "High"
				prefLevelColor = "slateblue"
				prefUpperLevel = 4
				prefLowerLevel = 2
			else if(GetJobDepartment(job, 2) & job.flag)
				prefLevelLabel = "Medium"
				prefLevelColor = "green"
				prefUpperLevel = 1
				prefLowerLevel = 3
			else if(GetJobDepartment(job, 3) & job.flag)
				prefLevelLabel = "Low"
				prefLevelColor = "orange"
				prefUpperLevel = 2
				prefLowerLevel = 4
			else
				prefLevelLabel = "NEVER"
				prefLevelColor = "red"
				prefUpperLevel = 3
				prefLowerLevel = 1


			HTML += "<a class='white' href='?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

			if(rank == SSjob.overflow_role)//Overflow is special
				if(job_civilian_low & overflow.flag)
					HTML += "<font color=green>Yes</font>"
				else
					HTML += "<font color=red>No</font>"
				HTML += "</a></td></tr>"
				continue

			HTML += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
			HTML += "</a></td></tr>"

		for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
			HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"

		HTML += "</td'></tr></table>"
		HTML += "</center></table>"

		var/message = "Be an [SSjob.overflow_role] if preferences unavailable"
		if(joblessrole == BERANDOMJOB)
			message = "Get random job if preferences unavailable"
		else if(joblessrole == RETURNTOLOBBY)
			message = "Return to lobby if preferences unavailable"
		HTML += "<center><br><a href='?_src_=prefs;preference=job;task=random'>[message]</a></center>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Reset Preferences</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Occupation Preferences</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(FALSE)

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return 0

	if (level == 1) // to high
		// remove any other job(s) set to high
		job_civilian_med |= job_civilian_high
		job_engsec_med |= job_engsec_high
		job_medsci_med |= job_medsci_high
		job_civilian_high = 0
		job_engsec_high = 0
		job_medsci_high = 0

	if (job.department_flag == CIVILIAN)
		job_civilian_low &= ~job.flag
		job_civilian_med &= ~job.flag
		job_civilian_high &= ~job.flag

		switch(level)
			if (1)
				job_civilian_high |= job.flag
			if (2)
				job_civilian_med |= job.flag
			if (3)
				job_civilian_low |= job.flag

		return 1
	else if (job.department_flag == ENGSEC)
		job_engsec_low &= ~job.flag
		job_engsec_med &= ~job.flag
		job_engsec_high &= ~job.flag

		switch(level)
			if (1)
				job_engsec_high |= job.flag
			if (2)
				job_engsec_med |= job.flag
			if (3)
				job_engsec_low |= job.flag

		return 1
	else if (job.department_flag == MEDSCI)
		job_medsci_low &= ~job.flag
		job_medsci_med &= ~job.flag
		job_medsci_high &= ~job.flag

		switch(level)
			if (1)
				job_medsci_high |= job.flag
			if (2)
				job_medsci_med |= job.flag
			if (3)
				job_medsci_low |= job.flag

		return 1

	return 0

/datum/preferences/proc/UpdateJobPreference(mob/user, role, desiredLvl)
	if(!SSjob || SSjob.occupations.len <= 0)
		return
	var/datum/job/job = SSjob.GetJob(role)

	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if (!isnum(desiredLvl))
		to_chat(user, "<span class='danger'>UpdateJobPreference - desired level was not a number. Please notify coders!</span>")
		ShowChoices(user)
		return

	if(role == SSjob.overflow_role)
		if(job_civilian_low & job.flag)
			job_civilian_low &= ~job.flag
		else
			job_civilian_low |= job.flag
		SetChoices(user)
		return 1

	SetJobPreferenceLevel(job, desiredLvl)
	SetChoices(user)

	return 1


/datum/preferences/proc/ResetJobs()

	job_civilian_high = 0
	job_civilian_med = 0
	job_civilian_low = 0

	job_medsci_high = 0
	job_medsci_med = 0
	job_medsci_low = 0

	job_engsec_high = 0
	job_engsec_med = 0
	job_engsec_low = 0


/datum/preferences/proc/GetJobDepartment(datum/job/job, level)
	if(!job || !level)
		return 0
	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(1)
					return job_civilian_high
				if(2)
					return job_civilian_med
				if(3)
					return job_civilian_low
		if(MEDSCI)
			switch(level)
				if(1)
					return job_medsci_high
				if(2)
					return job_medsci_med
				if(3)
					return job_medsci_low
		if(ENGSEC)
			switch(level)
				if(1)
					return job_engsec_high
				if(2)
					return job_engsec_med
				if(3)
					return job_engsec_low
	return 0

/datum/preferences/proc/SetQuirks(mob/user)
	if(!SSquirks)
		to_chat(user, "<span class='danger'>The quirk subsystem is still initializing! Try again in a minute.</span>")
		return

	var/dat = ""
	if(!SSquirks.quirks.len)
		dat += "The quirk subsystem hasn't finished initializing, please hold..."
		dat += "<center><a href='?_src_=prefs;preference=trait;task=close'>Done</a></center><br>"

	else
		dat += "<center><b>Choose quirk setup</b></center><br>"
		dat += "<div align='center'>Left-click to add or remove quirks. You need negative quirks to have positive ones.<br>\
		Quirks are applied at roundstart and cannot normally be removed.</div>"
		dat += "<center><a href='?_src_=prefs;preference=trait;task=close'>Done</a><br>\
			<a href='?_src_=prefs;preference=trait;task=trait_small_text'>[compressed_quirks ? "Normal View" : "Small View"]</a>  \
			<a href='?_src_=prefs;preference=trait;task=old_view'>[old_view ? "Current View" : "Old View"]</a> </center>" //Hyper edit
		dat += "<hr>"
		dat += "<center><b>Current quirks:</b> [all_quirks.len ? all_quirks.Join(", ") : "None"]</center>"
		dat += "<center>[GetPositiveQuirkCount()] / [MAX_QUIRKS] max positive quirks<br>\
		<b>Quirk balance remaining:</b> [GetQuirkBalance()]</center><br>"
		var/list/hacky = SSquirks.quirk_categories
		if(old_view)
			hacky = list(1)	//Hyperstation edit; super hacky, but it works

				//Hyperstation Edit: Categorize quirks
		for(var/_cat in hacky)
			var/list/L = SSquirks.quirks_sorted[_cat]
			if(!old_view)
				if(compressed_quirks)
					dat += "<p style='color:white;margin-bottom:1px;margin-top:6px'><u>[_cat]</u></p>"
				else
					dat += "<p style='color:white;font-size:12px;margin-bottom:2px;margin-top:4px'><u>[_cat]</u></p>"
			else
				L = SSquirks.quirks

			for(var/T in L)
				//End Hyperstation Edit
				var/datum/quirk/Q = SSquirks.quirks[T]
				var/quirk_name = initial(Q.name)
				var/has_quirk
				var/quirk_cost = initial(Q.value) * -1
				var/lock_reason = "This trait is unavailable."
				var/quirk_conflict = FALSE
				for(var/_V in all_quirks)
					if(_V == quirk_name)
						has_quirk = TRUE
						break
				if(initial(Q.mood_quirk) && CONFIG_GET(flag/disable_human_mood))
					lock_reason = "Mood is disabled."
					quirk_conflict = TRUE
				if(has_quirk)
					if(quirk_conflict)
						all_quirks -= quirk_name
						has_quirk = FALSE
					else
						quirk_cost *= -1 //invert it back, since we'd be regaining this amount
				if(quirk_cost > 0)
					quirk_cost = "+[quirk_cost]"
				var/font_color = "#AAAAFF"
				if(initial(Q.value) != 0)
					font_color = initial(Q.value) > 0 ? "#AAFFAA" : "#FFAAAA"

				if(compressed_quirks)	//Hyperstation Edit: smol text
					if(quirk_conflict)
						dat += "<a><font size='1' color='red'>([quirk_cost]) [quirk_name])</font></a>"
					else
						dat += "[has_quirk ? "<b><u>" : ""]<a href='?_src_=prefs;preference=trait;task=update;trait=[quirk_name]'><font size='1' color='[font_color]'>([quirk_cost]) [quirk_name]</font></a>[has_quirk ? "</u></b>" : ""]"
				else //if(old_view)
					if(quirk_conflict)
						dat += "<font color='[font_color]'>[quirk_name]</font> - \
						<font color='red'><b>LOCKED: [lock_reason]</b></font>"
					else
						dat += "<a href='?_src_=prefs;preference=trait;task=update;trait=[quirk_name]'>[has_quirk ? "Remove" : "Take"] ([quirk_cost] pts.)</a> \
						[has_quirk ? "<b>" : ""]<font color='[font_color]'>[quirk_name]</font>[has_quirk ? "</b>": ""] - [initial(Q.desc)]"
					dat += "<br>"

			dat += "<br>"

		dat += "<br><center><a href='?_src_=prefs;preference=trait;task=reset'>Reset Quirks</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Quirk Preferences</div>", 900, 600) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat)
	popup.open(FALSE)

/datum/preferences/proc/GetQuirkBalance()
	var/bal = 0
	for(var/V in all_quirks)
		var/datum/quirk/T = SSquirks.quirks[V]
		bal -= initial(T.value)
	return bal

/datum/preferences/proc/GetPositiveQuirkCount()
	. = 0
	for(var/q in all_quirks)
		if(SSquirks.quirk_points[q] > 0)
			.++

/datum/preferences/Topic(href, href_list, hsrc)			//yeah, gotta do this I guess..
	. = ..()
	if(href_list["close"])
		var/client/C = usr.client
		if(C)
			C.clear_character_previews()

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["jobbancheck"])
		var/job = sanitizeSQL(href_list["jobbancheck"])
		var/sql_ckey = sanitizeSQL(user.ckey)
		var/datum/DBQuery/query_get_jobban = SSdbcore.NewQuery("SELECT reason, bantime, duration, expiration_time, IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey) FROM [format_table_name("ban")] WHERE ckey = '[sql_ckey]' AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned) AND job = '[job]'")
		if(!query_get_jobban.warn_execute())
			qdel(query_get_jobban)
			return
		if(query_get_jobban.NextRow())
			var/reason = query_get_jobban.item[1]
			var/bantime = query_get_jobban.item[2]
			var/duration = query_get_jobban.item[3]
			var/expiration_time = query_get_jobban.item[4]
			var/admin_key = query_get_jobban.item[5]
			var/text
			text = "<span class='redtext'>You, or another user of this computer, ([user.key]) is banned from playing [job]. The ban reason is:<br>[reason]<br>This ban was applied by [admin_key] on [bantime]"
			if(text2num(duration) > 0)
				text += ". The ban is for [duration] minutes and expires on [expiration_time] (server time)"
			text += ".</span>"
			to_chat(user, text)
		qdel(query_get_jobban)
		return

	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						if(jobban_isbanned(user, SSjob.overflow_role))
							joblessrole = BERANDOMJOB
						else
							joblessrole = BEOVERFLOW
					if(BEOVERFLOW)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				SetChoices(user)
			if("setJobLevel")
				UpdateJobPreference(user, href_list["text"], text2num(href_list["level"]))
			if("alt_title")
				var/job_title = href_list["job_title"]
				var/titles_list = list(job_title)
				var/datum/job/J = SSjob.GetJob(job_title)
				for(var/i in J.alt_titles)
					titles_list += i
				var/chosen_title
				chosen_title = input(user, "Choose your job's title:", "Job Preference") as null|anything in titles_list
				if(chosen_title)
					if(chosen_title == job_title)
						if(alt_titles_preferences[job_title])
							alt_titles_preferences.Remove(job_title)
					else
						alt_titles_preferences[job_title] = chosen_title
				SetChoices(user)
			else
				SetChoices(user)
		return 1

	else if(href_list["preference"] == "trait")
		switch(href_list["task"])
			if("trait_small_text")
				compressed_quirks = !compressed_quirks
				SetQuirks(user)
			if("old_view")
				old_view = !old_view
				SetQuirks(user)
			if("close")
				user << browse(null, "window=mob_occupation")
				compressed_quirks = FALSE
				//Intentional for old_view to not be reset here. But we don't save the varx
				ShowChoices(user)
			if("update")
				var/quirk = href_list["trait"]
				if(!SSquirks.quirks[quirk])
					return
				for(var/V in SSquirks.quirk_blacklist) //V is a list
					var/list/L = V
					for(var/Q in all_quirks)
						if((quirk in L) && (Q in L) && !(Q == quirk)) //two quirks have lined up in the list of the list of quirks that conflict with each other, so return (see quirks.dm for more details)
							to_chat(user, "<span class='danger'>[quirk] is incompatible with [Q].</span>")
							return
				var/value = SSquirks.quirk_points[quirk]
				var/balance = GetQuirkBalance()
				if(quirk in all_quirks)
					if(balance + value < 0)
						to_chat(user, "<span class='warning'>Refunding this would cause you to go below your balance!</span>")
						return
					all_quirks -= quirk
				else
					if(GetPositiveQuirkCount() >= MAX_QUIRKS)
						to_chat(user, "<span class='warning'>You can't have more than [MAX_QUIRKS] positive quirks!</span>")
						return
					if(balance - value < 0)
						to_chat(user, "<span class='warning'>You don't have enough balance to gain this quirk!</span>")
						return
					all_quirks += quirk
				SetQuirks(user)
			if("reset")
				all_quirks = list()
				SetQuirks(user)
			else
				SetQuirks(user)
		return TRUE

	switch(href_list["task"])
		if("front_genitals_over_hair")
			features["front_genitals_over_hair"] = !features["front_genitals_over_hair"]
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					hair_color = random_short_color()
				if("hair_style")
					hair_style = random_hair_style(gender)
				if("facial")
					facial_hair_color = random_short_color()
				if("facial_hair_style")
					facial_hair_style = random_facial_hair_style(gender)
				if("underwear")
					underwear = random_underwear(gender)
					undie_color = random_short_color()
				if("undershirt")
					undershirt = random_undershirt(gender)
					shirt_color = random_short_color()
				if("socks")
					socks = random_socks()
					socks_color = random_short_color()
				if(BODY_ZONE_PRECISE_EYES)
					eye_color = random_eye_color()
				if("s_tone")
					skin_tone = random_skin_tone()
				if("bag")
					backbag = pick(GLOB.backbaglist)
				if("suit")
					jumpsuit_style = pick(GLOB.jumpsuitlist)
				if("all")
					random_character()

		if("input")

			if(href_list["preference"] in GLOB.preferences_custom_names)
				ask_for_custom_name(user,href_list["preference"])


			switch(href_list["preference"])
				if("ghostform")
					if(unlock_content)
						var/new_form = input(user, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND",null) as null|anything in GLOB.ghost_forms
						if(new_form)
							ghost_form = new_form
				if("ghostorbit")
					if(unlock_content)
						var/new_orbit = input(user, "Thanks for supporting BYOND - Choose your ghostly orbit:","Thanks for supporting BYOND", null) as null|anything in GLOB.ghost_orbits
						if(new_orbit)
							ghost_orbit = new_orbit

				if("ghostaccs")
					var/new_ghost_accs = alert("Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,GHOST_ACCS_FULL_NAME, GHOST_ACCS_DIR_NAME, GHOST_ACCS_NONE_NAME)
					switch(new_ghost_accs)
						if(GHOST_ACCS_FULL_NAME)
							ghost_accs = GHOST_ACCS_FULL
						if(GHOST_ACCS_DIR_NAME)
							ghost_accs = GHOST_ACCS_DIR
						if(GHOST_ACCS_NONE_NAME)
							ghost_accs = GHOST_ACCS_NONE

				if("ghostothers")
					var/new_ghost_others = alert("Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,GHOST_OTHERS_THEIR_SETTING_NAME, GHOST_OTHERS_DEFAULT_SPRITE_NAME, GHOST_OTHERS_SIMPLE_NAME)
					switch(new_ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING_NAME)
							ghost_others = GHOST_OTHERS_THEIR_SETTING
						if(GHOST_OTHERS_DEFAULT_SPRITE_NAME)
							ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
						if(GHOST_OTHERS_SIMPLE_NAME)
							ghost_others = GHOST_OTHERS_SIMPLE

				if("name")
					var/new_name = input(user, "Choose your character's name:", "Character Preference")  as text|null
					if(new_name)
						new_name = reject_bad_name(new_name, TRUE)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("security_records")
					var/rec = stripped_multiline_input(usr, "Set your security record note section. This should be IC!", "Security Records", html_decode(security_records), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(rec))
						security_records = rec

				if("medical_records")
					var/rec = stripped_multiline_input(usr, "Set your medical record note section. This should be IC!", "Security Records", html_decode(medical_records), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(rec))
						medical_records = rec

				if("flavor_text")
					var/msg = stripped_multiline_input(usr, "Set the flavor text in your 'examine' verb. This should be IC, and description people can deduce at a quick glance.", "Flavor Text", html_decode(features["flavor_text"]), MAX_MESSAGE_LEN, TRUE)
					if(msg)
						msg = msg
						features["flavor_text"] = msg

				if("silicon_flavor_text")
					var/msg = stripped_multiline_input(usr, "Set the silicon flavor text in your 'examine' verb. This can also be used for OOC notes and preferences!", "Silicon Flavor Text", features["silicon_flavor_text"], MAX_FLAVOR_LEN, TRUE)
					if(msg)
						msg = msg
						features["silicon_flavor_text"] = msg

				if("ooc_text")
					var/msg = stripped_multiline_input(usr, "Set the OOC text in your 'examine' verb. This should be OOC only!", "OOC Text", html_decode(features["ooc_text"]), MAX_MESSAGE_LEN, TRUE)
					if(msg)
						msg = msg
						features["ooc_text"] = msg


				if("hide_ckey")
					hide_ckey = !hide_ckey
					if(user)
						user.mind?.hide_ckey = hide_ckey

				if("hair")
					var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference","#"+hair_color) as color|null
					if(new_hair)
						hair_color = sanitize_hexcolor(new_hair)

				if("hair_style")
					var/new_hair_style
					new_hair_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in GLOB.hair_styles_list
					if(new_hair_style)
						hair_style = new_hair_style
						if(new_hair_style == "Tail Hair" && clientckey <> "quotefox")
							hair_style = "Bald"


				if("next_hair_style")
					hair_style = next_list_item(hair_style, GLOB.hair_styles_list)
					if(hair_style == "Tail Hair" && clientckey <> "quotefox")
						hair_style = "Bald"

				if("previous_hair_style")
					hair_style = previous_list_item(hair_style, GLOB.hair_styles_list)
					if(hair_style == "Tail Hair" && clientckey <> "quotefox")
						hair_style = "Bald"

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference","#"+facial_hair_color) as color|null
					if(new_facial)
						facial_hair_color = sanitize_hexcolor(new_facial)

				if("facial_hair_style")
					var/new_facial_hair_style
					new_facial_hair_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in GLOB.facial_hair_styles_list
					if(new_facial_hair_style)
						facial_hair_style = new_facial_hair_style

				if("next_facehair_style")
					facial_hair_style = next_list_item(facial_hair_style, GLOB.facial_hair_styles_list)

				if("previous_facehair_style")
					facial_hair_style = previous_list_item(facial_hair_style, GLOB.facial_hair_styles_list)

				if("grad_color")
					var/new_grad_color = input(user, "Choose your character's gradient colour:", "Character Preference","#"+grad_color) as color|null
					if(new_grad_color)
						grad_color = sanitize_hexcolor(new_grad_color, 6)

				if("grad_style")
					var/new_grad_style
					new_grad_style = input(user, "Choose your character's hair gradient style:", "Character Preference") as null|anything in GLOB.hair_gradients_list
					if(new_grad_style)
						grad_style = new_grad_style

				if("next_grad_style")
					grad_style = next_list_item(grad_style, GLOB.hair_gradients_list)

				if("previous_grad_style")
					grad_style = previous_list_item(grad_style, GLOB.hair_gradients_list)


				if("cycle_bg")
					bgstate = next_list_item(bgstate, bgstate_options)

				if("underwear")
					var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in GLOB.underwear_list
					if(new_underwear)
						underwear = new_underwear

				if("undie_color")
					var/n_undie_color = input(user, "Choose your underwear's color.", "Character Preference", undie_color) as color|null
					if(n_undie_color)
						undie_color = sanitize_hexcolor(n_undie_color)

				if("undershirt")
					var/new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference") as null|anything in GLOB.undershirt_list
					if(new_undershirt)
						undershirt = new_undershirt

				if("shirt_color")
					var/n_shirt_color = input(user, "Choose your undershirt's color.", "Character Preference", shirt_color) as color|null
					if(n_shirt_color)
						shirt_color = sanitize_hexcolor(n_shirt_color)

				if("socks")
					var/new_socks = input(user, "Choose your character's socks:", "Character Preference") as null|anything in GLOB.socks_list
					if(new_socks)
						socks = new_socks

				if("socks_color")
					var/n_socks_color = input(user, "Choose your socks' color.", "Character Preference", socks_color) as color|null
					if(n_socks_color)
						socks_color = sanitize_hexcolor(n_socks_color)

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference","#"+eye_color) as color|null
					if(new_eyes)
						eye_color = sanitize_hexcolor(new_eyes)

				if("species")
					var/result = input(user, "Select a species", "Species Selection") as null|anything in GLOB.roundstart_races
					if(result)
						var/newtype = GLOB.species_list[result]
						pref_species = new newtype()
						//let's ensure that no weird shit happens on species swapping.
						custom_species = null
						if(!("body_markings" in pref_species.default_features))
							features["body_markings"] = "None"
						if(!("mam_body_markings" in pref_species.default_features))
							features["mam_body_markings"] = "None"
						if("mam_body_markings" in pref_species.default_features)
							if(features["mam_body_markings"] == "None")
								features["mam_body_markings"] = "Plain"
						if("tail_lizard" in pref_species.default_features)
							features["tail_lizard"] = "Smooth"
						if(pref_species.id == "felinid")
							features["mam_tail"] = "Cat"
							features["mam_ears"] = "Cat"

						//Now that we changed our species, we must verify that the mutant colour is still allowed.
						var/temp_hsv = RGBtoHSV(features["mcolor"])
						if(features["mcolor"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor"] = pref_species.default_color
						if(features["mcolor2"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor2"] = pref_species.default_color
						if(features["mcolor3"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor3"] = pref_species.default_color

				if("custom_species")
					var/new_species = reject_bad_name(input(user, "Choose your species subtype, if unique. This will show up on examinations and health scans. Do not abuse this:", "Character Preference", custom_species) as null|text)
					if(new_species)
						custom_species = new_species
					else
						custom_species = null

				if("mutant_color")
					var/new_mutantcolor = input(user, "Choose your character's alien/mutant color:", "Character Preference","#"+features["mcolor"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor"] = pref_species.default_color
							update_preview_icon()
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
							update_preview_icon()
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mutant_color2")
					var/new_mutantcolor = input(user, "Choose your character's secondary alien/mutant color:", "Character Preference") as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor2"] = pref_species.default_color
							update_preview_icon()
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor2"] = sanitize_hexcolor(new_mutantcolor)
							update_preview_icon()
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mutant_color3")
					var/new_mutantcolor = input(user, "Choose your character's tertiary alien/mutant color:", "Character Preference") as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor3"] = pref_species.default_color
							update_preview_icon()
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor3"] = sanitize_hexcolor(new_mutantcolor)
							update_preview_icon()
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mismatched_markings")
					show_mismatched_markings = !show_mismatched_markings

				if("ipc_screen")
					var/new_ipc_screen
					new_ipc_screen = input(user, "Choose your character's screen:", "Character Preference") as null|anything in GLOB.ipc_screens_list
					if(new_ipc_screen)
						features["ipc_screen"] = new_ipc_screen

				if("ipc_antenna")
					var/list/snowflake_antenna_list = list()
					//Potential todo: turn all of THIS into a define to reduce copypasta.
					for(var/path in GLOB.ipc_antennas_list)
						var/datum/sprite_accessory/antenna/instance = GLOB.ipc_antennas_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_antenna_list[S.name] = path
					var/new_ipc_antenna
					new_ipc_antenna = input(user, "Choose your character's antenna:", "Character Preference") as null|anything in snowflake_antenna_list
					if(new_ipc_antenna)
						features["ipc_antenna"] = new_ipc_antenna

				if("tail_lizard")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.tails_list_lizard
					if(new_tail)
						features["tail_lizard"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["mam_tail"] = "None"

				if("tail_human")
					var/list/snowflake_tails_list = list()
					for(var/path in GLOB.tails_list_human)
						var/datum/sprite_accessory/tails/human/instance = GLOB.tails_list_human[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_tails_list[S.name] = path
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in snowflake_tails_list
					if(new_tail)
						features["tail_human"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_lizard"] = "None"
							features["mam_tail"] = "None"

				if("mam_tail")
					var/list/snowflake_tails_list = list()
					for(var/path in GLOB.mam_tails_list)
						var/datum/sprite_accessory/mam_tails/instance = GLOB.mam_tails_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_tails_list[S.name] = path
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in snowflake_tails_list
					if(new_tail)
						features["mam_tail"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"

				if("snout")
					var/list/snowflake_snouts_list = list()
					for(var/path in GLOB.snouts_list)
						var/datum/sprite_accessory/mam_snouts/instance = GLOB.snouts_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_snouts_list[S.name] = path
					var/new_snout
					new_snout = input(user, "Choose your character's snout:", "Character Preference") as null|anything in snowflake_snouts_list
					if(new_snout)
						features["snout"] = new_snout
						features["mam_snouts"] = "None"


				if("mam_snouts")
					var/list/snowflake_mam_snouts_list = list()
					for(var/path in GLOB.mam_snouts_list)
						var/datum/sprite_accessory/mam_snouts/instance = GLOB.mam_snouts_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_mam_snouts_list[S.name] = path
					var/new_mam_snouts
					new_mam_snouts = input(user, "Choose your character's snout:", "Character Preference") as null|anything in snowflake_mam_snouts_list
					if(new_mam_snouts)
						features["mam_snouts"] = new_mam_snouts
						features["snout"] = "None"

				if("horns")
					var/new_horns
					new_horns = input(user, "Choose your character's horns:", "Character Preference") as null|anything in GLOB.horns_list
					if(new_horns)
						features["horns"] = new_horns

				if("wings")
					var/new_wings
					new_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.r_wings_list
					if(new_wings)
						features["wings"] = new_wings

				if("wings_color")
					var/new_wing_color = input(user, "Choose your character's wing colour:", "Character Preference","#"+wing_color) as color|null
					if(new_wing_color)
						if (new_wing_color == "#000000")
							wing_color = "#FFFFFF"
						else
							wing_color = sanitize_hexcolor(new_wing_color)

				if("frills")
					var/new_frills
					new_frills = input(user, "Choose your character's frills:", "Character Preference") as null|anything in GLOB.frills_list
					if(new_frills)
						features["frills"] = new_frills

				if("spines")
					var/new_spines
					new_spines = input(user, "Choose your character's spines:", "Character Preference") as null|anything in GLOB.spines_list
					if(new_spines)
						features["spines"] = new_spines

				if("body_markings")
					var/new_body_markings
					new_body_markings = input(user, "Choose your character's body markings:", "Character Preference") as null|anything in GLOB.body_markings_list
					if(new_body_markings)
						features["body_markings"] = new_body_markings
						if(new_body_markings != "None")
							features["mam_body_markings"] = "None"
						update_preview_icon()

				if("legs")
					var/new_legs
					new_legs = input(user, "Choose your character's legs:", "Character Preference") as null|anything in GLOB.legs_list
					if(new_legs)
						features["legs"] = new_legs
						update_preview_icon()

				if("moth_wings")
					var/new_moth_wings
					new_moth_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.moth_wings_list
					if(new_moth_wings)
						features["moth_wings"] = new_moth_wings

				if("moth_fluffs")
					var/new_moth_fluff
					new_moth_fluff = input(user, "Choose your character's fluff:", "Character Preference") as null|anything in GLOB.moth_fluffs_list
					if(new_moth_fluff)
						features["moth_fluff"] = new_moth_fluff

				if("deco_wings")
					var/new_deco_wings
					new_deco_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.deco_wings_list
					if(new_deco_wings)
						features["deco_wings"] = new_deco_wings

				if("moth_markings")
					var/new_moth_markings
					new_moth_markings = input(user, "Choose your character's markings:", "Character Preference") as null|anything in GLOB.moth_markings_list
					if(new_moth_markings)
						features["moth_markings"] = new_moth_markings

				if("s_tone")
					var/new_s_tone = input(user, "Choose your character's skin-tone:", "Character Preference")  as null|anything in GLOB.skin_tones
					if(new_s_tone)
						skin_tone = new_s_tone

				if("taur")
					var/list/snowflake_taur_list = list()
					for(var/path in GLOB.taur_list)
						var/datum/sprite_accessory/taur/instance = GLOB.taur_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_taur_list[S.name] = path
					var/new_taur
					new_taur = input(user, "Choose your character's tauric body:", "Character Preference") as null|anything in snowflake_taur_list
					if(new_taur)
						features["taur"] = new_taur
						if(new_taur != "None")
							features["mam_tail"] = "None"
							features["xenotail"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"

				if("ears")
					var/list/snowflake_ears_list = list()
					for(var/path in GLOB.ears_list)
						var/datum/sprite_accessory/ears/instance = GLOB.ears_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_ears_list[S.name] = path
					var/new_ears
					new_ears = input(user, "Choose your character's ears:", "Character Preference") as null|anything in snowflake_ears_list
					if(new_ears)
						features["ears"] = new_ears

				if("mam_ears")
					var/list/snowflake_ears_list = list()
					for(var/path in GLOB.mam_ears_list)
						var/datum/sprite_accessory/mam_ears/instance = GLOB.mam_ears_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_ears_list[S.name] = path
					var/new_ears
					new_ears = input(user, "Choose your character's ears:", "Character Preference") as null|anything in snowflake_ears_list
					if(new_ears)
						features["mam_ears"] = new_ears

				if("mam_body_markings")
					var/list/snowflake_markings_list = list()
					for(var/path in GLOB.mam_body_markings_list)
						var/datum/sprite_accessory/mam_body_markings/instance = GLOB.mam_body_markings_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_markings_list[S.name] = path
					var/new_mam_body_markings
					new_mam_body_markings = input(user, "Choose your character's body markings:", "Character Preference") as null|anything in snowflake_markings_list
					if(new_mam_body_markings)
						features["mam_body_markings"] = new_mam_body_markings
						if(new_mam_body_markings != "None")
							features["body_markings"] = "None"
						else if(new_mam_body_markings == "None")
							features["mam_body_markings"] = "Plain"
							features["body_markings"] = "None"
						update_preview_icon()

				//Xeno Bodyparts
				if("xenohead")//Head or caste type
					var/new_head
					new_head = input(user, "Choose your character's caste:", "Character Preference") as null|anything in GLOB.xeno_head_list
					if(new_head)
						features["xenohead"] = new_head

				if("xenotail")//Currently one one type, more maybe later if someone sprites them. Might include animated variants in the future.
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.xeno_tail_list
					if(new_tail)
						features["xenotail"] = new_tail
						if(new_tail != "None")
							features["mam_tail"] = "None"
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"

				if("xenodorsal")
					var/new_dors
					new_dors = input(user, "Choose your character's dorsal tube type:", "Character Preference") as null|anything in GLOB.xeno_dorsal_list
					if(new_dors)
						features["xenodorsal"] = new_dors
				//Genital code
				if("cock_color")
					var/new_cockcolor = input(user, "Penis color:", "Character Preference") as color|null
					if(new_cockcolor)
						var/temp_hsv = RGBtoHSV(new_cockcolor)
						if(new_cockcolor == "#000000")
							features["cock_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["cock_color"] = sanitize_hexcolor(new_cockcolor)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("cock_length")
					var/new_length = input(user, "Penis length in inches:\n([COCK_SIZE_MIN]-[COCK_SIZE_MAX]) Your sprite size will affect your length examine text!\n(When 6in, 50%->3in, 200%->12in)", "Character Preference") as num|null
					if(new_length)
						features["cock_length"] = max(min( round(text2num(new_length)), COCK_SIZE_MAX),COCK_SIZE_MIN)

				if("cock_girth_ratio")
					var/new_girth = input(user, "Penis to girth ratio:\n([COCK_GIRTH_RATIO_MIN]-[COCK_GIRTH_RATIO_MAX]) This will affect your girth examine text in relation to length!\n(Whole numbers become fractions 25->.25, 30->.3)", "Character Preference") as num|null
					if(new_girth)
						features["cock_girth_ratio"] = (max(min( round(text2num(new_girth)), 42),15))/100

				if("balls_size")
					var/new_balls_size = input(user, "Testicle circumference in inches:\n([BALLS_SIZE_MIN]-[BALLS_SIZE_MAX])", "Character Preference") as num|null
					if(new_balls_size)
						features["balls_size"] = max(min( round(text2num(new_balls_size)), BALLS_SIZE_MAX),BALLS_SIZE_MIN)

				if("cock_shape")
					var/new_shape
					new_shape = input(user, "Penis shape:", "Character Preference") as null|anything in GLOB.cock_shapes_list
					if(new_shape)
						features["cock_shape"] = new_shape

				if("balls_color")
					var/new_ballscolor = input(user, "Testicle Color:", "Character Preference") as color|null
					if(new_ballscolor)
						var/temp_hsv = RGBtoHSV(new_ballscolor)
						if(new_ballscolor == "#000000")
							features["balls_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["balls_color"] = sanitize_hexcolor(new_ballscolor)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("belly_color")
					var/new_bellycolor = input(user, "Belly Color:", "Character Preference") as color|null
					if(new_bellycolor)
						var/temp_hsv = RGBtoHSV(new_bellycolor)
						if(new_bellycolor == "#000000")
							features["belly_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["belly_color"] = sanitize_hexcolor(new_bellycolor)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("butt_color")
					var/new_buttcolor = input(user, "Butt Color:", "Character Preference") as color|null
					if(new_buttcolor)
						var/temp_hsv = RGBtoHSV(new_buttcolor)
						if(new_buttcolor == "#000000")
							features["butt_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["butt_color"] = sanitize_hexcolor(new_buttcolor)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("balls_shape")
					var/new_shape
					new_shape = input(user, "Testicle Type:", "Character Preference") as null|anything in GLOB.balls_shapes_list
					if(new_shape)
						features["balls_shape"] = new_shape

				if("balls_fluid")
					var/new_shape
					new_shape = input(user, "Balls Fluid", "Character Preference") as null|anything in GLOB.genital_fluids_list
					switch(new_shape)
						if("Milk")
							features["balls_fluid"] = /datum/reagent/consumable/milk
						if("Water")
							features["balls_fluid"] = /datum/reagent/water
						if("Semen")
							features["balls_fluid"] = /datum/reagent/consumable/semen
						if("Femcum")
							features["balls_fluid"] = /datum/reagent/consumable/femcum
						if("Honey")
							features["balls_fluid"] = /datum/reagent/consumable/alienhoney

				if("egg_size")
					var/new_size
					var/list/egg_sizes = list(1,2,3)
					new_size = input(user, "Egg Diameter(inches):", "Egg Size") as null|anything in egg_sizes
					if(new_size)
						features["eggsack_egg_size"] = new_size

				if("egg_color")
					var/new_egg_color = input(user, "Egg Color:", "Character Preference") as color|null
					if(new_egg_color)
						var/temp_hsv = RGBtoHSV(new_egg_color)
						if(ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["eggsack_egg_color"] = sanitize_hexcolor(new_egg_color)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("breasts_size")
					var/new_size
					new_size = input(user, "Breast Size", "Character Preference") as null|anything in GLOB.breasts_size_list
					if(new_size)
						features["breasts_size"] = new_size

				if("breasts_shape")
					var/new_shape
					new_shape = input(user, "Breast Shape", "Character Preference") as null|anything in GLOB.breasts_shapes_list
					if(new_shape)
						features["breasts_shape"] = new_shape

				if("breasts_fluid")
					var/new_shape
					new_shape = input(user, "Breast Fluid", "Character Preference") as null|anything in GLOB.genital_fluids_list
					switch(new_shape)
						if("Milk")
							features["breasts_fluid"] = /datum/reagent/consumable/milk
						if("Water")
							features["breasts_fluid"] = /datum/reagent/water
						if("Semen")
							features["breasts_fluid"] = /datum/reagent/consumable/semen
						if("Femcum")
							features["breasts_fluid"] = /datum/reagent/consumable/femcum
						if("Honey")
							features["breasts_fluid"] = /datum/reagent/consumable/alienhoney

				if("breasts_color")
					var/new_breasts_color = input(user, "Breast Color:", "Character Preference") as color|null
					if(new_breasts_color)
						var/temp_hsv = RGBtoHSV(new_breasts_color)
						if(new_breasts_color == "#000000")
							features["breasts_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["breasts_color"] = sanitize_hexcolor(new_breasts_color)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("belly_size")
					var/new_bellysize = input(user, "Belly size :\n(1-3)", "Character Preference") as num|null
					if(new_bellysize)
						features["belly_size"] = clamp(new_bellysize, 1, 3)

				if("butt_size")
					var/new_buttsize = input(user, "Butt size :\n(0-5)", "Character Preference") as num|null
					if(new_buttsize)
						features["butt_size"] = clamp(new_buttsize, 0, 5)

				if("vag_shape")
					var/new_shape
					new_shape = input(user, "Vagina Type", "Character Preference") as null|anything in GLOB.vagina_shapes_list
					if(new_shape)
						features["vag_shape"] = new_shape

				if("vag_color")
					var/new_vagcolor = input(user, "Vagina color:", "Character Preference") as color|null
					if(new_vagcolor)
						var/temp_hsv = RGBtoHSV(new_vagcolor)
						if(new_vagcolor == "#000000")
							features["vag_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["vag_color"] = sanitize_hexcolor(new_vagcolor)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference",ooccolor) as color|null
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("aooccolor")
					var/new_aooccolor = input(user, "Choose your Antag OOC colour:", "Game Preference",ooccolor) as color|null
					if(new_aooccolor)
						aooccolor = new_aooccolor

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in GLOB.backbaglist
					if(new_backbag)
						backbag = new_backbag

				if("suit")
					if(jumpsuit_style == PREF_SUIT)
						jumpsuit_style = PREF_SKIRT
					else
						jumpsuit_style = PREF_SUIT


				if("uplink_loc")
					var/new_loc = input(user, "Choose your character's traitor uplink spawn location:", "Character Preference") as null|anything in GLOB.uplink_spawn_loc_list
					if(new_loc)
						uplink_spawn_loc = new_loc

				if("ai_core_icon")
					var/ai_core_icon = input(user, "Choose your preferred AI core display screen:", "AI Core Display Screen Selection") as null|anything in GLOB.ai_core_display_screens
					if(ai_core_icon)
						preferred_ai_core_display = ai_core_icon

				if("sec_dept")
					var/department = input(user, "Choose your preferred security department:", "Security Departments") as null|anything in GLOB.security_depts_prefs
					if(department)
						prefered_security_department = department

				if ("preferred_map")
					var/maplist = list()
					var/default = "Default"
					if (config.defaultmap)
						default += " ([config.defaultmap.map_name])"
					for (var/M in config.maplist)
						var/datum/map_config/VM = config.maplist[M]
						var/friendlyname = "[VM.map_name] "
						if (VM.voteweight <= 0)
							friendlyname += " (disabled)"
						maplist[friendlyname] = VM.map_name
					maplist[default] = null
					var/pickedmap = input(user, "Choose your preferred map. This will be used to help weight random map selection.", "Character Preference")  as null|anything in maplist
					if (pickedmap)
						preferred_map = maplist[pickedmap]

				if ("clientfps")
					var/desiredfps = input(user, "Choose your desired fps. (0 = synced with server tick rate (currently:[world.fps]))", "Character Preference", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = desiredfps
						parent.fps = desiredfps

//Hyperstation Body Size

				if("bodysize")
					var/new_bodysize = input(user, "Choose your desired sprite size:\n([MIN_BODYSIZE]-[MAX_BODYSIZE]), Warning: May make your character look distorted!\nWill change health pool and speed, while limiting some mechanics (ex: lockers).", "Character Preference") as num|null
					if (new_bodysize)
						body_size = max(min( round(text2num(new_bodysize)), MAX_BODYSIZE),MIN_BODYSIZE)



				if("ui")
					var/pickedui = input(user, "Choose your UI style.", "Character Preference", UI_style)  as null|anything in GLOB.available_ui_styles
					if(pickedui)
						UI_style = pickedui
						if (parent && parent.mob && parent.mob.hud_used)
							parent.mob.hud_used.update_ui_style(ui_style2icon(UI_style))
				if("pda_style")
					var/pickedPDAStyle = input(user, "Choose your PDA style.", "Character Preference", pda_style)  as null|anything in GLOB.pda_styles
					if(pickedPDAStyle)
						pda_style = pickedPDAStyle
				if("pda_color")
					var/pickedPDAColor = input(user, "Choose your PDA Interface color.", "Character Preference",pda_color) as color|null
					if(pickedPDAColor)
						pda_color = pickedPDAColor
				if("pda_skin")
					var/pickedPDASkin = input(user, "Choose your PDA reskin.", "Character Preference", pda_skin) as null|anything in GLOB.pda_reskins
					if(pickedPDASkin)
						pda_skin = pickedPDASkin
				if ("max_chat_length")
					var/desiredlength = input(user, "Choose the max character length of shown Runechat messages. Valid range is 1 to [CHAT_MESSAGE_MAX_LENGTH] (default: [initial(max_chat_length)]))", "Character Preference", max_chat_length)  as null|num
					if (!isnull(desiredlength))
						max_chat_length = clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH)
				if("tongue")
					var/selected_custom_tongue = input(user, "Choose your desired tongue (none means your species tongue)", "Character Preference") as null|anything in GLOB.roundstart_tongues
					if(selected_custom_tongue)
						custom_tongue = selected_custom_tongue
				if("speech_verb")
					var/selected_custom_speech_verb = input(user, "Choose your desired speech verb (none means your species speech verb)", "Character Preference") as null|anything in GLOB.speech_verbs
					if(selected_custom_speech_verb)
						custom_speech_verb = selected_custom_speech_verb
		else
			switch(href_list["preference"])
				//CITADEL PREFERENCES EDIT - I can't figure out how to modularize these, so they have to go here. :c -Pooj
				if("genital_colour")
					features["genitals_use_skintone"] = !features["genitals_use_skintone"]
				if("arousable")
					arousable = !arousable
				if("noncon")
					noncon = !noncon
				if("has_cock")
					features["has_cock"] = !features["has_cock"]
					if(features["has_cock"] == FALSE)
						features["has_balls"] = FALSE
				if("has_belly")
					features["has_belly"] = !features["has_belly"]
					if(features["has_belly"] == FALSE)
						features["hide_belly"] = FALSE
						features["inflatable_belly"] = FALSE
						features["belly_size"] = 1

				if("inflatable_belly")
					features["inflatable_belly"] = !features["inflatable_belly"]
				if("hide_belly")
					features["hide_belly"] = !features["hide_belly"]
				if("has_balls")
					features["has_balls"] = !features["has_balls"]
				if("has_ovi")
					features["has_ovi"] = !features["has_ovi"]
				if("has_eggsack")
					features["has_eggsack"] = !features["has_eggsack"]
				if("balls_internal")
					features["balls_internal"] = !features["balls_internal"]
				if("eggsack_internal")
					features["eggsack_internal"] = !features["eggsack_internal"]
				if("has_breasts")
					features["has_breasts"] = !features["has_breasts"]
					if(features["has_breasts"] == FALSE)
						features["breasts_producing"] = FALSE
				if("breasts_producing")
					features["breasts_producing"] = !features["breasts_producing"]
				if("has_vag")
					features["has_vag"] = !features["has_vag"]
					if(features["has_vag"] == FALSE)
						features["has_womb"] = FALSE
						features["can_get_preg"] = FALSE
				if("has_anus")
					features["has_anus"] = !features["has_anus"]
					if(features["has_anus"] == FALSE)
						features["butt_size"] = 0
				if("has_womb")
					features["has_womb"] = !features["has_womb"]
				if("can_get_preg")
					features["can_get_preg"] = !features["can_get_preg"]
				if("exhibitionist")
					features["exhibitionist"] = !features["exhibitionist"]
				if("widescreenpref")
					widescreenpref = !widescreenpref
					user.client.change_view(CONFIG_GET(string/default_view))
				if("autostand")
					autostand = !autostand
				if ("screenshake")
					var/desiredshake = input(user, "Set the amount of screenshake you want. \n(0 = disabled, 100 = full, 200 = maximum.)", "Character Preference", screenshake)  as null|num
					if (!isnull(desiredshake))
						screenshake = desiredshake
				if("damagescreenshake")
					switch(damagescreenshake)
						if(0)
							damagescreenshake = 1
						if(1)
							damagescreenshake = 2
						if(2)
							damagescreenshake = 0
						else
							damagescreenshake = 1
				if("nameless")
					nameless = !nameless
				//END CITADEL EDIT
				if("publicity")
					if(unlock_content)
						toggles ^= MEMBER_PUBLIC
				if("gender")
					var/chosengender = input(user, "Select your character's gender.", "Gender Selection", gender) in list(MALE,FEMALE,"nonbinary","object")
					switch(chosengender)
						if("nonbinary")
							chosengender = PLURAL
						if("object")
							chosengender = NEUTER
					gender = chosengender
					facial_hair_style = random_facial_hair_style(gender)
					hair_style = random_hair_style(gender)

				if("hotkeys")
					hotkeys = !hotkeys
					if(hotkeys)
						winset(user, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED] mainwindow.macro=default")
					else
						winset(user, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED] mainwindow.macro=old_default")
				if("action_buttons")
					buttons_locked = !buttons_locked
				if("chat_on_map")
					chat_on_map = !chat_on_map
				if("autocorrect")
					autocorrect = !autocorrect
				if("radiosounds")
					radiosounds = !radiosounds
				if("see_chat_non_mob")
					see_chat_non_mob = !see_chat_non_mob
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("winflash")
					windowflashing = !windowflashing
				if("hear_adminhelps")
					toggles ^= SOUND_ADMINHELP
				if("announce_login")
					toggles ^= ANNOUNCE_LOGIN
				if("combohud_lighting")
					toggles ^= COMBOHUD_LIGHTING

				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						be_special -= list(be_special_type)
					else
						be_special += list(be_special_type)

				if("name")
					be_random_name = !be_random_name

				if("all")
					be_random_body = !be_random_body

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if((toggles & SOUND_LOBBY) && user.client && isnewplayer(user))
						user.client.playtitlemusic()
					else
						user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

				if("ghost_ears")
					chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")
					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("parallaxup")
					parallax = WRAP(parallax + 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("parallaxdown")
					parallax = WRAP(parallax - 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				// Citadel edit - Prefs don't work outside of this. :c
				if("genital_examine")
					cit_toggles ^= GENITAL_EXAMINE

				if("vore_examine")
					cit_toggles ^= VORE_EXAMINE

				if("hound_sleeper")
					cit_toggles ^= MEDIHOUND_SLEEPER

				if("toggleeatingnoise")
					cit_toggles ^= EATING_NOISES

				if("toggledigestionnoise")
					cit_toggles ^= DIGESTION_NOISES

				if("toggleforcefeedtrash")
					cit_toggles ^= TRASH_FORCEFEED

				if("breast_enlargement")
					cit_toggles ^= BREAST_ENLARGEMENT

				if("penis_enlargement")
					cit_toggles ^= PENIS_ENLARGEMENT

				if("ass_enlargement")
					cit_toggles ^= ASS_ENLARGEMENT

				if("feminization")
					cit_toggles ^= FORCED_FEM

				if("masculinization")
					cit_toggles ^= FORCED_MASC

				if("hypno")
					cit_toggles ^= HYPNO

				if("never_hypno")
					cit_toggles ^= NEVER_HYPNO

				if("aphro")
					cit_toggles ^= NO_APHRO

				if("ass_slap")
					cit_toggles ^= NO_ASS_SLAP

				if("auto_wag")
					cit_toggles ^= NO_AUTO_WAG

				if("no_uwu")
					cit_toggles ^= NO_UWU

				//END CITADEL EDIT

				if("ambientocclusion")
					ambientocclusion = !ambientocclusion
					if(parent && parent.screen && parent.screen.len)
						var/obj/screen/plane_master/game_world/PM = locate(/obj/screen/plane_master/game_world) in parent.screen
						PM.backdrop(parent.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && parent)
						parent.fit_viewport()

				if("sprint_key")
					sprint_spacebar = !sprint_spacebar

				if("sprint_toggle")
					sprint_toggle = !sprint_toggle

				if("save")
					save_preferences()
					save_character()

				if("load")
					load_preferences()
					load_character()
					if(parent && parent.prefs_vr)
						attempt_vr(parent.prefs_vr,"load_vore","")

				if("changeslot")
					if(!load_character(text2num(href_list["num"])))
						random_character()
						real_name = random_unique_name(gender)
						save_character()
					if(parent && parent.prefs_vr)
						attempt_vr(parent.prefs_vr,"load_vore","")

				if("tab")
					if (href_list["tab"])
						current_tab = text2num(href_list["tab"])
	if(href_list["preference"] == "gear")
		if(href_list["clear_loadout"])
			LAZYCLEARLIST(chosen_gear)
			gear_points = initial(gear_points)
			save_preferences()
		if(href_list["select_category"])
			for(var/i in GLOB.loadout_items)
				if(i == href_list["select_category"])
					gear_tab = i
		if(href_list["toggle_gear_path"])
			var/datum/gear/G = GLOB.loadout_items[gear_tab][html_decode(href_list["toggle_gear_path"])]
			if(!G)
				return
			var/toggle = text2num(href_list["toggle_gear"])
			if(!toggle && (G.type in chosen_gear))//toggling off and the item effectively is in chosen gear)
				LAZYREMOVE(chosen_gear, G.type)
				gear_points += initial(G.cost)
			else if(toggle && (!(is_type_in_ref_list(G, chosen_gear))))
				if(!is_loadout_slot_available(G.category))
					to_chat(user, "<span class='danger'>You cannot take this loadout, as you've already chosen too many of the same category!</span>")
					return
				if(G.ckeywhitelist && G.ckeywhitelist.len && !(user.ckey in G.ckeywhitelist))
					to_chat(user, "<span class='danger'>This is an item intended for donator use only. You are not authorized to use this item.</span>")
					return
				if(gear_points >= initial(G.cost))
					LAZYADD(chosen_gear, G.type)
					gear_points -= initial(G.cost)
		if(href_list["toggle_outfit_visibility"])
			preview_job_outfit = !preview_job_outfit

	ShowChoices(user)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE)
	if(be_random_name)
		real_name = pref_species.random_name(gender)

	if(be_random_body)
		random_character(gender)

	if(roundstart_checks)
		if(CONFIG_GET(flag/humans_need_surnames) && (pref_species.id == "human"))
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(GLOB.last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(GLOB.last_names)]"

	character.real_name = nameless ? "[real_name] #[rand(10000, 99999)]" : real_name
	character.name = character.real_name
	character.nameless = nameless
	character.custom_species = custom_species

	//h13 character custom body size, make sure to set to 100% if the player hasn't choosen one yet.
	character.custom_body_size = body_size
	character.breedable = 0

	character.gender = gender
	character.age = age

	character.eye_color = eye_color
	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		if(!initial(organ_eyes.eye_color))
			organ_eyes.eye_color = eye_color
		organ_eyes.old_eye_color = eye_color
	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color
	character.wing_color = wing_color

	character.skin_tone = skin_tone
	character.hair_style = hair_style
	character.facial_hair_style = facial_hair_style

	character.grad_style = grad_style
	character.grad_color = grad_color
	character.underwear = underwear

	character.saved_underwear = underwear
	character.undershirt = undershirt
	character.saved_undershirt = undershirt
	character.socks = socks
	character.saved_socks = socks
	character.undie_color = undie_color
	character.shirt_color = shirt_color
	character.socks_color = socks_color


	character.backbag = backbag
	character.jumpsuit_style = jumpsuit_style

	var/datum/species/chosen_species
	if(!roundstart_checks || (pref_species.id in GLOB.roundstart_races))
		chosen_species = pref_species.type
	else
		chosen_species = /datum/species/human
		pref_species = new /datum/species/human
		save_character()

	character.set_species(chosen_species, icon_update = FALSE, pref_load = TRUE)
	character.dna.features = features.Copy()
	character.dna.real_name = character.real_name
	character.dna.nameless = character.nameless
	character.dna.custom_species = character.custom_species

	if("tail_lizard" in pref_species.default_features)
		character.dna.species.mutant_bodyparts |= "tail_lizard"
	if("mam_tail" in pref_species.default_features)
		character.dna.species.mutant_bodyparts |= "mam_tail"
	if("xenotail" in pref_species.default_features)
		character.dna.species.mutant_bodyparts |= "xenotail"

	if(("legs" in character.dna.species.mutant_bodyparts) && character.dna.features["legs"] == "Digitigrade Legs")
		pref_species.species_traits |= DIGITIGRADE
	else
		pref_species.species_traits -= DIGITIGRADE

	if(DIGITIGRADE in pref_species.species_traits)
		character.Digitigrade_Leg_Swap(FALSE)
	else
		character.Digitigrade_Leg_Swap(TRUE)

	SEND_SIGNAL(character, COMSIG_HUMAN_PREFS_COPIED_TO, src, icon_updates, roundstart_checks)

	//speech stuff
	if(custom_tongue != "default")
		var/new_tongue = GLOB.roundstart_tongues[custom_tongue]
		if(new_tongue)
			var/obj/item/organ/tongue/T = character.getorganslot(ORGAN_SLOT_TONGUE)
			if(T)
				qdel(T)
			var/obj/item/organ/tongue/new_custom_tongue = new new_tongue
			new_custom_tongue.Insert(character)
	if(custom_speech_verb != "default")
		character.dna.species.say_mod = custom_speech_verb

	//let's be sure the character updates
	character.update_body()
	character.update_hair()
	character.update_body_parts()


/datum/preferences/proc/get_default_name(name_id)
	switch(name_id)
		if("human")
			return random_unique_name()
		if("ai")
			return pick(GLOB.ai_names)
		if("cyborg")
			return DEFAULT_CYBORG_NAME
		if("clown")
			return pick(GLOB.clown_names)
		if("mime")
			return pick(GLOB.mime_names)
	return random_unique_name()

/datum/preferences/proc/ask_for_custom_name(mob/user,name_id)
	var/namedata = GLOB.preferences_custom_names[name_id]
	if(!namedata)
		return

	var/raw_name = input(user, "Choose your character's [namedata["qdesc"]]:","Character Preference") as text|null
	if(!raw_name)
		if(namedata["allow_null"])
			custom_names[name_id] = get_default_name(name_id)
		else
			return
	else
		var/sanitized_name = reject_bad_name(raw_name,namedata["allow_numbers"])
		if(!sanitized_name)
			to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z,[namedata["allow_numbers"] ? ",0-9," : ""] -, ' and .</font>")
			return
		else
			custom_names[name_id] = sanitized_name
