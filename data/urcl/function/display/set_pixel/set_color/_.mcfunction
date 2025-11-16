data merge storage urcl:temp {R:"00",G:"00",B:"00"}

$data modify storage urcl:temp R set from storage urcl:rom hex[$(R)]
$data modify storage urcl:temp G set from storage urcl:rom hex[$(G)]
$data modify storage urcl:temp B set from storage urcl:rom hex[$(B)]
function urcl:display/set_pixel/set_color/set with storage urcl:temp