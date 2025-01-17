
enchanting

	scroll
		reqType = /obj/items/scroll
		chance  = 45
		prize   = list(/obj/items/wearable/title/Bookworm,
		               /obj/items/wearable/title/Lumberjack,
		               /obj/items/riddle_scroll)

	teleport
		reqType = /obj/items/artifact
		chance  = 30
		prize   = /obj/items/magic_stone/teleport

	weather
		reqType = /obj/items/crystal/soul
		bonus   = 3
		chance  = 60
		prize   = list(/obj/items/weather/sun,
		               /obj/items/weather/rain,
		               /obj/items/weather/acid,
		               /obj/items/weather/snow)

	damage_lamp
		reqType = /obj/items/crystal/damage
		bonus   = 3
		chance  = 50
		prize   = /obj/items/lamps/damage_lamp

	defense_lamp
		reqType = /obj/items/crystal/defense
		bonus   = 3
		chance  = 50
		prize   = /obj/items/lamps/defense_lamp

	luck_lamps
		reqType = /obj/items/crystal/luck
		bonus   = 3
		chance  = 60
		prize   = list(/obj/items/lamps/double_gold_lamp,
		               /obj/items/lamps/double_exp_lamp,
		               /obj/items/lamps/double_drop_rate_lamp,
		               /obj/items/crystal/strong_luck)

	strong_luck_lamps
		reqType = /obj/items/crystal/strong_luck
		bonus   = 3
		chance  = 50
		prize   = list(/obj/items/lamps/triple_gold_lamp,
		               /obj/items/lamps/triple_exp_lamp,
		               /obj/items/lamps/triple_drop_rate_lamp)

	summon
		reqType = /obj/items/crystal/magic
		bonus   = 3
		chance  = 30
		souls   = 1
		prize   = /obj/items/magic_stone/summoning/random

	deathcoin
		reqType = /obj/items/crystal/magic
		bonus   = 3
		chance  = 30
		souls   = 2
		prize   = /obj/items/magic_stone/eye

	memory
		reqType = /obj/items/magic_stone/teleport
		bonus   = 3
		chance  = 20
		souls   = 3
		prize   = /obj/items/magic_stone/memory

	memory_teleport
		reqType = /obj/items/magic_stone/memory
		bonus   = 3
		chance  = 40
		souls   = 2
		prize   = /obj/items/magic_stone/teleport/memory

	resurrection
		reqType = /obj/items/magic_stone/summoning/resurrection
		chance  = 40
		prize   = /obj/items/wearable/resurrection_stone

	chest
		reqType = /obj/items/chest
		bonus   = 3
		chance  = 50
		prize   = list(/obj/items/chest/basic_chest            = 15,
		               /obj/items/chest/wizard_chest           = 15,
		               /obj/items/chest/pentakill_chest        = 15,
					   /obj/items/chest/prom_chest             = 10,
					   /obj/items/chest/summer_chest           = 10,
					   /obj/items/chest/winter_chest           = 10,
					   /obj/items/chest/pet_chest              = 10,
					   /obj/items/chest/blood_chest            = 8,
		               /obj/items/chest/sunset_chest           = 4,
		               /obj/items/chest/legendary_golden_chest = 1)

	key
		reqType = /obj/items/key
		bonus   = 3
		chance  = 50
		prize   = list(/obj/items/key/basic_key            = 15,
		               /obj/items/key/wizard_key           = 15,
		               /obj/items/key/pentakill_key        = 15,
					   /obj/items/key/prom_key             = 10,
					   /obj/items/key/summer_key           = 10,
					   /obj/items/key/winter_key           = 10,
					   /obj/items/key/blood_key            = 8,
		               /obj/items/key/sunset_key           = 4)

	power_lamp
		reqType = /obj/items/crystal/magic
		bonus   = 3
		chance  = 30
		prize   = /obj/items/lamps/power_lamp

	chaos_orb
		reqType = /obj/items/wearable/orb/chaos
		bonus   = 1
		chance  = 60
		prize   = /obj/items/wearable/orb/chaos/greater

	peace_orb
		reqType = /obj/items/wearable/orb/peace
		bonus   = 2
		chance  = 60
		prize   = /obj/items/wearable/orb/peace/greater

	magic_orb
		reqType = /obj/items/wearable/orb/magic
		bonus   = 3
		chance  = 60
		prize   = /obj/items/wearable/orb/magic/greater

	colors
		reqType = /obj/items/colors
		chance  = 55
		prize   = list(/obj/items/colors/red_stone    = 15,
		               /obj/items/colors/green_stone  = 15,
		               /obj/items/colors/blue_stone   = 15,
					   /obj/items/colors/yellow_stone = 15,
					   /obj/items/colors/purple_stone = 10,
					   /obj/items/colors/pink_stone   = 10,
					   /obj/items/colors/teal_stone   = 10,
		               /obj/items/colors/orange_stone = 10)


