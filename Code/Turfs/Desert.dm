obj/Cactus
	icon = 'cactus.dmi'

	Top
		icon_state = "top"
		layer = MOB_LAYER+1
	Bottom
		icon_state = "bottom"
		density = 1



area
	Desert
		ToDesertfromHogs
			Entered(mob/M)
				if(M.key)
					M.Move(locate(15,43,4))
					M.loc = locate(15,43,4)
		BacktoHogsfromDesert
			Entered(mob/M)
				if(M.key)
					M.Move(locate(62,82,22))
					M.loc = locate(62,82,22)
