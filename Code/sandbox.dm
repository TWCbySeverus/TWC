
WorldData
	var/tmp
		sandboxZ

proc
	InitSandbox(attempts=3)
		set waitfor = 0
		var/swapmap/map = SwapMaps_Load("custom_buildable")
		if(!map)
			if(attempts > 0)
				spawn(10)
					lagstopsleep()
					InitSandbox(attempts-1)
			return

		worldData.sandboxZ = map.z1

		spawnTrees()

	spawnTrees()
		set waitfor = 0
		sleep(100)
		for(var/i = 1 to 30)
			var/x = rand(10, 90)
			var/y = rand(10, 90)

			var/turf/t = locate(x, y, worldData.sandboxZ)

			#if WINTER
			if(t.icon_state == "snow")
			#else
			if(t.icon_state == "grass1")
			#endif
				new /obj/farm/tree (t)

			lagstopsleep()

obj
	farm
		appearance_flags = PIXEL_SCALE|TILE_BOUND
		canSave = 0

		tree
			name       = "Tree"
			icon       = 'BigTree.dmi'
			density    = 1
			pixel_x    = -64
			pixel_y    = 0
			layer      = 5

			var
				hp    = 20000
				maxhp = 20000
				obj/healthbar/hpbar

			New()
				icon_state = "stump[rand(2,3)]_winter"

				..()

			proc/respawn()
				set waitfor = 0

				sleep(600)
				density    = 1
				pixel_x = -64
				pixel_y = 0
				layer   = 5
				transform = null

				for(var/i = 1 to 10)
					var/x = rand(10, 90)
					var/y = rand(10, 90)

					var/turf/t = locate(x, y, worldData.sandboxZ)

					#if WINTER
					if(t.icon_state == "snow")
					#else
					if(t.icon_state == "grass1")
					#endif
						loc = t
						hpbar.loc = t
						hpbar.Set(1, instant=1)
						hpbar.alpha = 0
						animate(src, alpha = 255, time = 10)
						break
				if(!loc)
					hpbar.loc = null
					hpbar = null

			Attacked(obj/projectile/p)
				set waitfor = 0
				if(!density) return

				hp -= p.damage

				var/perc = hp / maxhp

				if(!hpbar)
					hpbar = new(src)
					hpbar.alpha = 0

				hpbar.Set(perc)

				if(hp <= 0)
					layer = 2
					var/obj/items/wood_log/w = new(loc)
					w.stack = rand(1,9)
					w.UpdateDisplay()
					w.pixel_y = 64
					w.transform = turn(matrix(), 90 * pick(1, -1))
					animate(w, pixel_y = 0, transform = null, time = 20, easing = BOUNCE_EASING)


					var/matrix/m = transform
					if(prob(50))
						m.Turn(-90)
						animate(src, pixel_x = -128, pixel_y = -64, transform = m, time = 50, easing = BOUNCE_EASING)
					else
						m.Turn(90)
						animate(src, pixel_x = 0, pixel_y = -64, transform = m, time = 50, easing = BOUNCE_EASING)
					density = 0
					sleep(51)
					animate(hpbar, alpha = 0, time = 5)
					sleep(6)
					hpbar.loc = null
					sleep(50)
					animate(src, alpha = 0, time = 10)
					sleep(11)
					loc = null
					respawn()

				else
					animate(src, pixel_x = pixel_x-1, time = 1)
					animate(pixel_x = pixel_x+1, time = 2)
					animate(pixel_x = pixel_x, time = 1)