enchanting
	var
		reqType
		souls        = 0
		bonus        = 0
		chance       = 100
		prize

	proc
		check(obj/items/i, bonus, souls)
			if(istype(i, reqType) && (src.bonus & bonus) >= src.bonus && src.souls <= souls) return 1
			return 0

		getPrize()
			if(islist(prize)) return pickweight(prize)

			return prize

obj
	enchanter

		density = 1
		icon='Circle_magic.dmi'

		pixel_x = -65
		pixel_y = -64

		New()
			..()
			colors()

		Attacked(obj/projectile/p)
			enchant(p.owner)

		var
			tmp
				inUse       = FALSE
				bonusChance = 0
				applyBonus  = 0
				ignoreItem  = 0
			max_upgrade = 10

		proc
			colors()
				animate(src, color = "#cc2aa2", time = 10, loop = -1)
				animate(color = "#55f933", time = 10)
				animate(color = "#0aa2df", time = 10)

			showBonus()
				if(applyBonus & 2)
					emit(loc    = src,
						 ptype  = /obj/particle/green,
					     amount = 3,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))
				if(applyBonus & 1)
					emit(loc    = src,
						 ptype  = /obj/particle/red,
					     amount = 3,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))

			bigcolor(var/c)
				animate(src, transform = matrix()*1.75, color = "[c]",   alpha = 150, time = 2,  easing = LINEAR_EASING)
				animate(transform = null,               color = "white", alpha = 255, time = 10, easing = BOUNCE_EASING)

			getRecipe(obj/items/i, bonus, souls)
				for(var/t in typesof(/enchanting) - /enchanting)
					var/enchanting/e = new t

					if(e.check(i, bonus, souls))
						return e

			enchant(mob/Player/attacker)
				if(inUse) return
				inUse = TRUE
				spawn(13)
					inUse = FALSE
					colors()

				animate(src)
				sleep(1)

				var/const/DISTANCE = 3
				var/obj/items/artifact/i1 = locate() in locate(x+DISTANCE,y,z)
				var/obj/items/artifact/i2 = locate() in locate(x-DISTANCE,y,z)
				var/obj/items/i3 = locate() in locate(x,y+DISTANCE,z)
				var/obj/items/i4 = ignoreItem ? i3 : locate() in locate(x,y-DISTANCE,z)

				if(!i1 || !i2)
					bigcolor("red")
					return

				if(!i3 || !i4 || i3.type != i4.type)
					bigcolor("blue")
					if(i3) step_rand(i3)
					if(i4) step_rand(i4)
					return

				var/chance = 100
				var/enchanting/e = getRecipe(i3, applyBonus, ignoreItem)
				var/prize
				if(e)
					prize  = e.getPrize()
					chance = e.chance
				else if(istype(i3, /obj/items/wearable/))
					if(istype(i3, /obj/items/wearable/title) && i3.name == i4.name)
						chance -= 40
						prize = i3.type

						var/red   = rand(80,240)
						var/green = rand(80,240)
						var/blue  = rand(80,240)

						if(applyBonus & 1) red   = min(255, red   + 50)
						if(applyBonus & 2) green = min(255, green + 50)
						if(ignoreItem)     blue  = min(255, blue  + 50)

						i3.color = rgb(red, green, blue)

					else if(i3:bonus != -1 && i3:quality < max_upgrade && i3:quality == i4:quality && !(i3:bonus & 4))
						var/flags = applyBonus|i3:bonus|i4:bonus

						if(ignoreItem && ignoreItem < i3:quality + 1) flags = 0

						if(flags)
							i3:bonus = applyBonus|i3:bonus|i4:bonus
							prize = i3.type
							i3:quality++
							chance -= i3:quality * 20

				if(!prize)
					bigcolor("black")
					if(i3) step_rand(i3)
					if(i4 && !ignoreItem) step_rand(i4)
					return

				i1.Consume()
				i2.Consume()
				i3.Consume()
				i4.Consume()

				bigcolor("#f84b7a")

				if(attacker)
					attacker.checkQuestProgress("Enchant")
					attacker.Alchemy.add(rand(9,12)*200, attacker, 1)

				spawn(1)
					emit(loc    = src,
						 ptype  = /obj/particle/magic,
					     amount = 50,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))

				sleep(12)
				var/turf/t = locate(x+rand(-1,1),y+rand(-1,1),z)
				if(prob(chance + bonusChance))
					var/obj/items/o = new prize (t)
					o.owner = i3.owner

					if(istype(i3, /obj/items/wearable/title))
						o.name = i3.name
						o:title = copytext(i3.name, 8)
						o.color = i3.color
						o:title = "<span style=\"color:[o.color];\">" + o:title + "</span>"
					else if(istype(i3, /obj/items/wearable/orb))
						var/perc = ((i3:exp + i4:exp) / 2) / initial(i3:exp)
						perc *= o:exp
						o:exp = min(round(perc), o:exp)
					else if(istype(i3, /obj/items/wearable) && !(i3:bonus & 4))
						o:quality = i3:quality
						o:bonus   = i3:bonus
						o.name += " +[o:quality]"

				else
					new /obj/items/DarknessPowder (t)

				bonusChance = 0
				applyBonus  = 0
				ignoreItem  = 0


