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

    # Finding out how many pages does it have
    - if <[npc_list].is_empty>:
        - flag player npc_list_menu_pages_total:1
        - inventory open d:<[npc_menu]>
        - stop
    - if <[npc_list].size> <= 7:
        - flag player npc_list_menu_pages_total:1
    - else:
        - flag player npc_list_menu_pages_total:<[npc_list].size.div_int[7].add_int[1]>

    # Setting the page
    - if <player.has_flag[npc_list_menu_pages]>:
        - define page <player.flag[npc_list_menu_pages]||null>
        - define page_total <player.flag[npc_list_menu_pages_total]||null>
        - inventory adjust d:<[npc_menu]> slot:23 display_name:&lb<[page]>/<[page_total]>&rb
        - if <[page]> > 1:
            - define begin <el@7.add_int[<[page].sub_int[1]>]>
            - define end <[page].mul_int[9].sub_int[1]>
            - define npc_list <[npc_list].get[<[begin]>].to[<[end]>]>
        - else:
            - define npc_list <[npc_list].get[1].to[7]>
    - else:
        - define page <player.flag[npc_list_menu_pages]||null>
        - flag player npc_list_menu_pages:1

    # Putting Heads
    - foreach <[npc_list]> as:npc:
        - define slot <[loop_index].add_int[10]>
        - inventory set d:<[npc_menu]> slot:<[slot]> o:<[npc]>

    - inventory open d:<[npc_menu]>

npc_list_heads:
    type: procedure
    script:
    # Get all NPCs on alphabetical order
    - define npc_list <yaml[<player.uuid>].list_keys[npc.id].alphabetical||null>
    - define list li@
    - if <[npc_list]> != null:
        - foreach <[npc_list]> as:npc:
            - define npc_name <yaml[<player.uuid>].read[npc.id.<[npc]>.name]||Nepo>
            - define npc_class <yaml[<player.uuid>].read[npc.id.<[npc]>.class].as_list.get_sub_items[1].split_by[/].first||Nepo>
            - narrate <[npc].as_npc.formatted_health>
            - define head player_head[display_name=<gold><[npc_name]>;lore=<aqua>Class:<[npc_class]>|<red><[npc].as_npc.formatted_health>;nbt=id/<[npc]>]
            - define list <[list].include[<[head]>]>
    - determine <[list]||li@>

npc_list_menu:
    type: inventory
    title: "NPC Menu"
    inventory: chest
    size: 27
    definitions:
        create_npc: EMERALD[display_name=Create NPC;lore=NPC Creation Menu]
        previous_page: RED_STAINED_GLASS_PANE[display_name=<red>Previous Page]
        next_page: LIME_STAINED_GLASS_PANE[display_name=<green>Next Page]
        page_counter: TORCH[display_name=<gold>&lb0/0&rb;QUANTITY=1]
    slots:
    - "[] [] [] [] [] [] [] [] [create_npc]"
    - "[previous_page] [] [] [] [] [] [] [] [next_page]"
    - "[] [] [] [] [page_counter] [] [] [] []"

npc_list_menu_handler:
    debug: true
    type: world
    events:
        # on player closes npc_list_menu:
        # - flag player npc_id:!
        # - flag player npc_list_menu_pages_total:!
        # - flag player npc_list_menu_pages:!

        on player clicks in npc_list_menu priority:1:
        - determine cancelled
        on player drags in npc_list_menu priority:1:
        - determine cancelled

        on player clicks emerald in npc_list_menu:
        - run npc_create
        - inventory close
        - determine cancelled

        on player clicks player_head in npc_list_menu:
        - if <context.item.has_nbt[id]>:
            - flag player npc_id:<context.item.nbt[id]>
        - inventory open d:npc_editor

        on player clicks lime_stained_glass_pane in npc_list_menu:
        - if <player.has_flag[npc_list_menu_pages]>:
            - define page <player.flag[npc_list_menu_pages]>
            - define total_pages <player.flag[npc_list_menu_pages_total]>
            - if <[page]> == <[total_pages]>:
                - narrate "<red>Reached the limit"
            - else:
                - flag player npc_list_menu_pages:++

        # Re-Execute the command to be able to get the 'updated' page
        - execute as_player npcmenu
        on player clicks red_stained_glass_pane in npc_list_menu:
        - define page <player.flag[npc_list_menu_pages]>
        - if <player.has_flag[npc_list_menu_pages]>:
            - if <[page]> <= 1 :
                - narrate "<red>Reached the limit"
            - else:
                - flag player npc_list_menu_pages:--

        # Reexecute the command to be able to get the 'updated' page
        - execute as_player npcmenu

npc_name:
    type: command
    name: name
    description: Name the npc on the creation menu.
    usage: /name <&lt>npc name<&gt>
    # permission: scripts.npccreate
    # permission message: "Sorry, <player.name>, you didn't enter the npc menu."
    script:
    - if <context.args.is_empty>:
        - narrate "<yellow>You need to write the name of npc."
        - narrate "<green>/name <&lt>npc name<&gt>"
        - stop
    - if <player.has_flag[npc_name]>:
        - narrate "<yellow>Your npc will be named <aqua><context.args.first>"
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
        - define npc_skin <yaml[general].read[npc.class.<[npc_class_id]>.skin]||null>
        - if <[npc_skin]>==null:
            - adjust <[saved_npc]> skin_blob:<player.skin_blob>
        - else:
            - adjust <[saved_npc]> skin:<[npc_skin]>
        - adjust <[saved_npc]> owner:<player>
        - adjust <[saved_npc]> lookclose:true

        # The NPC has the same race as the player
        - define npc_race <yaml[<player.uuid>].read[player.race]||null>

        # Class of the NPC
        - define npc_class <yaml[general].read[npc.class.<[npc_class_id]>.name]||null>

        # Organizing the NPC's YAML
        # - yaml id:<player.uuid> set npc.id.last_id:++
        # - define last_id <yaml[<player.uuid>].read[npc.id.last_id]>
        - define npc_id <[saved_npc].id>
        - yaml id:<player.uuid> set npc.id.<[npc_id]>.name:<[npc_name]>
        - yaml id:<player.uuid> set npc.id.<[npc_id]>.class:<[npc_class]>/<[npc_class_id]>
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
        # on player closes npc_choose_class_inv:
        # - flag player npc_name:!
        # - flag player npc_class:!
        on player clicks in npc_choose_class_inv priority:1 :
        - determine cancelled
        on player drags in npc_choose_class_inv priority:1 :
        - determine cancelled

        on player clicks player_head in npc_choose_class_inv:
        - flag player npc_class_id:<context.item.nbt[id]>

        - inventory close





