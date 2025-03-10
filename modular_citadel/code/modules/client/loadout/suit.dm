/datum/gear/poncho
	name = "Poncho"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/poncho

/datum/gear/ponchogreen
	name = "Green poncho"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/poncho/green

/datum/gear/ponchored
	name = "Red poncho"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/poncho/red

/datum/gear/redhood
	name = "Red cloak"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/hooded/cloak/david
	cost = 3

/datum/gear/jacketbomber
	name = "Bomber jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket

/datum/gear/jacketflannelblack // all of these are reskins of bomber jackets but with the vibe to make you look like a true lumberjack
	name = "Black flannel jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/flannel

/datum/gear/jacketflannelred
	name = "Red flannel jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/flannel/red

/datum/gear/jacketflannelaqua
	name = "Aqua flannel jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/flannel/aqua

/datum/gear/jacketflannelbrown
	name = "Brown flannel jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/flannel/brown

/datum/gear/jacketleather
	name = "Leather jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/leather

/datum/gear/overcoatleather
	name = "Leather overcoat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/leather/overcoat

/datum/gear/jacketpuffer
	name = "Puffer jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/vestpuffer
	name = "Puffer vest"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/jacketyellow
	name = "Yellow Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/toggle/jacket_yellow

/datum/gear/jacketorange
	name = "Orange Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/toggle/jacket_orange

/datum/gear/jacketred
	name = "Red Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/toggle/jacket_red

/datum/gear/jacketpurple
	name = "Purple Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/toggle/jacket_purple

/datum/gear/jacketwhite
	name = "White Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/toggle/jacket_white

/datum/gear/jacketlettermanbrown
	name = "Brown letterman jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/letterman

/datum/gear/jacketlettermanred
	name = "Red letterman jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/letterman_red

/datum/gear/jacketlettermanNT
	name = "Nanotrasen letterman jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/letterman_nanotrasen

/datum/gear/coat
	name = "Winter coat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/hooded/wintercoat

/datum/gear/coat/aformal
	name = "Assistant's formal winter coat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/hooded/wintercoat/aformal

/datum/gear/coat/runed
	name = "Runed winter coat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/hooded/wintercoat/narsie/fake

/datum/gear/coat/brass
	name = "Brass winter coat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/hooded/wintercoat/ratvar/fake

/datum/gear/militaryjacket
	name = "Military Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/jacket/miljacket

/datum/gear/ianshirt
	name = "Ian Shirt"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/ianshirt

/datum/gear/flakjack
	name = "Flak Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/flakjack
	cost = 2

/datum/gear/gcvest
	name = "Guncaster's Vest"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/gcvest

/datum/gear/gcvestalt
	name = "Hellraider's Vest"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/gcvest/alt


/datum/gear/trekds9_coat
	name = "DS9 Overcoat (use uniform)"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/trek/ds9
	restricted_desc = "All, barring Service and Civilian"
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster",
							"Medical Doctor","Chemist","Virologist","Geneticist","Scientist", "Roboticist",
							"Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer",
							"Cargo Technician", "Shaft Miner") //everyone who actually deserves a job.
//Federation jackets from movies
/datum/gear/trekcmdcap
	name = "Fed (movie) uniform, Black"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/capt
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/trekcmdmov
	name = "Fed (movie) uniform, Red"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/fluff/fedcoat
	restricted_desc = "Heads of Staff and Security"
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster","Warden","Detective","Security Officer")

/datum/gear/trekmedscimov
	name = "Fed (movie) uniform, Blue"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/medsci
	restricted_desc = "Medical and Science"
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/trekengmov
	name = "Fed (movie) uniform, Yellow"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/eng
	restricted_desc = "Engineering and Cargo"
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/trekcmdcapmod
	name = "Fed (Modern) uniform, White"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/fluff/modernfedcoat
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/trekcmdmod
	name = "Fed (Modern) uniform, Red"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/fluff/modernfedcoat/sec
	restricted_desc = "Heads of Staff and Security"
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster","Warden","Detective","Security Officer")

/datum/gear/trekmedscimod
	name = "Fed (Modern) uniform, Blue"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/fluff/modernfedcoat/medsci
	restricted_desc = "Medical and Science"
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/trekengmod
	name = "Fed (Modern) uniform, Yellow"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/storage/fluff/modernfedcoat/eng
	restricted_desc = "Engineering and Cargo"
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/christmascoatr
	name = "Red Christmas Coat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/hooded/wintercoat/christmascoatr

/datum/gear/christmascoatg
	name = "Green Christmas Coat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/hooded/wintercoat/christmascoatg

/datum/gear/christmascoatrg
	name = "Red and Green Christmas Coat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/hooded/wintercoat/christmascoatrg

/datum/gear/kromajacket
	name = "Kromatose Military Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/polychromic/kromajacket

/datum/gear/kromacrop
	name = "Kromatose Short Jacket"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/polychromic/kromacrop

/datum/gear/blacksuitjacket
	name = "Black Suit Jacket"
	category = SLOT_WEAR_SUIT
	path =	/obj/item/clothing/suit/toggle/lawyer/black

/datum/gear/nemes
	name = "Pharoah tunic"
	category = SLOT_WEAR_SUIT
	path =	/obj/item/clothing/suit/nemes

/datum/gear/fluffcoat
	name = "Winter labcoat"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/toggle/labcoat/formallab

/datum/gear/uniform/bathrobe
	name = "Bathrobe"
	category = SLOT_WEAR_SUIT
	path = /obj/item/clothing/suit/bathrobe
