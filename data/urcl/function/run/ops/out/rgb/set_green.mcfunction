scoreboard players operation value= urcl.runtime %= 256 __int__

scoreboard players operation $temp_rgb1 urcl.runtime = @s urcl.runtime.port.rgb
scoreboard players operation $temp_rgb1 urcl.runtime /= 65536 __int__
scoreboard players operation $temp_rgb1 urcl.runtime *= 256 __int__
scoreboard players operation $temp_rgb1 urcl.runtime += value= urcl.runtime
scoreboard players operation $temp_rgb1 urcl.runtime *= 256 __int__
scoreboard players operation @s urcl.runtime.port.rgb %= 256 __int__
execute store result score @s urcl.runtime.port.rgb run scoreboard players operation $temp_rgb1 urcl.runtime += @s urcl.runtime.port.rgb