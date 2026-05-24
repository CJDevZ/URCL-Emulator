$execute unless data storage urcl:rom ops[{name:"$(line)"}] run return 1
scoreboard players add &instruction urcl.temp 1
$execute store result score #args urcl.temp if data storage urcl:rom ops[{name:"$(line)"}].args[]
scoreboard players operation &instruction urcl.temp += #args urcl.temp