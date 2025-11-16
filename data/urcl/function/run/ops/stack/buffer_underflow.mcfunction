scoreboard players reset @s urcl.runtime.alive
tellraw @s [{color:"red",text:"Buffer Underflow on Line "},{score:{name:"@s",objective:"urcl.runtime.curLine"}},":\n → Failed to Pop Value from Stack"]