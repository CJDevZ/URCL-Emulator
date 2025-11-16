execute if score ?exclude strlib matches 0 run return run data modify storage strlib:out split prepend from storage strlib:temp string2
$data modify storage strlib:out split prepend string storage strlib:temp string2 $(exclude)
data modify storage strlib:out split prepend value ""