summon item_display -19.0 62.5 -29.0 {UUID:[I;-1262293203,-231784271,-1686026973,1118794588], brightness:{sky:15,block:15}, Tags:["urcl.entity"], item: {components: {"minecraft:item_model": "urcl:screen_item"}, count: 1, id: "minecraft:white_dye"}, transformation: {left_rotation: [0.0f, 1.0f, 0.0f, 0.0f], right_rotation: [0.0f, 0.0f, 0.0f, 1.0f], scale: [10.0f, 10.0f, 10.0f], translation: [0.0f, 0.0f, 0.001f]}}
scoreboard players set #xy urcl.temp 2304
data modify storage urcl:temp frame_buffer set value [0]
execute store result score #pixels_overshoot urcl.temp store result score #pixels urcl.temp if data entity b4c2ef2d-f22f-40b1-9b81-452342af735c item.components.minecraft:custom_model_data.colors[]
function urcl:display/spawn/loop
data modify entity b4c2ef2d-f22f-40b1-9b81-452342af735c item.components."minecraft:custom_model_data".colors set from storage urcl:temp frame_buffer