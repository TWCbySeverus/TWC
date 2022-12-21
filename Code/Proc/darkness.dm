area
	darkness
		luminosity=0
		rotem_dungeon_no_mobs
			var/tmp/active=0
			plane=10
			icon='dark.dmi'
		rotem_dungeon
			var/tmp/active=0
			plane=10
			icon='dark.dmi'
			Entered(atom/movable/O)
				. = ..()
				if(isplayer(O))
					active = 1
					for(var/mob/NPC/Enemies/M in src)
						if(M.state == M.WANDER)
							M.state = M.SEARCH


			Exit(atom/movable/O)
				.=..()
				if(istype(O, /mob/NPC) && !O:removeoMob) return 0

			Exited(atom/movable/O)
				. = ..()
				if(isplayer(O))
					var/isempty = 1
					for(var/mob/Player/M in src)
						if(M != O)
							isempty = 0
							break
					if(isempty)
						active = 0
						for(var/mob/NPC/Enemies/M in src)
							M.state = M.WANDER
obj/light
	name=""
	plane = 1
	blend_mode = BLEND_ADD
	icon = 'spotlight.dmi'
	dragandrop=0
	pixel_x = -64
	pixel_y = -64

	canSave = FALSE

obj/light_max
	name=""
	plane = 1
	blend_mode = BLEND_ADD
	icon = 'spotlight.dmi'
	dragandrop=0
	pixel_x = -64
	pixel_y = -64
	luminosity=5
	canSave = FALSE



