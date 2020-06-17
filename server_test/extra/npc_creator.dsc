# chat_menu:
#     type: format
#     format: "<red> - <white> <text> <red> - "

# npc_comando_criar:
#     type: command
#     debug: false
#     name: criarnpc
#     usage: /criarnpc
#     description: Abre o menu de criação de NPCs!
#     permission: script.criarnpc
#     script:
#     - inject npc_criar

# npc_criar:
#     debug: false
#     type: task
#     script:
#     - define nome_npc "Default"
#     - narrate format:chat_menu "Olá, digite o nome do <&l><&6>NPC<&r> no chat"
#     - narrate format:chat_menu "<green> nome: <yellow>nome do npc"
#     - waituntil <player.chat_history.starts_with[nome:]>
#     - define nome_npc <player.chat_history.after[nome:]>
#     - yaml id:<player.uuid> set npc.id.last_id:++
#     - yaml id:<player.uuid> set npc.id.<yaml[<player.uuid>].read[npc.id.last_id]>.name:<[nome_npc]>
#     - inventory open d:escolha_tipo_npc

# npc_mudar_nome:
#     debug: false
#     type: task
#     definitions: npc
#     script:
#     - narrate format:chat_menu "Olá, digite o nome do <&l><&6>NPC<&r> no chat"
#     - narrate format:chat_menu "<green> nome: <yellow>nome do npc"
#     - waituntil <player.chat_history.starts_with[nome:]>
#     - define name <player.chat_history.after[nome:]>

#     - foreach <yaml[<player.uuid>].list_keys[npc.id]> as:id:
#         - if <[npc]> == <yaml[<player.uuid>].read[npc.id.<[id]>.npc]>:
#             - rename <[name]> npc:<[npc]>
#             - yaml id:<player.uuid> set npc.id.<[id]>.name:<[name]>
#             - narrate "Nome mudado."
#             - stop

# npc_deletar:
#     debug: false
#     type: task
#     definitions: npc
#     script:
#     - foreach <yaml[<player.uuid>].list_keys[npc.id]> as:id:
#         - if <[npc]> == <yaml[<player.uuid>].read[npc.id.<[id]>.npc]>:
#             - define nome_npc <yaml[<player.uuid>].read[npc.id.<[id]>.name]>
#             - remove <[npc]>
#             - narrate "<[nome_npc]> foi para sempre esquecido..."
#             - yaml id:<player.uuid> set npc.id.<[id]>:!

# escolha_tipo_npc:
#     debug: false
#     type: inventory
#     inventory: chest
#     title: "Tipo de NPC"
#     size: <proc[lista_npc_size]>
#     procedural items:
#         - define lista li@
#         - foreach <yaml[general].list_keys[npc.type]> as:types:
#             - define type_item player_head[display_name=<gold><yaml[general].read[npc.type.<[types]>.name]>&spt:<[types]>;skull_skin=<yaml[general].read[npc.type.<[types]>.skin]>;lore=<gray><yaml[general].read[npc.type.<[types]>.description]>]
#             - define lista <[lista].include[<[type_item]>]>
#         - determine <[lista]>

# lista_npc_size:
#     debug: false
#     type: procedure
#     script:
#     - if <yaml[general].list_keys[npc.type].size.div_int[9]> <= 0:
#         - determine <el@1.mul_int[9]>
#     - else:
#         - determine <yaml[general].list_keys[npc.type].size.div_int[9]>

# npc_creator_handler:
#     debug: false
#     type: world
#     events:
#         on player clicks in escolha_tipo_npc:
#         - determine cancelled
#         on player left clicks player_head in escolha_tipo_npc:
#         - run criar_npc def:<context.item.display.after[t:]>
#         - inventory close
#         - determine cancelled

# criar_npc:
#     debug: false
#     type: task
#     definitions: types
#     script:
#     - define last_id <yaml[<player.uuid>].read[npc.id.last_id]>
#     - define set_skin <yaml[general].read[npc.type.<[types]>.skin]>
#     - define npc_name <yaml[<player.uuid>].read[npc.id.<[last_id]>.name]>

#     - yaml id:<player.uuid> set npc.id.<[last_id]>.skin:<[set_skin]>

#     - create player <[npc_name]> <player.location> save:<player.name>_npc

#     - yaml id:<player.uuid> set npc.id.<[last_id]>.npc:<entry[<player.name>_npc].created_npc>
    
#     - define npc_ <yaml[<player.uuid>].read[npc.id.<[last_id]>.npc]>
    
#     - adjust <[npc_]> owner:<player.name>
#     - adjust <[npc_]> skin_blob:<player.skin_blob>
#     - adjust <[npc_]> lookclose:true

# editar_npc:
#     type: task
#     definitions: type_name
#     script:
#     - narrate "<red>Talvez depois..."
  