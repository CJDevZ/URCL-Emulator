$execute store success score ?valid_arg urcl.temp if data storage urcl:rom arg_types.$(arg_type)

execute if score ?valid_arg urcl.temp matches 1 run return run function urcl:compile/tokenize/labels_qwq/define/valid with storage urcl:temp
return run function urcl:compile/tokenize/labels_qwq/define/immediate with storage urcl:temp