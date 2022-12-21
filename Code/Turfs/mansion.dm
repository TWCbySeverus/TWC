turf
	mansion
		Dungeon
			Entered(mob/M)
				if(M.key)
					M.loc = locate(36,19,17)
					M.Move(locate(36,19,17))
		BackToGodrics
			Entered(mob/M)
				if(M.key)
					M.loc = locate(73,74,17)
					M.Move(locate(73,74,17))
		Levelo
			Entered(mob/M)
				if(M.key)
					M.loc = locate(59,9,17)
					M.Move(locate(59,9,17))
		Leveloback
			Entered(mob/M)
				if(M.key)
					M.loc = locate(98,5,17)
					M.Move(locate(98,5,17))
		Level1
			Entered(mob/M)
				if(M.key)
					M.loc = locate(89,4,19)
					M.Move(locate(89,4,19))

obj/mansion/Rotem_Portrait
	icon = 'RotemPortrait.dmi'
	density = 1