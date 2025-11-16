scoreboard players operation #pixels_overshoot urcl.temp *= 2 __int__
execute if score #pixels_overshoot urcl.temp <= #xy urcl.temp run data modify storage urcl:temp frame_buffer append from storage urcl:temp frame_buffer[]
execute if score #pixels_overshoot urcl.temp > #xy urcl.temp run data modify storage urcl:temp frame_buffer append value {text:"01",color:"black"}
execute store result score #pixels_overshoot urcl.temp store result score #pixels urcl.temp if data storage urcl:temp frame_buffer[]
execute if score #pixels urcl.temp < #xy urcl.temp run function urcl:display/spawn/loop