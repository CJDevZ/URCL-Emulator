$execute if data storage urcl:temp defines[{name:"$(arg)"}] run return run function urcl:compile/tokenize/line/cmd/label_arg with storage urcl:temp
$execute store success score ?valid_arg urcl.temp if data storage urcl:rom arg_types.$(arg_type)

execute if score ?valid_arg urcl.temp matches 1 run return run function urcl:compile/tokenize/line/cmd/valid with storage urcl:temp
return run function urcl:compile/tokenize/line/cmd/immediate with storage urcl:temp