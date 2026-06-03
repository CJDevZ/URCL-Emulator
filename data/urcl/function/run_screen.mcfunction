advancement revoke @s only urcl:run_screen

execute unless data entity @s SelectedItem.components."minecraft:custom_data".compiled run return run title @s actionbar {"text":"Select a Compiled Code Book in Mainhand","color":"red"}

# Reset Data
execute as b4c2ef2d-f22f-40b1-9b81-452342af735c run function urcl:player/reset_data
data modify storage urcl:temp program_code set value [I;]
data modify storage urcl:temp program_code append from entity @s SelectedItem.components."minecraft:custom_data".compiled[]
data modify storage urcl:temp program_code append from entity @s SelectedItem.components."minecraft:custom_data".compiled[][]
data modify storage urcl:runtime workspace.memory prepend from storage urcl:temp program_code[]
execute store result score b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.register.99 if data storage urcl:runtime workspace.memory[]
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.curLine 0
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.alive 1
execute store result score b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.malloc store result storage urcl:runtime workspace.malloc[0].next int 1 if data storage urcl:temp program_code[]

scoreboard players reset b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.delay
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.port.xy 0
scoreboard players set b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.port.rgb 0

scoreboard players reset b4c2ef2d-f22f-40b1-9b81-452342af735c urcl.runtime.delay
data modify storage urcl:runtime frame_buffer[] set value 0
data modify entity 94cff2ce-2f43-4dc3-beb3-c0fddbe3609b text.extra set value ["                              "]