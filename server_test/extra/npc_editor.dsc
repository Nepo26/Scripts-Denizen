npc_player_editor:
    debug: false
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
        - define lista <[lista].include[]>
        
        #Set anchor's item
        - define lista <[lista].include[]>
        
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
        - define lista <[lista].include[WOODEN_SWORD[display_name=<gold>Profissão&sp<green>id:<[editing_npc]>]]>

        #End the inventory
        - determine <[lista]>

npc_player_editor_handler:
    debug: false
    type: world
    events:
        on player clicks in npc_player_editor:
        - if <context.item.material> == <m@player_head>:
            - define id_number <context.item.display.after[id:]>
            - run npc_mudar_skin def:<yaml[<player.uuid>].read[npc.id.<[id_number]>.npc]>
            - inventory close
        - if <context.item.material> == <m@HEART_OF_THE_SEA>:
            - narrate "<gold>-<red> Função ainda não funcionando, tenha paciência com o Nepo <gold>-"
        - if <context.item.material> == <m@GRASS_PATH>:
            - narrate "<gold>-<red> Função ainda não funcionando, tenha paciência com o Nepo <gold>-"
        - if <context.item.material> == <m@WOODEN_SWORD>:
            - narrate "<gold>-<red> Função ainda não funcionando, tenha paciência com o Nepo <gold>-"
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

        on player clicks HEART_OF_THE_SEA in npc_player_editor:
        - narrate "<gold>-<red> Função ainda não funcionando, tenha paciência com o Nepo <gold>-"

        on player clicks REDSTONE in npc_player_editor:
        - narrate "<gold>-<red> Função ainda não funcionando, tenha paciência com o Nepo <gold>-"

        on player clicks MOJANG_BANNER_PATTERN in npc_player_editor:
        - narrate "<gold>-<red> Função ainda não funcionando, tenha paciência com o Nepo <gold>-"

        on player clicks GRASS_PATH in npc_player_editor:
        - narrate "<gold>-<red> Função ainda não funcionando, tenha paciência com o Nepo <gold>-"

        on player clicks CHEST in npc_player_editor:
        - inventory open d:npc_baus_inventario_menu
        #- inventory open d:<yaml[<player.uuid>].read[npc.id.<context.item.display.after[id:]>.npc]>

        on player clicks WOODEN_SWORD in npc_player_editor:
        - narrate "<gold>-<red> Função ainda não funcionando, tenha paciência com o Nepo <gold>-"
        

npc_abrir_menu:
    debug: false
    type: world
    events:
        on player right clicks npc:
        - ratelimit <player> 5t
        - execute as_op "npc sel" silent
        - if <yaml[<player.uuid>].contains[npc.id]>:
            - foreach <yaml[<player.uuid>].list_keys[npc.id].exclude[last_id|edit|equip]> as:id:
                - if <yaml[<player.uuid>].contains[npc.id.<[id]>.npc]>:
                    - if <context.entity> == <yaml[<player.uuid>].read[npc.id.<[id]>.npc]>:
                        #- narrate "Before:? <context.item.material> : <yaml[<player.uuid>].contains[npc.id.equip]>"
                        #If is holdig air
                        - if <context.item.material> == m@air:
                            #Inventory on right click
                            - if <player.is_sneaking>:
                                - if <yaml[<player.uuid>].contains[npc.id.equip]>:
                                    #Take off NPCs equipment
                                    - ratelimit <player> 5t
                                    - execute as_op "npc equip" silent
                                    - wait 2t
                                    - execute as_op "npc equip" silent
                                    - stop
                                - else:
                                    #Opens NPCs inventory
                                    - inventory open d:<npc>
                                    - stop
                            - else:
                                #Edit menu on right click
                                - yaml id:<player.uuid> set npc.id.edit:<[id]>
                                - inventory open d:npc_player_editor
                                - stop
                        - else:
                            #Hand the item in hand to the NPC
                            #- narrate "Item: <context.item.material> : <yaml[<player.uuid>].contains[npc.id.equip]>"
                            - if <yaml[<player.uuid>].contains[npc.id.equip]>:
                                - ratelimit <player> 5t
                                - execute as_op "npc equip" silent
                                - wait 2t
                                - execute as_op "npc equip" silent
                                - stop
                            - else:
                                - narrate "<green>Nao esta no modo equipar !"

                    - else:
                        - stop
                - else:
                    - stop
        - else:
            - stop

        #on command "npc equip":
        #- narrate "<gold>Why ?"

        #on player chats:
        #- narrate "<context.full_text.escaped.after[<player.name>&gt].unescaped>"
        #- determine cancelled
        #- if <context.full_text>