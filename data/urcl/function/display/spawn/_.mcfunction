summon text_display -17.0 62.5 -29.0 {text:{text:"",font:"pixel:default"},line_width:641,brightness:{sky:15,block:15},UUID:[I;-1262293203,-231784271,-1686026973,1118794588],Tags:["urcl.entity"],transformation:{translation:[0f,0f,0f],scale:[0.25f,0.25f,0.25f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},background:0b,default_background:0b}
scoreboard players set #xy urcl.temp 2304
data modify storage urcl:temp frame_buffer set value [{text:"01",color:"black"}]
execute store result score #pixels_overshoot urcl.temp store result score #pixels urcl.temp if data entity b4c2ef2d-f22f-40b1-9b81-452342af735c text.extra[]
function urcl:display/spawn/loop
data modify entity b4c2ef2d-f22f-40b1-9b81-452342af735c text.extra set from storage urcl:temp frame_buffer
data remove storage urcl:temp frame_buffer