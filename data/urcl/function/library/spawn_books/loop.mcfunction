data modify storage urcl:temp library set from storage urcl:temp books[-1]

execute store result score #10 urcl.temp if data storage urcl:temp books[]
execute summon item_display run function urcl:library/spawn_book/1 with storage urcl:temp library

data remove storage urcl:temp books[-1]
scoreboard players remove #books urcl.temp 1
execute if score #books urcl.temp matches 1.. run return run function urcl:library/spawn_books/loop