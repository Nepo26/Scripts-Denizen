pescado_profundo:
    debug: false
    type: item
    material: i@SALMON
    display name: <green>Pescado Profundo <gold>(<blue>1 LP<gold>)

    lore:
    - <gold> Salmão envolto de algas secas
    
    enchantments:
    - DURABILITY:2
    recipes:
        1:
            # The type can be: shaped, shapeless, stonecutting, furnace, blast, smoker, or campfire.
            type: shapeless
            input: i@DRIED_KELP|i@SALMON

pescado_profundo_efeito:
    debug: false
    type: world
    events:
        on player consumes pescado_profundo:
        - cast WATER_BREATHING d:10 p:1 <player>

torta_abissal:
    debug: false
    type: item
    material: i@PUMPKIN_PIE
    display name: <green>Torta Abissal <gold>(<blue>1 LP<gold>)

    lore:
    - <gold> Torta feita pelo reino Zora para poder
    - <gold> enxergar nas profundezas do mar.

    recipes:
        1:
            # The type can be: shaped, shapeless, stonecutting, furnace, blast, smoker, or campfire.
            type: shapeless
            input: i@GOLDEN_CARROT|i@MILK_BUCKET|i@SUGAR
            
torta_abissal_efeito:
    debug: false
    type: world
    events:
        on player consumes torta_abissal:
        - cast NIGHT_VISION d:60 p:1 <player>

cozido_dos_mares:
    debug: false
    type: item
    material: i@RABBIT_STEW
    display name: <green>Cozido dos Mares <gold>(<blue>1 LP<gold>)

    lore:
    - <gold> Cozido feito pelo exército Zora que lhes da
    - <gold> força para enfrentar qualquer inimigo.

    recipes:
        1:
            # The type can be: shaped, shapeless, stonecutting, furnace, blast, smoker, or campfire.
            type: shapeless
            input: i@BOWL|i@SALMON|i@COD|i@CARROT|i@BEETROOT
            
cozido_dos_mares_efeito:
    debug: false
    type: world
    events:
        on player consumes cozido_dos_mares:
        - cast INCREASE_DAMAGE d:8 p:1 <player>


            


