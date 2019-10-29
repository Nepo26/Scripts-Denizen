yaml_handler:
    debug: false
    type: world
    events:
        
        on player logs in:
        - if <server.has_file[/players/<player.uuid>.yml]>:
            - yaml "load:/players/<player.uuid>.yml" id:<player.uuid>
        - else:
            - yaml create id:<player.uuid>
            - yaml id:<player.uuid> set npc.id.edit:0
            - yaml id:<player.uuid> set npc.id.last_id:0
            - yaml "savefile:/players/<player.uuid>.yml" id:<player.uuid>

        
        on player quits:
        - yaml "savefile:/players/<player.uuid>.yml" id:<player.uuid>
        - yaml unload id:<player.uuid>
        
        on server start:
        - if <server.has_file[/npc/general.yml]>:
            - yaml "load:/npc/general.yml" id:general
        - else:
            - yaml create id:general

        on shutdown:
        - foreach <server.list_online_players> as:player_:
            - yaml "savefile:/players/<[player_].uuid>.yml" id:<[player_].uuid>
            - yaml "savefile:/npc/general.yml" id:general

        # on system time minutely:
        # - foreach <server.list_online_players> as:player_:
        #     - yaml "savefile:/players/<[player_].uuid>.yml" id:<[player_].uuid>
        
        #on player breaks block:
        #- yaml id:<player.uuid> set blocks.<context.material>:++

        on check command:
        - foreach <yaml[<player.uuid>].list_keys[npc]>:
            - narrate "<yaml[<player.uuid>].read[npc]>"