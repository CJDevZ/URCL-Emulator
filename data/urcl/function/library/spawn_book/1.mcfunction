data merge entity @s {Tags:["urcl.entity"],transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[.25f,.25f,.25f],translation:[0f,0f,0f]}}
$item replace entity @s container.0 with writable_book[rarity=rare,custom_data={code_book:1b},item_name='"$(name)"',lore=["{text:'Author: $(author)',color:'gold',italic:false}"],writable_book_content={pages:$(pages)}]

execute store result score #11 urcl.temp run scoreboard players remove #10 urcl.temp 1
scoreboard players operation #10 urcl.temp %= 12 __int__
scoreboard players operation #11 urcl.temp /= 12 __int__

execute store result entity @s Pos[0] double 0.0625 run scoreboard players operation #10 urcl.temp *= 5 __int__
execute store result entity @s Pos[1] double -0.0625 run scoreboard players operation #11 urcl.temp *= 5 __int__
execute at @s run tp ~-14.8125 ~64.5 -29.0

$execute at @s run summon interaction ~ ~-.125 ~-.12 {width:.25,height:.25,response:1b,CustomName:'{"text":"$(name)","color":"aqua"}',Tags:["urcl.library_give_book","urcl.entity"]}