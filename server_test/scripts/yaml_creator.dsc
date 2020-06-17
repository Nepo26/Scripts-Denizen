yaml_handler:
    debug: false
    type: world
    events:
        on player logs in:
        - if <server.has_file[/general/players/<player.uuid>.yml]>:
            - ~yaml "load:/general/players/<player.uuid>.yml" id:<player.uuid>
        - else:
            - yaml create id:<player.uuid>
            - yaml id:<player.uuid> set npc.id:0
            # - yaml id:<player.uuid> set npc.id.edit:0
            # - yaml id:<player.uuid> set npc.id.last_id:0
            - ~yaml "savefile:/general/players/<player.uuid>.yml" id:<player.uuid>
        on player quits:
        - ~yaml "savefile:/general/players/<player.uuid>.yml" id:<player.uuid>
        - yaml unload id:<player.uuid>
        on server start:
        - if <server.has_file[/general/npc/general.yml]>:
            - ~yaml "load:/general/npc/general.yml" id:general
        - else:
            - yaml create id:general
        # on shutdown:
        # - foreach <server.list_online_players> as:player_:
        #     - ~yaml "savefile:/general/players/<[player_].uuid>.yml" id:<[player_].uuid>
        #     - ~yaml "savefile:/general/npc/general.yml" id:general