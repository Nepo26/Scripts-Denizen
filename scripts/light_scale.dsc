light_scale:
    debug: false
    type: item
    material: i@PRISMARINE_SHARD
    display name: <dark_blue>Light Scale Shards
    mechanisms:
        flags: HIDE_ATTRIBUTES|HIDE_ENCHANTS
    lore:
    - <gold> Escamas feitas nas mais profundas aguas

    enchantments:
    - DURABILITY: 10
    recipes:
        1:
           # The type can be: shaped, shapeless, stonecutting, furnace, blast, smoker, or campfire.
           type: shaped
           input:
           - i@PRISMARINE_CRYSTALS|i@IRON_INGOT|i@PRISMARINE_CRYSTALS
           - i@IRON_INGOT|i@DIAMOND|i@IRON_INGOT
           - i@PRISMARINE_CRYSTALS|i@IRON_INGOT|i@PRISMARINE_CRYSTALS
		   
light_scale_trident:
    debug: false
    type: item
    material: i@TRIDENT
    display name: <dark_blue>Light Scale Trident
    mechanisms:
        flags: HIDE_ATTRIBUTES|HIDE_ENCHANTS
    lore:
    - <gold> A arma criada pelos Zoras para combate aquático

    enchantments:
    - DURABILITY: 10
	- DAMAGE_ALL: 10
	- LOYALTY
	- IMPALING: 10
	- SWEEPING_EDGE: 4
    recipes:
        1:
           # The type can be: shaped, shapeless, stonecutting, furnace, blast, smoker, or campfire.
           type: shaped
           input:
           - i@AIR|i@QUARTZ|i@QUARTZ
           - i@AIR|i@light_scale|i@QUARTZ
           - i@light_scale|i@AIR|i@AIR
		   