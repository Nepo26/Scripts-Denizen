npc_editor:
    type: inventory
    inventory: chest
    title: "NPC Menu"
    definitions:
        delete: RED_STAINED_GLASS_PANE[display_name=<red>Delete NPC;nbt=inv/0]
        change_name: NAME_TAG[display_name=<gold>Change Name;nbt=inv/0]
        change_skin: PLAYER_HEAD[display_name=<gold>Change Skin;nbt=inv/0]
        anchors: HEART_OF_THE_SEA[display_name=<gold>Anchors;nbt=inv/0]
        health: BEETROOT[display_name=<gold>Health;lore=|<gray>Edit NPC's health||<gray>Current:<red> <player.flag[npc_id].as_npc.health> HP;nbt=inv/0]
        scripts: MOJANG_BANNER_PATTERN[display_name=<gold>Scripts;nbt=inv/0]
        paths: GRASS_PATH[display_name=<gold>Path;nbt=inv/0]
        chests_inventory: CHEST[display_name=<gold>Chests/Inventories;nbt=inv/0]
        job: WOODEN_SWORD[display_name=<gold>Job;nbt=inv/0]

    slots:
    - "[] [] [] [] [] [] [] [] [delete]"
    - "[] [change_name] [change_skin] [anchors] [health] [scripts] [paths] [chests_inventory] []"
    - "[] [job] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"

npc_editor_handler:
    type: world
    events:
        on player clicks in npc_editor priority:1 :
        - determine cancelled
        on player drags in npc_editor priority:1 :
        - determine cancelled
        on player clicks name_tag in npc_editor:
        - if <context.item.has_nbt[inv]>:
            - run npc_change_name
        - inventory close
        on player clicks player_head in npc_editor:
        - if <context.item.has_nbt[inv]>:
            - run npc_change_skin
        - inventory close
        # on player clicks player_head in npc_editor:

npc_change_name:
    type: task
    script:
    - define npc <player.flag[npc_id].as_npc>

    - narrate "<yellow>Use the command <green>/name <yellow>to name the NPC."
    - flag player npc_name:null
    - waituntil <player.flag[npc_name].is[!=].to[null]>
    - define npc_name <player.flag[npc_name]>
    - flag <player> npc_name:!
    
    # Adjusting the name
    - adjust <[npc]> name:<[npc_name]>
    
    # Handling the yaml
    - define npc_id <[npc].id>
    - yaml id:<player.uuid> set npc.id.<[npc_id]>.name:<[npc_name]>

npc_change_skin:
    type: task
    script:
    - define npc <player.flag[npc_id].as_npc>

    - narrate "<yellow>Use the command <green>/skin <yellow>to change the NPC skin."
    - flag player npc_skin:null
    - waituntil <player.flag[npc_skin].is[!=].to[null]>
    - define npc_skin <player.flag[npc_skin]>
    - flag <player> npc_skin:!
    
    # Adjusting the name
    - adjust <[npc]> skin:<[npc_skin]>
    
    # Handling the yaml
    - define npc_id <[npc].id>
    - yaml id:<player.uuid> set npc.id.<[npc_id]>.skin:<[npc_name]>

npc_skin:
    type: command
    name: skin
    description: Name the skin npc on the creation menu.
    usage: /skin <&lt>player name(source of the skin)<&gt>
    # permission: scripts.npccreate
    # permission message: "Sorry, <player.name>, you didn't enter the npc menu."
    script:
    - if <context.args.is_empty>:
        - narrate "<yellow>You need to write the name of the skin."
        - narrate "/skin <&lt>player name(source of the skin)<&gt>"
        - stop
    - if <player.has_flag[npc_name]>:
        - narrate "<yellow>Your npc will have the skin named <aqua><context.args.first>"
        - flag <player> npc_skin:<context.args.first>
        - stop
    - narrate "<yellow>Your npc will have the skin named <aqua><context.args.first>"
    - flag <player> npc_skin:<context.args.first>
    - stop

npc_health_menu:
    type: inventory
    inventory: chest
    definitions:
        plus:GREEN_STAINED_GLASS_PANE[display_name=<green>Plus]
        minus:RED_STAINED_GLASS_PANE[display_name=<green>Minus]
        blocked:BEETROOT[display_name=<gold>Health <red>20HP;lore=|<gray>Click to go back]
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [BEETROOT[display_name=<gold>Health <red>20 HP;lore=<gray>Click to go back]] [] [] [] []"

# npc_menu_edit_open:
#     type: world
#     events:
#         on player right clicks npc:
#         - ratelimit <player> 5t
#         - flag player 

        