obj/items/crystal
	icon = 'Crystal.dmi'

	var
		bonus      = 0 // 1 for damage, 2 for defense, 3 for both
		luck       = 0 // bonus chance
		ignoreItem = FALSE// ignores fourth item

		Dmg = 0
		Def = 0
		monsterDmg = 0
		monsterDef = 0

	useTypeStack = 1
	stackName = "Crystals:"
	rarity = 2

	desc = "Drag and drop to item with a empty socket."

	proc/ToString()
		if(Dmg && Def) return "+[Dmg] Damage +[Def] Defense"
		if(Dmg) return "+[Dmg] Damage"
		if(Def) return "+[Def] Defense"
		if(luck) return "+[luck]% Drop Rate"
		if(monsterDmg && monsterDef) return "+[monsterDmg]% Damage +[monsterDef]% Defense"
		if(monsterDmg) return "+[monsterDmg]% Damage"
		if(monsterDef) return "+[monsterDef]% Defense"

	Clone()
		var/obj/items/crystal/i = new type

		i.owner      = owner
		i.name       = name
		i.icon_state = icon_state
		i.ignoreItem = ignoreItem
		i.luck       = luck
		i.Dmg        = Dmg
		i.Def        = Def
		i.monsterDmg = monsterDmg
		i.monsterDef = monsterDef

		return i

	Compare(obj/items/crystal/i)
		return i.name == name && i.type == type && i.owner == owner && i.icon_state == icon_state && i.ignoreItem == ignoreItem && i.luck == luck && i.Dmg == Dmg && i.Def == Def && i.monsterDmg == monsterDmg && i.monsterDef == monsterDef

	New(Loc, tier)
		..(Loc)

		if(tier)
			tier = min(tier, 20)

			if(prob(10))
				tier += rand(0, 5)

			name = "[name]: level [tier]"

			if(Dmg)
				Dmg = tier
			if(Def)
				Def = tier*3
			if(luck)
				luck = tier
			if(monsterDmg)
				monsterDmg = tier
			if(monsterDef)
				monsterDef = tier * 0.2

	MouseDrop(over_object)

		if(istype(over_object, /backpack))
			var/backpack/b = over_object
			over_object = b.item

		if(desc != null && istype(over_object, /obj/items/wearable) && (src in usr) && (over_object in usr) && over_object:socket != null)
			var/obj/items/wearable/w = over_object
			var/mob/Player/p = usr
			var/obj/items/crystal/s = stack > 1 ? Split(1) : src

			var/worn = 0
			if(w in p.Lwearing)
				worn = 1
				w.Equip(p, 1)

			var/addBack = 0
			if(w.stack > 1)
				addBack = 1
				w = w.Split(1)

			w.socket = s
			if(addBack)
				w.Move(p)
			if(worn)
				w.Equip(p, 1)

			if(s == src)
				Dispose()
			usr << infomsg("You insert [name] in [w.name]")
		else
			..()

	Click()
		if(src in usr)
			var/obj/enchanter/e = locate() in oview(2, usr)
			if(e)
				usr << errormsg("You hold [src.name] suddenly it disappears as it is absorbed within the magic circle.")
				e.applyBonus  |= bonus
				e.bonusChance += luck
				if(ignoreItem) e.ignoreItem++
				e.showBonus()
				Consume()
			else
				usr << errormsg("You hold [src.name] but nothing happens.")

		else
			..()
	damage
		name  = "red crystal"
		icon_state = "damage"
		bonus = 1
		Dmg = 10
	defense
		name  = "green crystal"
		icon_state = "defense"
		bonus = 2
		Def = 30
	damage_monster
		name  = "red monster crystal"
		icon_state = "damage"
		bonus = 1
		monsterDmg = 1
	defense_monster
		name  = "green monster crystal"
		icon_state = "defense"
		bonus = 2
		monsterDef = 1
	magic
		name  = "magic crystal"
		icon_state = "magic"
		bonus = 3
		Dmg = 10
		Def = 30
	luck
		name  = "luck crystal"
		icon_state = "luck"
		luck  = 5
	strong_luck
		name  = "strong luck crystal"
		icon_state = "luck2"
		luck  = 20
	soul
		name = "soul crystal"
		icon_state = "soul"
		luck = 5
		ignoreItem = TRUE
		rarity = 3
		desc = null


