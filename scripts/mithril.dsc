mithril:
    debug: false
    type: item
    material: i@IRON_INGOT
    display name: <aqua>Mithril Ingot
    mechanisms:
        flags: HIDE_ATTRIBUTES|HIDE_ENCHANTS
    lore:
    - <gold> Um metal leve, gracioso e resistente

    enchantments:
    - DURABILITY:10
    recipes:
        1:
           # The type can be: shaped, shapeless, stonecutting, furnace, blast, smoker, or campfire.
           type: shaped
           input:
           - i@IRON_INGOT|i@IRON_INGOT|i@IRON_INGOT
           - i@IRON_INGOT|i@DIAMOND|i@IRON_INGOT
           - i@IRON_INGOT|i@IRON_INGOT|i@IRON_INGOT