obj/items
	wood_log
		icon = 'Wood Log.dmi'
		icon_state = "log1"


	wearable/blueprint
		icon = 'blueprint.dmi'
		showoverlay = FALSE
		dropable = 0

		var/buildType

		basic_blueprint
			buildType = /hudobj/build/basic

		portkey_blueprint
			buildType = /hudobj/build/portkey

		Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
			if(!overridetext && !forceremove && !(src in owner.Lwearing) && !istype(owner.loc, /turf/buildable))
				owner << errormsg("You can't use this here.")
				return
			. = ..(owner)
			if(forceremove) return
			if(. == WORN)
				src.gender = owner.gender
				if(!overridetext)viewers(owner) << infomsg("[owner] looks at \his [src.name].")
				for(var/obj/items/wearable/blueprint/W in owner.Lwearing)
					if(W != src)
						W.Equip(owner,1,1)


				for(var/t in (typesof(buildType)-buildType+typesof(/hudobj/build/shared)-/hudobj/build/shared))
					var/obj/o = new t (null, owner.client, null, 1)

					o.maptext = {"<span style=\"color:[owner.mapTextColor]\">[o.maptext]</span>"}

			else if(. == REMOVED)
				if(!overridetext)viewers(owner) << infomsg("[owner] puts away \his [src.name].")

				for(var/hudobj/build/b in owner.client.screen)
					owner.client.screen -= b

				if(owner.buildItemDisplay)
					owner.buildItemDisplay.loc.mouse_opacity = 1
					owner.buildItemDisplay.loc = null
					owner.buildItemDisplay = null

turf/buildable
	icon = 'turf.dmi'

	#if WINTER
	name       = "snow"
	icon_state = "snow"
	#else
	name       = "grass"
	icon_state = "grass1"
	#endif

	Exited(atom/movable/Obj, atom/newloc)
		..()

		if(isplayer(Obj) && !istype(newloc, /turf/buildable))
			var/obj/items/wearable/blueprint/W = locate() in Obj:Lwearing
			if(W)
				W.Equip(Obj,1)


	MouseEntered()
		var/mob/Player/p = usr
		if(p.buildItemDisplay)
			if(z == p.z && get_dist(src, p) < 30)
				p.buildItemDisplay.loc = src
				var/obj/buildable/shield_totem/c = locate() in range(20, src)
				if(!c || !c.allowed || (usr.ckey in c.allowed))
					p.buildItemDisplay.loc = src
					p.buildItemDisplay.color = "#0f0"
				else
					p.buildItemDisplay.color = "#f00"
			else
				p.buildItemDisplay.loc = null

	Click()
		var/mob/Player/p = usr
		if(p.buildItemDisplay && z == p.z && get_dist(src, p) < 30)
			var/obj/buildable/shield_totem/c = locate() in range(20, src)
			if(!c || !c.allowed || (usr.ckey in c.allowed))


				if(p.buildItem.price > 0)
					var/obj/items/wood_log/w = locate() in p

					if(!w || w.stack < p.buildItem.price)
						p << errormsg("You don't have enough wood.")
						return

					w.Consume(p.buildItem.price)

				if(p.buildItem.path)
					if(!flyblock && !(locate(p.buildItem.path) in src))
						Clear()
						new p.buildItem.path(src)

						spawn(2)
							if(flyblock)
								for(var/obj/buildable/wall/w in orange(1, src))
									w.updateState()

				else if(p.buildItem.name == "clear")
					Clear()
				else
					name = p.buildItem.name
					if(p.buildItem.icon_state == "wood")
						icon_state = "wood[rand(1,8)]"
					else
						icon_state = p.buildItem.icon_state
					color = p.buildItem.color

		else
			..()

	proc
		Clear()
			for(var/obj/o in src)
				if(!o.canSave) continue
				if(istype(o, /obj/items)) continue
				if(istype(o, /obj/buildable)) continue
				o.Dispose()

/*	post_init = 1  // in case GMs use delete on walls
	MapInit()
		set waitfor = 0
		sleep(1)

		if(flyblock)
			var/obj/o = locate() in src
			if(!o || !o.density)
				flyblock = 0*/

mob/Player/var/tmp
	hudobj/build/buildItem
	obj/buildItemDisplay

