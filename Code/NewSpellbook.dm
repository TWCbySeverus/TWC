/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/proc/spellbook_s()
	var/count=1
	winset(usr,"winspells.sgrid",null)
	usr<<output("<b> Spells </b>","sgrid:1,1")
	winshow(usr,"winspells",1)
	for(var/I in usr.verbs)
		if(findtext("[I]","/mob/Spells/verb/")&&!(findtext("[I]","Eat_Slugs"))&&!(findtext("[I]","Ecliptica"))&&!(findtext("[I]","Herbificus_Maxima"))&&!(findtext("[I]","Basilio"))&&!(findtext("[I]","Shelleh"))&&!(findtext("[I]","Imperio")))
			var/obj/spell = I
			var/spell_name = dd_replacetext(spell.name," ","-")
			usr<<output({"<a href='?src=\ref[src];action=use_spell;spell=[spell_name]'>[spell.name]</a>"},"sgrid:1,[++count]")

mob/verb/Spells_Book()
	usr.spellbook_s()

mob/Topic(href,href_list[])
	..()
	switch(href_list["action"])
		if("use_spell")
			var/spell = href_list["spell"]
			//spell = dd_replacetext("[aspell]","-"," ")
			var/text = {"
					<style>
					a,a:link,a:hover{
						color:white;
						text-decoration:none;
					}
					a:hover{
						color:#80dfff;
					}
					body{
						background-color:#333;
						color:white;
					}
					</style>
			"}
			text += get_spell_info(spell)
			usr<<browse(text,"window=winspells.spelbr")

		//	winset(src,null,"winspells.spelbr.text=[text]")
/*

mob/Topic(href,href_list[])
	..()
	switch(href_list["action"])
		if("use_spell")
			var/spell = href_list["spell"]
			winset(src, null, "command=[spell]")




mob/verb/open_bag()
	var/count = 1
	usr<<output("<b> Items </b>","lpellgrid:1,1")
	usr<<output("<b> Status </b>","lspellgrid:2,1")
	for(var/obj/I in contents)
		usr << output(I, "lgrid:1,[++count]")
		usr << output(I.suffix, "lgrid:2,[count]")*/