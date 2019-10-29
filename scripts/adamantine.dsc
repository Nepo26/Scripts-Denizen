adamantine:
    debug: false
    type: item
    material: i@FLINT
    mechanisms:
        flags: HIDE_ATTRIBUTES|HIDE_ENCHANTS
    display name: <dark_purple>Adamantine

    lore:
    - <gold> Um metal forjado na mais quente das lavas

    enchantments:
    - DURABILITY:10
    recipes:
        1:
           # The type can be: shaped, shapeless, stonecutting, furnace, blast, smoker, or campfire.
           type: shaped
           input:
           - i@AIR|i@OBSIDIAN|i@AIR
           - i@OBSIDIAN|i@IRON_INGOT|i@OBSIDIAN
           - i@AIR|i@OBSIDIAN|i@AIR