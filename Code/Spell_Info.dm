
proc/get_spell_info(spell)
	switch(spell)
		if("Inflamari")
			return {"<b><center>[spell]</b>
			<br>It's a firey attacking spell
			"}
		if("Scan")
			return {"
			<b><center>[spell]</b>
			<br>It's a charm that allows you to check on
			<br>people stats such as:
			<br>-Health Points
			<br>-Mana Points
			"}
		if("Wingardium-Leviosa")
			return {"
			<b><center>Wingardium Leviosa</b>
			<br>This charm enables you to levitate and move items
			"}
		if("Lumos-Maxima")
			return {"
			<b><center>Lumos Maxima</b><br>
			An extension of the ordinary spell, this charm can brighten up entire areas
			"}
		if("Avada-Kedavra")
			return {"
			<b><center>Avada Kedavra</b><br>
			A sharp green light ejects from your wand, killing the target
			"}
		if("Arania-Exumai")
			return {"
			<b><center>Arania Exumai</b><br>
			Exterminates spiders within your view
			"}
		if("Peskipiksi-Pestermi")
			return {"
			<b><center>Peskipiksi Pestermi</b><br>
			Casts the target in to a Pixie
			"}
		if("Personio-Humaium")
			return {"
			<b><center>Transfiguro Humaium</b><br>
			Transfigures the caster back to human form
			"}
		if("Transfiguro-Revertio")
			return {"
			<b><center>Transfiguro Revertio</b><br>
			Transfigures the target back to human form
			"}
		if("Personio-Sceletus")
			return {"
			<b><center>Personio Sceletus</b><br>
			Transfigures the caster in to a skeleton
			"}
		if("Personio-Musashi")
			return {"
			<b><center>Personio Musashi</b><br>
			Transfigures the caster in to a mushroom
			"}
		if("Personio-Draconum")
			return {"
			<b><center>Personio Draconum</b><br>
			Transfigures the caster in to a dragon
			"}
		if("Petrificus-Totalus")
			return {"
			<b><center>Petrificus Totalus</b><br>
			Freezes the target
			"}
		if("Eparo-Evanesca")
			return {"
			<b><center>Eparo Evanseca</b><br>
			Reveals invisible witches or wizards in view
			"}
		if("Expecto-Patronum")
			return {"
			<b><center>Expecto Patronum</b><br>
			Exterminates dementors in view
			"}
		if("Sense")
			return {"
			<b><center>[spell]</b><br>
			Informs the caster of the target's kills and deaths
			"}
		if("Portus")
			return {"
			<b><center>[spell]</b><br>
			Creates a porkey to a determined location
			"}
		if("Episkey")
			return {"
			<b><center>[spell]</b><br>
			Restores full health to the caster
			"}
		if("Crucio")
			return {"
			<b><center>[spell]</b><br>
			Causes infrequent damage to the target
			"}
		if("Confundus")
			return {"
			<b><center>[spell]</b><br>
			Causes the target to move in the opposite direction
			"}
		if("Nox")
			return {"
			<b><center>[spell]</b><br>
			Darkens an area that is brightly lit
			"}
		if("Lumos")
			return {"
			<b><center>[spell]</b><br>
			Brightens an area that is dark
			"}
		if("Telendevour")
			return {"
			<b><center>[spell]</b><br>
			Enables the caster to spy on a target
			"}
		if("Nightus")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to a bat
			"}
		if("Seatio")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to a chair
			"}
		if("Scurries")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to a mouse
			"}
		if("Felinious")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to a cat
			"}
		if("Harvesto")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to an onion
			"}
		if("Carrotosi")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to a rabbit
			"}
		if("Ribbitous")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to a frog
			"}
		if("Avifors")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to a crow
			"}
		if("Delicio")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to a turkey
			"}
		if("Riddikulus")
			return {"
			<b><center>[spell]</b><br>
			Transfigures the target in to the opposite gender
			"}
		if("Incendio")
			return {"
			<b><center>[spell]</b><br>
			Burns a nest of summoned roses
			"}
		if("Impedimenta")
			return {"
			<b><center>[spell]</b><br>
			Causes a delay in movement to witches and wizards within view
			"}
		if("Immobulus")
			return {"
			<b><center>[spell]</b><br>
			Immobilises the target
			"}
		if("Tarantallegra")
			return {"
			<b><center>[spell]</b><br>
			Causes the target to dance uncontrollably
			"}
		if("Obliviate")
			return {"
			<b><center>[spell]</b><br>
			Erases the chat log of the target
			"}
		if("Levicorpus")
			return {"
			<b><center>[spell]</b><br>
			Briefly immobilises the target, causing them to drop scrolls
			"}
		if("Occlumency")
			return {"
			<b><center>[spell]</b><br>
			Prevents the caster from being spied on or read into
			"}
		if("Replacio")
			return {"
			<b><center>[spell]</b><br>
			Replaces the caster's position with the target
			"}
		if("Incindia")
			return {"
			<b><center>[spell]</b><br>
			Causes an explosion of projectiles in all directions
			<br>Spell Level : [usr.incindia_level]  <a href='?src=\ref[usr];action=upgrade_incindia'>Upgrade</a>
			"}
		if("Muffliato")
			return {"
			<b><center>[spell]</b><br>
			Causes the target to not hear anything for a brief time
			"}
		if("Langlock")
			return {"
			<b><center>[spell]</b><br>
			Prevents the target from speaking for a brief time
			"}
		if("Flagrate")
			return {"
			<b><center>[spell]</b><br>
			Causes the caster to speak in an impacted font
			"}
		if("Arcesso")
			return {"
			<b><center>[spell]</b><br>
			Two casters can summon a target
			"}
		if("Furnunculus")
			return {"
			<b><center>[spell]</b><br>
			Causes pimples and pain to the target
			"}
		if("Tremorio")
			return {"
			<b><center>[spell]</b><br>
			An attacking earthquake projectile
			<br>Spell Level : [usr.tremorio_level] <a href='?src=\ref[usr];action=upgrade_tremorio'>Upgrade</a>
			"}
		if("Waddiwasi")
			return {"
			<b><center>[spell]</b><br>
			An attacking gum projectile
			<br>Spell Level : [usr.waddiwasi_level] <a href='?src=\ref[usr];action=upgrade_waddiwasi'>Upgrade</a>
			"}
		if("Glacius")
			return {"
			<b><center>[spell]</b><br>
			An attacking ice projectile
			<br>Spell Level : [usr.glacius_level] <a href='?src=\ref[usr];action=upgrade_glacius'>Upgrade</a>
			"}
		if("Aqua-Eructo")
			return {"
			<b><center>Aqua Eructo</b><br>
			An attacking tsunami projectile
			<br>Spell Level : [usr.aqua_level] <a href='?src=\ref[usr];action=upgrade_aqua'>Upgrade</a>
			"}
		if("Chaotica")
			return {"
			<b><center>[spell]</b><br>
			An attacking dark energy projectile
			"}
		if("Antifigura")
			return {"
			<b><center>[spell]</b><br>
			Prevents the target from being transfigured
			"}
		if("Rictusempra")
			return {"
			<b><center>[spell]</b><br>
			Tickles the target and causes them to laugh hysterically
			"}
		if("Bombarda")
			return {"
			<b><center>[spell]</b><br>
			Destroys cauldrons and smaller objects
			"}
		if("Reparo")
			return {"
			<b><center>[spell]</b><br>
			Repairs cauldrons and smaller objects
			"}
		if("Reducto")
			return {"
			<b><center>[spell]</b><br>
			Frees the caster from a frozen or immobilized state
			"}
		if("Anapneo")
			return {"
			<b><center>[spell]</b><br>
			Frees the caster from preventative sensing charms
			"}
		if("Incarcerous")
			return {"
			<b><center>[spell]</b><br>
			Incarcerates the target
			"}
		if("Melofors")
			return {"
			<b><center>[spell]</b><br>
			Causes a pumpkin to land on the target's head, blinding them for a brief time
			"}
		if("Conjunctivis")
			return {"
			<b><center>[spell]</b><br>
			Causes conjunctivitis and blinds the target
			"}
		if("Dementia")
			return {"
			<b><center>[spell]</b><br>
			Summons a dementor from the caster's wand
			"}
		if("Permoveo")
			return {"
			<b><center>[spell]</b><br>
			Enables the caster to take control of monsters
			"}
		if("Flippendo")
			return {"
			<b><center>[spell]</b><br>
			A projectile spell which pushes the target (or other projectiles) in different directions
			"}
		if("Accio")
			return {"
			<b><center>[spell]</b><br>
			A summoning charm
			"}
		if("Disperse")
			return {"
			<b><center>[spell]</b><br>
			Dissolves an array of obstacles
			"}
		if("Herbificus")
			return {"
			<b><center>[spell]</b><br>
			Summons a bush of roses from the caster's wand
			"}
		if("Protego")
			return {"
			<b><center>[spell]</b><br>
			Briefly provides a shield to the caster from attacking projectile spells
			"}
		if("Valorus")
			return {"
			<b><center>[spell]</b><br>
			Prevents the target from following the caster, or knocks the target from their broom
			"}
		if("Depulso")
			return {"
			<b><center>[spell]</b><br>
			A rejection charm which can push the target in a different direction
			"}
		if("Deletrius")
			return {"
			<b><center>[spell]</b><br>
			Deletes all roses within the view of the caster
			"}
		if("Expelliarmus")
			return {"
			<b><center>[spell]</b><br>
			Disarms the target and prevents them from using their wand
			"}
		if("Evanesco")
			return {"
			<b><center>[spell]</b><br>
			The caster can hide a target and turn them invisible
			"}
		if("Imitatus")
			return {"
			<b><center>[spell]</b><br>
			Enables the caster to mimic the target
			"}
		if("Densaugeo")
			return {"
			<b><center>[spell]</b><br>
			Causes the target pain by enlarging their teeth
			"}
		if("Anteoculatia")
			return {"
			<b><center>[spell]</b><br>
			Causes antlers to painfully burst through the target's skull
			"}
		if("Morsmordre")
			return {"
			<b><center>[spell]</b><br>
			The caster summons a sneering skull with a snake in its eyes in the sky
			"}
		if("Repellium")
			return {"
			<b><center>[spell]</b><br>
			Enables the caster to eliminate snakes in their view
			"}
		if("Solidus")
			return {"
			<b><center>[spell]</b><br>
			Conjures a solid block for a brief time
			"}
		if("Serpensortia")
			return {"
			<b><center>[spell]</b><br>
			Summons a snake from the caster's wand
			"}
		if("Ferula")
			return {"
			<b><center>[spell]</b><br>
			Summons Madame Pomphrey from the caster's wand
			"}
		if("Alohomora")
			return {"
			<b><center>[spell]</b><br>
			Enables the caster to unlock all doors in view
			"}
		if("Colloportus")
			return {"
			<b><center>[spell]</b><br>
			Enables the caster to lock all doors in view
			"}
		if("Avis")
			return {"
			<b><center>[spell]</b><br>
			Summons a bird which can heal the caster
			"}