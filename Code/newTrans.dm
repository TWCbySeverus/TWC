obj
	Projectile_Trans
		icon='transfig.dmi'
		density = 1
		var/effect_


		Bump(atom/M)
			if(isobj(M)&&density==1)del src
			if(isturf(M)&&density==1)del src
			if(ismob(M))
				var/mob/C = M
				if(C.key)
					var/mob/Player/A = C
					if(effect_=="reverse")
						if(A.antifigura > 0)
							A.antifigura--
							src.owner << errormsg("Your spell failed, [A] is protected from transfiguring spells.")
							if(A.antifigura==0)
								A << errormsg("You were forced to release the shield around your body.")
								flick('transfigure.dmi',A)
								if(A.derobe)
									A.icon = 'Deatheater.dmi'
									if(A.key=="Ancient8")
										A.icon = 'HDE.dmi'
								else if(A.aurorrobe)
									A.trnsed = 0
									if(A.Gender == "Female")
										A.icon = 'FemaleAuror.dmi'
									else
										A.icon = 'MaleAuror.dmi'
								else
									A.icon = A.baseicon
									A:ApplyOverlays()
							if(src)del src
						else

							flick('transfigure.dmi',A)
							if(A.derobe)
								A.icon = 'Deatheater.dmi'
								if(A.key=="Ancient8")
									A.icon = 'HDE.dmi'
							else if(A.aurorrobe)
								A.trnsed = 0
								if(A.Gender == "Female")
									A.icon = 'FemaleAuror.dmi'
								else
									A.icon = 'MaleAuror.dmi'
							else
								A.icon = A.baseicon
								A:ApplyOverlays()
							if(src)del src
					else
						if(A.antifigura > 0)
							A.antifigura--
							src.owner << errormsg("Your spell failed, [A] is protected from transfiguring spells.")
							if(A.antifigura==0)
								A << errormsg("You were forced to release the shield around your body.")
								flick('transfigure.dmi',A)
								A.overlays = null
								A.icon = src.effect_
							if(src)del src
						else
							flick('transfigure.dmi',A)
							A.overlays = null
							A.icon = src.effect_
							if(src)del src
					if(src)del src
				else
					if(src)del src

mob/Spells/verb/Delicio()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Delicio.</b>"
		usr:learnSpell("Delicio")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Turkey.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A

mob/Spells/verb/Avifors()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=gray>[usr]</font>: <b>Avifors.</b>"
		usr:learnSpell("Avifors")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Bird.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A
mob/Spells/verb/Ribbitous()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b><font color=green> Ribbitous.</b></font>"
		usr:learnSpell("Ribbitous")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Frog.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A

mob/Spells/verb/Carrotosi()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b><font color=red> Carrotosi.</b></font>"
		usr:learnSpell("Carrotosi")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Rabbit.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A

mob/Spells/verb/Other_To_Human()
	set name = "Transfiguro Revertio"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b><font color=green> Transfiguro Revertio</b></font>"
		usr:learnSpell("Transfiguro Revertio")
		var/obj/Projectile_Trans/A = new
		A.effect_ = "reverse"
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A

mob/Spells/verb/Harvesto()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b> Harvesto.</b>"
		usr:learnSpell("Harvesto")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Onion.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A

mob/Spells/verb/Felinious()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b> Felinious.</b>"
		usr:learnSpell("Felinious")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'BlackCat.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A

mob/Spells/verb/Scurries()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Scurries.</b>"
		usr:learnSpell("Scurries")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Mouse.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A

mob/Spells/verb/Seatio()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Seatio.</b>"
		usr:learnSpell("Seatio")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Chair.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A

mob/Spells/verb/Nightus()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Nightus.</b>"
		usr:learnSpell("Nightus")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Bat.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A


mob/Spells/verb/Peskipixie_Pesternomae()
	set category="Spells"
	set name = "Peskipiksi Pestermi"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,5)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Peskipiksi Pestermi.</b>"
		usr:learnSpell("Peskipiksi Pestermi")
		var/obj/Projectile_Trans/A = new
		A.effect_ = 'Pixie.dmi'
		A.loc=(usr.loc)
		A.owner=usr
		walk(A,usr.dir,2)
		sleep(20)
		if(A)del A
