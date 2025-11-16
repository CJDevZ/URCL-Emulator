advancement revoke @s only urcl:run_screen

execute unless data entity @s SelectedItem.components."minecraft:custom_data".compiled run return run title @s actionbar {"text":"Select a Compiled Code Book in Mainhand","color":"red"}

# Reset Data
function urcl:player/reset_data/_
data modify storage urcl:runtime workspace.memory prepend from entity @s SelectedItem.components."minecraft:custom_data".compiled[][]
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.curLine 0
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.alive 1
execute store result score b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.malloc if data entity @s SelectedItem.components."minecraft:custom_data".compiled[][]

scoreboard players reset b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.delay
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.port.x 0
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.port.y 0
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.port.r 0
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.port.g 0
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.port.b 0

scoreboard players reset b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.delay
data modify storage urcl:temp frame_buffer[].color set value "black"
data modify entity 94cff2ce-2f43-4dc3-beb3-c0fddbe3609b text.extra set value ["                              "]