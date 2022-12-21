#define WORN 1
#define REMOVED 2

obj/items/wearable/wigs
	price = 500000
	desc = "A wig to hide those dreadful split ends."
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] attaches \his [src.name] to \his scalp.")
			for(var/obj/items/wearable/wigs/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")

obj/items/wearable/wigs/male_lightgreen_wig
	icon = 'male_lightgreen_wig.dmi'
	name = "male light green wig"
obj/items/wearable/wigs/male_black_wig
	icon = 'male_black_wig.dmi'
obj/items/wearable/wigs/male_blond_wig
	icon = 'male_yellow_wig.dmi'
	name = "male yellow wig"
obj/items/wearable/wigs/male_blue_wig
	icon = 'male_lightblue_wig.dmi'
	name = "male light blue wig"
obj/items/wearable/wigs/male_brown_wig
	icon = 'male_brown_wig.dmi'
obj/items/wearable/wigs/male_darkgreen_wig
	icon = 'male_darkgreen_wig.dmi'
	name = "male dark green wig"
obj/items/wearable/wigs/male_green_wig
	icon = 'male_green_wig.dmi'
obj/items/wearable/wigs/male_grey_wig
	icon = 'male_grey_wig.dmi'
obj/items/wearable/wigs/male_pink_wig
	icon = 'male_lightpink_wig.dmi'
	name = "male light pink wig"
obj/items/wearable/wigs/male_purple_wig
	icon = 'male_lightpurple_wig.dmi'
	name = "male light purple wig"
obj/items/wearable/wigs/male_silver_wig
	icon = 'male_silver_wig.dmi'
obj/items/wearable/wigs/male_red_wig
	icon = 'male_red_wig.dmi'
	name = "male red wig"
obj/items/wearable/wigs/male_teal_wig
	icon = 'male_teal_wig.dmi'
	name = "male teal wig"
/*obj/items/wearable/wigs/male_demonic_wig
	icon = 'male_demonic_wig.dmi'
	name = "Demonic's wig"*/
obj/items/wearable/wigs/male_bluebrown_wig
	icon = 'male_bluebrown_wig.dmi'
	name = "male blue and brown wig"
obj/items/wearable/wigs/male_blackgreen_wig
	icon = 'male_blackgreen_wig.dmi'
	name = "male black and green wig"
obj/items/wearable/wigs/male_royale_wig
	icon = 'male_royale_wig.dmi'
obj/items/wearable/wigs/male_apollo_wig
	icon = 'male_apollo_wig.dmi'
	name = "male blond wig"
obj/items/wearable/wigs/male_cyan_wig
	icon = 'male_cyan_wig.dmi'
obj/items/wearable/wigs/male_darkblue_wig
	icon = 'male_darkblue_wig.dmi'
	name = "male dark blue wig"
obj/items/wearable/wigs/male_darkpurple_wig
	icon = 'male_darkpurple_wig.dmi'
	name = "male dark purple wig"
obj/items/wearable/wigs/male_darkpink_wig
	icon = 'male_darkpink_wig.dmi'
	name = "male dark pink wig"
obj/items/wearable/wigs/male_orange_wig
	icon = 'male_orange_wig.dmi'

//Holiday//
obj/items/wearable/wigs/male_christmas_wig
	icon = 'male_christmas_wig.dmi'
	dropable = 0
obj/items/wearable/wigs/male_halloween_wig
	icon = 'male_halloween_wig.dmi'
/////////

obj/items/wearable/wigs/female_black_wig
	icon = 'female_black_wig.dmi'
obj/items/wearable/wigs/female_blonde_wig
	icon = 'female_yellow_wig.dmi'
	name = "female yellow wig"
obj/items/wearable/wigs/female_blue_wig
	icon = 'female_lightblue_wig.dmi'
	name = "female light blue wig"
obj/items/wearable/wigs/female_brown_wig
	icon = 'female_brown_wig.dmi'
obj/items/wearable/wigs/female_green_wig
	icon = 'female_green_wig.dmi'
obj/items/wearable/wigs/female_grey_wig
	icon = 'female_grey_wig.dmi'
obj/items/wearable/wigs/female_pink_wig
	icon = 'female_lightpink_wig.dmi'
	name = "female light pink wig"
obj/items/wearable/wigs/female_purple_wig
	icon = 'female_lightpurple_wig.dmi'
	name = "female light purple wig"
obj/items/wearable/wigs/female_darkpurple_wig
	icon = 'female_darkpurple_wig.dmi'
	name = "female dark purple wig"
obj/items/wearable/wigs/female_silver_wig
	icon = 'female_silver_wig.dmi'
obj/items/wearable/wigs/female_redblack_wig
	icon = 'female_redblack_wig.dmi'
	name = "female red and black wig"
obj/items/wearable/wigs/female_soleil_wig
	icon = 'female_soleil_wig.dmi'
	name = "female blonde wig"
obj/items/wearable/wigs/female_rainbow_wig
	icon = 'female_rainbow_wig.dmi'
	name = "female rainbow wig"
obj/items/wearable/wigs/female_cyan_wig
	icon = 'female_cyan_wig.dmi'
obj/items/wearable/wigs/female_darkblue_wig
	icon = 'female_darkblue_wig.dmi'
	name = "female dark blue wig"
obj/items/wearable/wigs/female_darkpink_wig
	icon = 'female_darkpink_wig.dmi'
	name = "female dark pink wig"
obj/items/wearable/wigs/female_orange_wig
	icon = 'female_orange_wig.dmi'
obj/items/wearable/wigs/female_red_wig
	icon = 'female_red_wig.dmi'
obj/items/wearable/wigs/female_teal_wig
	icon = 'female_teal_wig.dmi'

//Holiday//
obj/items/wearable/wigs/female_christmas_wig
	icon = 'female_christmas_wig.dmi'
	dropable = 0
obj/items/wearable/wigs/female_halloween_wig
	icon = 'female_halloween_wig.dmi'