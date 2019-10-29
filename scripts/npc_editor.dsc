npc_player_editor:
    debug: true
    type: inventory
    title: "NPC Menu"
    size: 36
    procedural items:
        - define editing_npc <yaml[<player.uuid>].read[npc.id.edit]>
        - define lista li@

        #Fill the upper row
        - repeat 8:
            - define lista <[lista].include[AIR]>
        
        #Fill the upper right corner
        - define lista <[lista].include[RED_STAINED_GLASS_PANE[display_name=<red>Deletar&spNPC&sp<green>id:<[editing_npc]>]]>

        #Fill the first left corner
        - define lista <[lista].include[AIR]>

        #Set the item to change the name
        - define lista <[lista].include[NAME_TAG[display_name=<gold>Mudar&spnome&sp<green>id:<[editing_npc]>]]>
        
        #Set the item to Change skin
        - define lista <[lista].include[PLAYER_HEAD[display_name=<gold>Mudar&spskin&sp<green>id:<[editing_npc]>]]>
        
        #Set anchor's item
        - define lista <[lista].include[HEART_OF_THE_SEA[display_name=<gold>Âncoras&sp<green>id:<[editing_npc]>]]>
        
        #Define life
        - define lista <[lista].include[REDSTONE[display_name=<gold>Vida&sp<green>id:<[editing_npc]>]]>

        #Define script creator
        - define lista <[lista].include[MOJANG_BANNER_PATTERN[display_name=<gold>Definição&spde&spscripts&sp<green>id:<[editing_npc]>]]>

        #Define path
        - define lista <[lista].include[GRASS_PATH[display_name=<gold>Caminho&sp<green>id:<[editing_npc]>]]>

        #Define chests
        - define lista <[lista].include[CHEST[display_name=<gold>Baús&fsInventário&sp<green>id:<[editing_npc]>]]>

        #Fill the first right corner
        - define lista <[lista].include[AIR]>

        #Fill the second left corner
        - define lista <[lista].include[AIR]>

        #Define job
        - define lista <[lista].include[WOOD_SWORD[display_name=<gold>Profissão&sp<green>id:<[editing_npc]>]]>

        #End the inventory
        - determine <[lista]>

npc_player_editor_handler:
    type: world
    events:
        on player clicks in npc_player_editor:
        - determine cancelled

        on player clicks NAME_TAG in npc_player_editor:
        - define id_number <context.item.display.after[id:]>
        - run npc_mudar_nome def:<yaml[<player.uuid>].read[npc.id.<[id_number]>.npc]>
        - inventory close
        - determine cancelled
        

        on player clicks RED_STAINED_GLASS_PANE in npc_player_editor:
        - define id_number <context.item.display.after[id:]>
        - run npc_deletar def:<yaml[<player.uuid>].read[npc.id.<[id_number]>.npc]>
        - inventory close

npc_abrir_menu:
    type: world
    events:
        on player right clicks npc:
        - foreach <yaml[<player.uuid>].list_keys[npc.id]> as:id:
            - if <context.entity> == <yaml[<player.uuid>].read[npc.id.<[id]>.npc]>:
                - yaml id:<player.uuid> set npc.id.edit:<[id]>
        - inventory open d:npc_player_editor



        

