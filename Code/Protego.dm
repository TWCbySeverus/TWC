/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/GM
	verb
		Delete(S as turf|obj|mob in view(17))
			set category = "Staff"
			if(clanrobed())return
			if(isturf(S))
				var/turf/D = S
				if(D.phaseblock==1)
					usr<<"You cant delete that block"
					return 0
			if(isplayer(S))
				switch(alert("Deleting Player: [S]","Are you sure you want to delete [S]?","Yes","No"))
					if("No")
						return
			del S

mob/var/tmp/phaseblock=0
obj/var/tmp/phaseblock=0

obj/Shield
	icon='teleport2.dmi'
	icon_state = "shield"
	layer = 5
	density = 1

mob/var/shielded
mob/var/prevname = ""
mob/var/shieldamount