obj/buildable
	var
		hp    = 50000
		maxhp = 50000
		tmp/obj/healthbar/hpbar

	density = 1

	New()
		set waitfor = 0
		sleep(1)
		if(density && opacity)
			var/turf/t = loc
			t.flyblock = 2

		var/perc = hp / maxhp
		if(perc < 1 && icon_state != "15")
			hpbar = new(src)
			hpbar.Set(perc)

		..()

	Dispose()
		if(opacity)
			var/turf/t = loc
			t.flyblock = 0
		hpbar.loc = null
		hpbar = null
		..()

	Attacked(obj/projectile/p)
		set waitfor = 0
		if(!density) return

		if(p.element == EARTH)
			hp += p.damage
			if(hp > maxhp)
				hp = maxhp
		else
			hp -= p.damage

		var/perc = hp / maxhp

		if(!hpbar)
			hpbar = new(src)
			hpbar.alpha = 0

		hpbar.Set(perc)

		if(perc == 1 && hpbar.alpha == 255)
			animate(hpbar, alpha = 0, time = 5)

		else if(hp <= 0)
			density = 0
			animate(hpbar, alpha = 0, time = 5)
			animate(src, alpha = 0, transform = matrix()*2, time = 5)
			sleep(6)
			Dispose()
		else
			animate(src, pixel_x = pixel_x-1, time = 1)
			animate(pixel_x = pixel_x+1, time = 2)
			animate(pixel_x = pixel_x, time = 1)

	wall
		opacity = 1
		wood
			icon = 'wood_wall.dmi'
			icon_state = "10"

		New()
			set waitfor = 0
			..()
			sleep(2)

			updateState()

		proc/updateState()
			var/turf/t = loc
			var/n = t.autojoin1("flyblock", 2)
			icon_state = "[n]"

		Dispose()
			var/turf/t = loc
			..()
			for(var/obj/buildable/wall/w in orange(1, t))
				w.updateState()


	door
		wood
			icon='Door.dmi'
			icon_state="closed"

		opacity=1

		var/door = 1

		proc/Bumped(mob/Player/p)

			var/obj/buildable/shield_totem/c = locate() in range(20, src)
			if(c && c.allowed && !(p.ckey in c.allowed)) return

			if(icon_state != "open")
				flick("opening", src)
				opacity = 0
				sleep(4)
				icon_state="open"
				density=0
				sleep(50)
				while(locate(/mob) in loc) sleep(10)
				flick("closing", src)
				density=1
				sleep(4)
				opacity = initial(opacity)
				icon_state="closed"

		Dispose()
			var/turf/t = loc
			..()
			for(var/obj/buildable/wall/w in orange(1, t))
				w.updateState()

		New()
			set waitfor = 0
			..()
			sleep(2)
			density    = 1
			icon_state = "closed"
			opacity    = 1

	shield_totem
		var/list/allowed

		mouse_over_pointer = MOUSE_HAND_POINTER
		icon = 'Totem.dmi'
		icon_state = "Shield"

		Click()
			if(src in range(1))
				if(!IsInputOpen(usr, "BuildProtection"))
					var/Input/popup = new (usr, "BuildProtection")
					var/response = popup.Alert(usr, "Add yourself or clean the access list?", "Build Protection", "Add", "Clean")
					del popup
					if(response == "Add")
						if(!allowed)
							allowed = list()
						else if(usr.ckey in allowed)
							return

						allowed += usr.ckey
						usr << infomsg("You were added to the build list.")
					else
						allowed = null
						usr << infomsg("You cleaned the build list.")


			else
				..()
	Bed
		icon       = 'turf.dmi'
		icon_state = "Bed"

		Click()
			if(src in range(1))
				if(tag == "respawn_" + usr.ckey)
					usr << errormsg("You will no longer respawn here.")
				else
					var/obj/o = locate("respawn_" + usr.ckey)
					if(o)
						o.tag = null
						usr << errormsg("Your previous bed is replaced by this one.")

					tag = "respawn_" + usr.ckey
					usr << infomsg("You can now respawn here. Click \"Respawn at bed\" on death screen.")
			else
				..()

obj/preview

	Click()
		var/turf/t = loc
		t.Click()

