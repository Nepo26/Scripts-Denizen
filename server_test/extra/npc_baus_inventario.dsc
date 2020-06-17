npc_baus_inventario_menu:
    debug: false
    type: inventory
    title: "Baus e Inventarios id:<yaml[<player.uuid>].read[npc.id.edit]>"
    size: 36
    procedural items:
        - define editing_npc <yaml[<player.uuid>].read[npc.id.edit]>
        - define lista li@

        #Fill the upper row
        - define lista <[lista].include[PURPLE_SHULKER_BOX[display_name=<gold>Inventário&sp<green>id:<[editing_npc]>]]>
        - define lista <[lista].include[AIR]>
        - define lista <[lista].include[player_head[display_name=<gold>Capacete&sp<green>id:<[editing_npc]>]]>
        - define lista <[lista].include[AIR]>
        - foreach <player.inventory.equipment.reverse> as:equipment:
            - if equip

        - while <[lista].size> != 27:
            - define lista <[lista].include[AIR]>
        - if !<yaml[<player.uuid>].list_keys[npc.id].contains_any[equip]>:
            - define lista <[lista].include[TOTEM_OF_UNDYING[display_name=<gold>Equipar&sp<green>id:<[editing_npc]>]]>
        - else:
            - define lista <[lista].include[TOTEM_OF_UNDYING[display_name=<red>Parar&spde&spequipar&sp<green>id:<[editing_npc]>]]>
        #End the inventory
        - determine <[lista]>

npc_baus_inventario_handler:
    debug: false
    type: world
    events:
        on player clicks in npc_baus_inventario_menu:
        - define id_number <context.item.display.after[id:]>
        - if <context.item.material> == <m@PURPLE_SHULKER_BOX>:
            - inventory close
            - inventory open d:<yaml[<player.uuid>].read[npc.id.<[id_number]>.npc]>
            - stop
        - if <context.item.material> == <m@TOTEM_OF_UNDYING>:
            - if <yaml[<player.uuid>].contains[npc.id.equip]>:
                - yaml id:<player.uuid> set npc.id.equip:!
                - narrate "<blue><yaml[<player.uuid>].read[npc.id.<[id_number]>.name]> <green>está bem vestido !"
                - inventory close
            - else:
                - yaml id:<player.uuid> set npc.id.equip:0
                - narrate " "
                - narrate "<green>Dê algo para <blue><yaml[<player.uuid>].read[npc.id.<[id_number]>.name]> <green>vestir<gold>!"
                - narrate " "
                - narrate "<yellow>Botao direito<green> para equipar o NPC, ou <yellow>agachar botao direito<green> para mudar o item na mao."
                - narrate "<green>Escreva <yellow>offhand<green>, <yellow>chestplate<green>, <yellow>helmet<green>, etc. no chat para equipar o slot especifico com o item que voce esta segurando! <gold>|"
                - inventory close
                - stop
        - determine cancelled