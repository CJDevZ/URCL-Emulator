scoreboard players operation >B bitlib < 32 __int__
scoreboard players remove >B bitlib 1
execute unless score >B bitlib matches 0.. run return run scoreboard players get >A bitlib
scoreboard players operation >A bitlib /= 2 __int__
execute if score >A bitlib matches ..-1 run scoreboard players operation >A bitlib += -2147483648 __int__
return run function bitlib:priv/bsr