hudobj
	respawn
		anchor_x    = "CENTER"
		anchor_y    = "CENTER"
		screen_y    = 64

		maptext        = "<center><span style=\"color:#e50000;\">Respawn at bed</span></center>"
		maptext_height = 128
		alpha          = 0
		plane          = 2
		mouse_opacity  = 2

		Click()
			var/mob/Player/p = usr
			var/turf/d = locate("respawn_" + p.ckey)
			if(d)
				p.Transfer(d)

			hide()
	build
		anchor_x    = "WEST"
		anchor_y    = "CENTER"

		maptext_y = 8
		maptext_x = 34
		maptext_width = 256

		var
			path
			price = 0

		Click()
			var/mob/Player/M = usr

			if(M.buildItemDisplay)
				M.buildItemDisplay.loc = null

			var/obj/preview/o = new
			o.appearance = appearance
			o.color = "#0f0"
			o.mouse_opacity = 2
			o.maptext = null
			o.canSave = 0
			o.mouse_over_pointer = 0

			M.buildItem = src
			M.buildItemDisplay = o

		shared
			guide
				maptext = "Click on the item you'd like to create then click to place where the green highlighted preview is."
				maptext_width  = 256
				maptext_height = 64
				screen_x       = 32
				screen_y       = -32

				Click()

			clear
				icon = 'HUD.DMI'
				icon_state = "obsself"
				maptext = "Clear Decoration/Portkeys"

				screen_x = 32
				screen_y = 32

			#if WINTER
			snow
				icon_state = "snow"
				maptext = "Snow: free"
			#else
			grass
				icon_state = "grass1"
				maptext = "Grass: free"
			#endif
				icon = 'turf.dmi'

				screen_x = 32
				screen_y = 256
		basic
			chairleft
				icon       = 'desk.dmi'
				icon_state = "cleft"

				price = 1
				path = /obj/chairleft

				screen_x = 32
				screen_y = 64

			chairright
				icon       = 'desk.dmi'
				icon_state = "cright"

				price = 1
				path = /obj/chairright

				screen_x = 64
				screen_y = 64

			chairback
				icon       = 'desk.dmi'
				icon_state = "cback"
				layer      = MOB_LAYER +1

				price = 1
				path = /obj/chairback

				screen_x = 96
				screen_y = 64

			chairfront
				icon       ='desk.dmi'
				icon_state = "cfront"

				price = 1
				path = /obj/chairfront

				screen_x = 128
				screen_y = 64

			WTable
				icon       ='stage.dmi'
				icon_state = "w"

				price = 1
				maptext = "Decoration: 1 wooden logs"
				path = /obj/WTable

				screen_x = 160
				screen_y = 64

			Bed
				icon       = 'turf.dmi'
				icon_state = "Bed"

				price = 5
				maptext = "Bed: 5 wooden logs"
				path = /obj/buildable/Bed

				screen_x = 32
				screen_y = 96

			shield_totem
				icon = 'Totem.dmi'
				icon_state = "Shield"

				price = 10
				maptext = "Shield Totem: 10 wooden logs"

				screen_x = 32
				screen_y = 128

				path = /obj/buildable/shield_totem

			door
				icon='Door.dmi'
				icon_state="closed"

				price = 10
				maptext = "Door: 10 wooden logs"

				screen_x = 32
				screen_y = 160

				path = /obj/buildable/door/wood

			wood_wall
				icon = 'wood_wall.dmi'
				icon_state = "10"

				price = 5
				maptext = "Wood Wall: 5 wooden logs"

				screen_x = 32
				screen_y = 192

				path = /obj/buildable/wall/wood

			woodenfloor
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#704f32"

				price = 1
				maptext = "Wood Floor: 1 wooden logs"

				screen_x = 32
				screen_y = 224

		portkey
			icon='portal.dmi'
			icon_state="portkey"

			Hogwarts
				price = 1
				maptext = "Hogwarts: 1 wooden logs"

				screen_x = 32
				screen_y = 224

				path = /obj/teleport/portkey { dest = "@Hogwarts"}

			Courtyard

				price = 1
				maptext = "Courtyard: 1 wooden logs"

				screen_x = 32
				screen_y = 192

				path = /obj/teleport/portkey { dest = "@Courtyard"}

