execute store result score #books urcl.temp if data storage urcl:library books[]
data modify storage urcl:temp books set from storage urcl:library books
function urcl:library/spawn_books/loop