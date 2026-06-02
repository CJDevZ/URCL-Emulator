$execute if data storage urcl:temp defines[{name:"$(arg)"}] run return run function urcl:compile/tokenize/line/cmd/label_arg with storage urcl:temp

$execute if data storage urcl:rom arg_types."$(arg_type)" run return run function urcl:compile/tokenize/line/cmd/valid with storage urcl:temp
function urcl:compile/tokenize/line/cmd/immediate with storage urcl:temp