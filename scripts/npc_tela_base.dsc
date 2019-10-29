npc_comando_menu:
    type: command
    debug: true
    name: npcmenu
    usage: /npcmenu
    description: Abre o menu dos NPCs!
    permission: script.npcmenu
    script:
    - inventory open d:lista_npc_player

lista_npc_player_size:
    debug: true
    type: procedure
    script:
    - if <yaml[<player.uuid>].contains[npc.id]>:
        - define number_of_npcs <yaml[<player.uuid>].list_keys[npc.id].size>
        - if <[number_of_npcs].div_int[7]> <= 0:
            - determine <el@2.add_int[1].mul_int[9]>
        - else:
            - determine <yaml[<player.uuid>].list_keys[npc.id].size.div_int[7].add_int[2].mul_int[9]>
    - else:
        - determine <el@2.add_int[1].mul_int[9]>

lista_npc_player:
    debug: true
    type: inventory
    title: "NPC Menu"
    size: <proc[lista_npc_player_size]>
    procedural items:

        - define lista li@

        #Fill the upper row
        - repeat 8:
            - define lista <[lista].include[AIR]>

        #Set the item to add a new_npc
        - define lista <[lista].include[EMERALD[display_name=Criar&spNPC;lore=Menu&spde&spcriação&spde&spNPCs;unbreakable=true;flags=HIDE_UNBREAKABLE]]>

        #Set the item to pass to the previus page
        - define lista <[lista].include[RED_STAINED_GLASS_PANE[display_name=<red>Página&spAnterior]]>

        #Fill the heads
        - if <yaml[<player.uuid>].contains[npc.id]>:
            - define number_of_npcs <yaml[<player.uuid>].list_keys[npc.id].size.sub_int[2]>
            - foreach <yaml[<player.uuid>].list_keys[npc.id]> as:npc:
                - if <[npc]> != last_id && <[npc]> != edit:
                    #- define head player_head[display_name=<gold><yaml[<player.uuid>].read[npc.id.<[npc]>.name]>&spid:<[npc]>;skull_skin=<yaml[<player.uuid>].read[npc.id.<[npc]>.skin]>]
                    - define head player_head[display_name=<gold><yaml[<player.uuid>].read[npc.id.<[npc]>.name]>&spid:<[npc]>]
                    - define lista <[lista].include[<[head]>]>
            # If there are more npcs
            - if <[number_of_npcs]> < 7:
                # 7 - (number_of_npcs/7)
                # Fill the remaining spaces if there are some
                - repeat <el@7.sub_int[<[number_of_npcs]>]>:
                    - define lista <[lista].include[AIR]>
        - else:
            - repeat 7:
                - define lista <[lista].include[AIR]>
        

        #Set the item to pass to the next page
        - define lista <[lista].include[LIME_STAINED_GLASS_PANE[display_name=<green>Próxima&sppágina]]>

        #Go to the middle of the inventory
        - repeat 4:
            - define lista <[lista].include[AIR]>
        #Set the page number
        - define lista <[lista].include[TORCH[display_name=<gold>&lb1&fs1&rb;QUANTITY=1]]>

        #End the inventory
        - determine <[lista]>

npc_tela_base_handler:
    debug: false
    type: world
    events:
        on player clicks in lista_npc_player:
        - if <context.item.unbreakable>:
            - run npc_criar
        - determine cancelled

        on player clicks player_head in lista_npc_player:
        - yaml id:<player.uuid> set npc.id.edit:<context.item.display.after[id:]>
        - inventory open d:npc_player_editor



