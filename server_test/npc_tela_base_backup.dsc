npc_comand_menu:
    type: command
    debug: true
    name: npcmenu
    usage: /npcmenu
    description: Open NPC control menu !
    permission: script.npcmenu
    script:
    - define npc_menu <inventory[npc_list_menu]>
    - define npc_list <proc[npc_list_heads]>
    - narrate <[npc_list]>
    - foreach <[npc_list]> as:npc:
        - narrate <[loop_index]>
        - define slot <[loop_index].add_int[10]>
        - inventory set d:<[npc_menu]> slot:<[slot]> o:<[npc]>

    - inventory open d:<[npc_menu]>
    # - inventory open d:npc_player_list

test_head:
    type: world
    events:
        on player clicks in npc_list_menu:
        - determine cancelled


npc_list_heads:
    type: procedure
    script:
    - define npc_list <yaml[<player.uuid>].list_keys[npc.id]||null>
    - define list li@
    - if <[npc_list]> != null:
        - foreach <[npc_list]> as:npc:
            - define npc_name <yaml[<player.uuid>].read[npc.id.<[npc]>.name]>
            - define npc_class <yaml[<player.uuid>].read[npc.id.<[npc]>.class].as_list.map_get[0]>
            - define head player_head[display_name=<gold><[npc_name]>;lore=<white>Class:<[npc_class]>;nbt=id/<[npc]>]
            - define list <[list].include[<[head]>]>
    - determine <[list]>

npc_list_menu:
    type: inventory
    title: "NPC Menu"
    inventory: chest
    size: 27
    definitions:
        create_npc: EMERALD[display_name=Create NPC;lore=NPC Creation Menu]
        previous_page: RED_STAINED_GLASS_PANE[display_name=<red>Previous Page]
        next_page: LIME_STAINED_GLASS_PANE[display_name=<green>Next Page]
        page_counter: TORCH[display_name=<gold>&lb1/1&rb;QUANTITY=1]
    slots:
    - "[] [] [] [] [] [] [] [] [create_npc]"
    - "[previous_page] [] [] [] [] [] [] [] [next_page]"
    - "[] [] [] [] [page_counter] [] [] [] []"

player_npc_size:
    debug: true
    type: procedure
    script:
    - if <yaml[<player.uuid>].contains[npc.id]>:
        - define id <yaml[<player.uuid>].list_keys[npc.id]||null>
        - if <[id]> == null:
            - determine 27
            - stop
        - else:
            - define number_of_npcs <yaml[<player.uuid>].list_keys[npc.id].size>
            - stop
        - if <[number_of_npcs].div_int[7]> <= 0:
            - determine 27
            - stop
        - else:
            - determine <[number_of_npcs].mod[7].add_int[3].mul_int[9]>
            - stop
    - else:
        - determine 27
        - stop

npc_player_list:
    debug: true
    type: inventory
    inventory: chest
    title: "NPC Menu"
    size: <proc[player_npc_size]>
    # definitions:
    #     create_npc: EMERALD[display_name=CreateNPC;lore=NPCCreationMenu]
    #     previous_page: RED_STAINED_GLASS_PANE[display_name=<red>Previous Page]
    #     next_page: LIME_STAINED_GLASS_PANE[display_name=<green>Next Page]
    procedural items:
        - define create_npc EMERALD[display_name=<green>CreateNPC;lore=<black>NPCCreationMenu]
        - define previous_page RED_STAINED_GLASS_PANE[display_name=<red>PreviousPage]
        - define next_page LIME_STAINED_GLASS_PANE[display_name=<green>NextPage]

        - if <player.has_flag[npc_player_list_page]>:
            - define page <player.flag[npc_player_list_page]>
        - else:
            - define page 1

        - define list li@

        #Fill the upper row
        - repeat 8:
            - define list <[list].include[AIR]>

        #Set the item to add a new_npc
        - define list <[list].include[<[create_npc]>]>

        #Set the item to pass to the previus page
        - define list <[list].include[<[previous_page]>]>

        #Fill the heads
        - if <yaml[<player.uuid>].contains[npc.id]>:
            - define number_of_npcs <yaml[<player.uuid>].list_keys[npc.id].exclude[last_id].size>
            - define npcs_id <yaml[<player.uuid>].list_keys[npc.id].exclude[last_id]>

            - foreach <[npcs_id]> as:npc:

                #- define head player_head[display_name=<gold><yaml[<player.uuid>].read[npc.id.<[npc]>.name]>&spid:<[npc]>;skull_skin=<yaml[<player.uuid>].read[npc.id.<[npc]>.skin]>]
                - define npc_name <yaml[<player.uuid>].read[npc.id.<[npc]>.name]>
                - define npc_class <yaml[<player.uuid>].read[npc.id.<[npc]>.class]>
                - define head player_head[display_name=<gold><[npc_name]>;nbt=id/<[npc]>]
                - define list <[list].include[<[head]>]>

                - if <[list].size> == 17:
                    - define list <[list].include[<[next_page]>]>

            - if <[list].size.mod[9].is[OR_LESS].to[9]>:
                # 7 - number_of_npcs
                # Fill the remaining spaces if there are some
                - repeat <el@8.sub[<[list].size.mod[9]>]>:
                    - define list <[list].include[AIR]>

        - else:
            - repeat 6:
                - define list <[list].include[AIR]>


        #Go to the middle of the inventory
        - repeat 4:
            - define list <[list].include[AIR]>
        #Set the page number
        - define list <[list].include[TORCH[display_name=<gold>&lb1&fs1&rb;QUANTITY=1]]>
        #End the inventory
        - determine <[list]>

