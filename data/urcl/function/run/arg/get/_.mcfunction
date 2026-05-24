$execute unless predicate urcl:arg/register run return $(mem_val)
$return run scoreboard players get @s urcl.runtime.register.$(mem_val)