obj/blacksmith
	icon               = 'Anvil.dmi'

	mouse_over_pointer = MOUSE_HAND_POINTER
	mouse_opacity      = 2
	layer              = 4
	density            = 1

	var
		max_upgrade = 15

	Click()

		if(src in oview(3))
			var/mob/Player/p = usr

			var/obj/items/wearable/i = locate() in locate(x, y-1, z)

			if(i)

				if(i.bonus == -1 || i.quality >= max_upgrade || (i.bonus & 4))
					p << errormsg("[i.name] can not be upgraded.")
				else
					var/obj/items/ember_of_despair/despair = locate() in p
					var/obj/items/ember_of_frost/frost = locate() in p

					var/priceFactor

					if(i.quality >= 5)
						priceFactor = 2
					else if(i.quality >= 10)
						priceFactor = 3
					else
						priceFactor = 1

					var/price = i.quality*priceFactor + 2 + priceFactor

					var/cancel = 0
					if(!despair || despair.stack < price)
						p << errormsg("You need [price] embers of despair to upgrade [i.name]. You have [despair ? despair.stack : "0"].")
						cancel = 1

					if(!frost || frost.stack < price)
						p << errormsg("You need [price] embers of frost to upgrade [i.name]. You have [frost ? frost.stack : "0"].")
						cancel = 1

					if(cancel) return

					despair.Consume(price)
					frost.Consume(price)

					var/chanceToFail = (i.quality+1)*6 + 15

					if(i.quality >= 5 && prob(chanceToFail))
						p << infomsg("Failure! You could not upgrade [i.name]. ([100 - chanceToFail]%)")

						if(i.quality >= 10)
							i.quality--
							i.name = "[splittext(i.name, " +")[1]] +[i.quality]"
							i.UpdateDisplay()

							p << errormsg("Your item downgraded to [i.name].")
						return


					i.bonus |= 3
					i.quality++
					i.name = "[splittext(i.name, " +")[1]] +[i.quality]"
					i.UpdateDisplay()

					p << infomsg("Success! You crafted [i.name].")

					emit(loc    = src,
						 ptype  = /obj/particle/magic,
					     amount = 50,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))


			else if(i)
				step(i, pick(SOUTH, SOUTHEAST, SOUTHWEST, EAST, WEST))
			else
				p << errormsg("Place an item you wish to upgrade in the red square.")