npc_tela_base_handler:
    debug: false
    type: world
    events:
        on player clicks in npc_player_list priority:1:
        - determine cancelled
        on player drags in npc_player_list priority:1:
        - determine cancelled

        on player clicks emerald in npc_player_list:
        - run npc_create
        - inventory close
        - determine cancelled

        on player clicks player_head in npc_player_list:
        # - yaml id:<player.uuid> set npc.id.edit:<context.item.display.after[id:]>
        - inventory open d:npc_player_editor
npc_name:
    type: command
    name: name
    description: Name the npc on the creation menu.
    usage: /name <&lt>npc name<&gt>
    permission: scripts.npccreate
    permission message: "Sorry, <player.name>, you didn't enter the npc mneu."
    script:
    - if !<player.is_op||<context.server>>:
        - narrate "<red>You do not have permission for that command."
        - stop
    - if <context.args.is_empty>:
        - narrate "<yellow>You need to write the name of npc."
        - narrate "<green>/name <&lt>npc name<&gt>"
        - stop
    - if <player.has_flag[npc_name]>:
        - narrate "<yellow> Your new npc name will be <aqua><context.args.first>"
        - flag <player> npc_name:<context.args.first>
        - stop
    - narrate "<yellow>Your npc will be named <aqua><context.args.first>"
    - flag <player> npc_name:<context.args.first>
    - stop

npc_create:
    type: task
    script:
        - if <player> == null:
            - stop

        # NPC Name definition
        - narrate "<yellow>Use the command <green>/name <yellow>to name the NPC."
        - flag player npc_name:null
        - waituntil <player.flag[npc_name].is[!=].to[null]>
        - define npc_name <player.flag[npc_name]>
        - flag <player> npc_name:!

        # NPC ID Class definition
        - flag player npc_class:null
        - inventory open d:npc_choose_class_inv
        - waituntil <player.flag[npc_class_id].is[!=].to[null]>
        - define npc_class_id <player.flag[npc_class_id]>
        - flag <player> npc_class_id:!

        # Create a despawned NPC and save it
        - create player <[npc_name]> save:saved_npc
        - define saved_npc <entry[saved_npc].created_npc>

        # Set the NPC owner, skin, and its look function
        - adjust <[saved_npc]> owner:<player>
        - adjust <[saved_npc]> skin:<yaml[general].read[npc.class.<[npc_class_id]>.skin]>
        - adjust <[saved_npc]> lookclose:true

        # The NPC has the same race as the player
        - define npc_race <yaml[<player.uuid>].read[player.race]>

        # Class of the NPC
        - define npc_class <yaml[general].read[npc.class.<[npc_class_id]>.name]>

        # Organizing the NPC's YAML
        # - yaml id:<player.uuid> set npc.id.last_id:++
        # - define last_id <yaml[<player.uuid>].read[npc.id.last_id]>
        - define npc_id <[saved_npc].id>
        - yaml id:<player.uuid> set npc.id.<[npc_id]>.name:<[npc_name]>
        - yaml id:<player.uuid> set npc.id.<[npc_id]>.class:<[npc_class_id]>/<[npc_class]>
        - yaml id:<player.uuid> set npc.id.<[npc_id]>.race:<[npc_race]>

        # Spawning the NPC
        - spawn <[saved_npc]> <player.location>

npc_choose_class_inv:
    type: inventory
    inventory: chest
    title: "NPC's Class"
    size: <proc[npc_class_list_size]>
    procedural items:
        - define list li@
        - foreach <yaml[general].list_keys[npc.class]> as:class:
            - define name <yaml[general].read[npc.class.<[class]>.name]>
            - define skin <yaml[general].read[npc.class.<[class]>.skin]>
            - define lore <yaml[general].read[npc.class.<[class]>.description]>
            - define id <[class]>
            - define class_item player_head[nbt=id/<[id]>;display_name=<gold><[name]>;skull_skin=<[skin]>;lore=<gray><[lore]>]
            - define list <[list].include[<[class_item]>]>
        - determine <[list]>

npc_class_list_size:
    debug: false
    type: procedure
    script:
    - if <yaml[general].list_keys[npc.class].size.div_int[9]> <= 0:
        - determine 9
    - else:
        - determine <yaml[general].list_keys[npc.class].size.div_int[9].mul_int[9]>

npc_choose_class_handler:
    type: world
    events:
        on player clicks in npc_choose_class_inv priority:1 :
        - determine cancelled
        on player drags in npc_choose_class_inv priority:1 :
        - determine cancelled

        on player clicks player_head in npc_choose_class_inv:
        - flag player npc_class_id:<context.item.nbt[id]>

        - inventory close





