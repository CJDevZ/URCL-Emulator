gamerule maxCommandChainLength 1500000
kill @e[type=!player,tag=urcl.entity]

# Get Book
summon item_display -19.5 63.5625 -29.0 {Tags:["urcl.entity"],item:{id:"minecraft:book"},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],translation:[0f,0f,0f]}}
summon interaction -19.5 63.4375 -29.0 {CustomName:{text:"Get Book",color:"yellow"},height:0.25,width:0.25,Tags:["urcl.book","urcl.entity"],response:1b}

# Dupe Book
summon item_display -19.5 63.25 -29.0 {Tags:["urcl.entity"],item:{id:"minecraft:writable_book"},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],translation:[0f,0f,0f]}}
summon interaction -19.5 63.125 -29.0 {CustomName:{text:"Dupe Book",color:"yellow"},height:0.25,width:0.25,Tags:["urcl.dupe","urcl.entity"],response:1b}

# Play
summon item_display -19.1875 63.875 -29.0 {Tags:["urcl.entity"],item:{id:"minecraft:ender_eye"},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],translation:[0f,0f,0f]}}
summon interaction -19.1875 63.75 -29.0 {CustomName:{text:"Play",color:"aqua"},height:0.25,width:0.25,Tags:["urcl.play","urcl.entity"],response:1b}

# Run Screen Code
summon item_display -19.1875 63.5625 -29.0 {Tags:["urcl.entity"],item:{id:"minecraft:enchanted_book"},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],translation:[0f,0f,0f]}}
summon interaction -19.1875 63.4375 -29.0 {CustomName:{text:"Run Book",color:"aqua"},height:0.25,width:0.25,Tags:["urcl.run_screen","urcl.entity"],response:1b}

# Stop Screen Code
summon item_display -19.1875 63.25 -29.0 {Tags:["urcl.entity"],item:{id:"minecraft:barrier"},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],translation:[0f,0f,0f]}}
summon interaction -19.1875 63.125 -29.0 {CustomName:{text:"Stop",color:"red"},height:0.25,width:0.25,Tags:["urcl.stop_screen","urcl.entity"],response:1b}

# Compile Book near Screen
summon item_display -19.1875 62.9375 -29.0 {Tags:["urcl.entity"],item:{id:"minecraft:knowledge_book"},transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[0.25f,0.25f,0.25f],translation:[0f,0f,0f]}}
summon interaction -19.1875 62.8125 -29.0 {CustomName:{text:"Compile Book",color:"aqua"},height:0.25,width:0.25,Tags:["urcl.compile","urcl.entity"],response:1b}

# Library
summon text_display -13.4875 64.6875 -29.0 {Tags:["urcl.entity"],alignment:"left",background:0,default_background:1b,line_width:200,shadow:0b,text:'Library of Code Books:',transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[1f,1f,1f],translation:[0f,0f,0.001f]}}

# Scoreboard

# General
scoreboard objectives add urcl.temp dummy
scoreboard objectives add __int__ dummy

# Runtime
scoreboard objectives add urcl.runtime dummy
scoreboard objectives add urcl.runtime.alive dummy
scoreboard objectives add urcl.runtime.delay dummy
scoreboard objectives add urcl.runtime.curLine dummy
scoreboard objectives add urcl.runtime.malloc dummy

scoreboard objectives add urcl.runtime.port.x dummy
scoreboard objectives add urcl.runtime.port.y dummy
scoreboard objectives add urcl.runtime.port.r dummy
scoreboard objectives add urcl.runtime.port.g dummy
scoreboard objectives add urcl.runtime.port.b dummy

# Math
scoreboard objectives add urcl.math dummy
scoreboard players set -1 __int__ -1
scoreboard players set 2 __int__ 2
scoreboard players set 5 __int__ 5
scoreboard players set 12 __int__ 12
scoreboard players set 15 __int__ 15
scoreboard players set 64 __int__ 64

scoreboard objectives add urcl.powertwo dummy
scoreboard players set 0 urcl.powertwo 1
scoreboard players set 1 urcl.powertwo 2
scoreboard players set 2 urcl.powertwo 4
scoreboard players set 3 urcl.powertwo 8
scoreboard players set 5 urcl.powertwo 16
scoreboard players set 6 urcl.powertwo 32
scoreboard players set 7 urcl.powertwo 64
scoreboard players set 8 urcl.powertwo 128
scoreboard players set 9 urcl.powertwo 256
scoreboard players set 10 urcl.powertwo 512
scoreboard players set 11 urcl.powertwo 1024
scoreboard players set 12 urcl.powertwo 2048
scoreboard players set 13 urcl.powertwo 4096
scoreboard players set 14 urcl.powertwo 8192
scoreboard players set 15 urcl.powertwo 16384
scoreboard players set 16 urcl.powertwo 32768
scoreboard players set 17 urcl.powertwo 65536
scoreboard players set 18 urcl.powertwo 131072
scoreboard players set 19 urcl.powertwo 262144
scoreboard players set 20 urcl.powertwo 524288
scoreboard players set 21 urcl.powertwo 1048576
scoreboard players set 22 urcl.powertwo 2097152
scoreboard players set 23 urcl.powertwo 4194304
scoreboard players set 24 urcl.powertwo 8388608
scoreboard players set 25 urcl.powertwo 16777216
scoreboard players set 26 urcl.powertwo 33554432
scoreboard players set 27 urcl.powertwo 67108864
scoreboard players set 28 urcl.powertwo 134217728
scoreboard players set 29 urcl.powertwo 268435456
scoreboard players set 30 urcl.powertwo 536870912
scoreboard players set 31 urcl.powertwo 1074741824

# Stop All
scoreboard players reset * urcl.runtime.alive

# ROM
data modify storage urcl:rom ops set value [{id:0b,name:"ADD",args:[[1],[0,1],[0,1]]},{id:1b,name:"RSH",args:[[1],[0,1]]},{id:2b,name:"LOD",args:[[1],[0,1]]},{id:3b,name:"STR",args:[[0,1],[0,1]]},{id:4b,name:"BGE",args:[[0,1],[0,1],[0,1]]},{id:5b,name:"NOR",args:[[1],[0,1],[0,1]]},{id:6b,name:"SUB",args:[[1],[0,1],[0,1]]},{id:7b,name:"JMP",args:[[0,1]]},{id:8b,name:"MOV",args:[[1],[0,1]]},{id:9b,name:"NOP",args:[]},{id:10b,name:"IMM",args:[[1],[0]]},{id:11b,name:"LSH",args:[[1],[0,1]]},{id:12b,name:"INC",args:[[1],[0,1]]},{id:13b,name:"DEC",args:[[1],[0,1]]},{id:14b,name:"NEG",args:[[1],[0,1]]},{id:15b,name:"AND",args:[[1],[0,1],[0,1]]},{id:16b,name:"OR",args:[[1],[0,1],[0,1]]},{id:17b,name:"NOT",args:[[1],[0,1]]},{id:18b,name:"XNOR",args:[[1],[0,1],[0,1]]},{id:19b,name:"XOR",args:[[1],[0,1],[0,1]]},{id:20b,name:"NAND",args:[[1],[0,1],[0,1]]},{id:21b,name:"BRL",args:[[0,1],[0,1],[0,1]]},{id:22b,name:"BRG",args:[[0,1],[0,1],[0,1]]},{id:23b,name:"BRE",args:[[0,1],[0,1],[0,1]]},{id:24b,name:"BNE",args:[[0,1],[0,1],[0,1]]},{id:25b,name:"BOD",args:[[0,1],[0,1]]},{id:26b,name:"BEV",args:[[0,1],[0,1]]},{id:27b,name:"BLE",args:[[0,1],[0,1],[0,1]]},{id:28b,name:"BRZ",args:[[0,1],[0,1]]},{id:29b,name:"BNZ",args:[[0,1],[0,1]]},{id:30b,name:"BRN",args:[[0,1],[0,1]]},{id:31b,name:"BRP",args:[[0,1],[0,1]]},{id:32b,name:"PSH",args:[[0,1]]},{id:33b,name:"POP",args:[[1]]},{id:34b,name:"CAL",args:[[0,1]]},{id:35b,name:"RET",args:[]},{id:36b,name:"HLT",args:[]},{id:37b,name:"CPY",args:[[0,1],[0,1]]},{id:38b,name:"BRC",args:[[0,1],[0,1],[0,1]]},{id:39b,name:"BNC",args:[[0,1],[0,1],[0,1]]},{id:40b,name:"MLT",args:[[1],[0,1],[0,1]]},{id:41b,name:"UMLT",args:[[1],[0,1],[0,1]]},{id:42b,name:"SUMLT",args:[[1],[0,1],[0,1]]},{id:43b,name:"DIV",args:[[1],[0,1],[0,1]]},{id:44b,name:"SDIV",args:[[1],[0,1],[0,1]]},{id:45b,name:"MOD",args:[[1],[0,1],[0,1]]},{id:46b,name:"BSR",args:[[1],[0,1],[0,1]]},{id:47b,name:"BSL",args:[[1],[0,1],[0,1]]},{id:48b,name:"SRS",args:[[1],[0,1]]},{id:49b,name:"BSS",args:[[1],[0,1],[0,1]]},{id:50b,name:"SBRL",args:[[0,1],[0,1],[0,1]]},{id:51b,name:"SBRG",args:[[0,1],[0,1],[0,1]]},{id:52b,name:"SBLE",args:[[0,1],[0,1],[0,1]]},{id:53b,name:"SBGE",args:[[0,1],[0,1],[0,1]]},{id:54b,name:"SETE",args:[[1],[0,1],[0,1]]},{id:55b,name:"SETNE",args:[[1],[0,1],[0,1]]},{id:56b,name:"SETG",args:[[1],[0,1],[0,1]]},{id:57b,name:"SETL",args:[[1],[0,1],[0,1]]},{id:58b,name:"SETGE",args:[[1],[0,1],[0,1]]},{id:59b,name:"setle",args:[[1],[0,1],[0,1]]},{id:60b,name:"SETC",args:[[1],[0,1],[0,1]]},{id:61b,name:"SETNC",args:[[1],[0,1],[0,1]]},{id:62b,name:"SSETG",args:[[1],[0,1],[0,1]]},{id:63b,name:"SSETL",args:[[1],[0,1],[0,1]]},{id:64b,name:"SSETGE",args:[[1],[0,1],[0,1]]},{id:65b,name:"SSETLE",args:[[1],[0,1],[0,1]]},{id:66b,name:"LLOD",args:[[1],[0,1],[0,1]]},{id:67b,args:[[0,1],[0,1],[0,1]],name:"LSTR"},{id:68b,name:"ABS",args:[[1],[0,1]]},{id:69b,name:"IN",args:[[1],[0]]},{id:70b,name:"OUT",args:[[0],[0,1]]}]
data modify storage urcl:rom arg_types set value {r:1b,R:1b,"$":1b,m:2b,M:2b,"#":2b}
data modify storage urcl:rom hex set value ["00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F","10","11","12","13","14","15","16","17","18","19","1A","1B","1C","1D","1E","1F","20","21","22","23","24","25","26","27","28","29","2A","2B","2C","2D","2E","2F","30","31","32","33","34","35","36","37","38","39","3A","3B","3C","3D","3E","3F","40","41","42","43","44","45","46","47","48","49","4A","4B","4C","4D","4E","4F","50","51","52","53","54","55","56","57","58","59","5A","5B","5C","5D","5E","5F","60","61","62","63","64","65","66","67","68","69","6A","6B","6C","6D","6E","6F","70","71","72","73","74","75","76","77","78","79","7A","7B","7C","7D","7E","7F","80","81","82","83","84","85","86","87","88","89","8A","8B","8C","8D","8E","8F","90","91","92","93","94","95","96","97","98","99","9A","9B","9C","9D","9E","9F","A0","A1","A2","A3","A4","A5","A6","A7","A8","A9","AA","AB","AC","AD","AE","AF","B0","B1","B2","B3","B4","B5","B6","B7","B8","B9","BA","BB","BC","BD","BE","BF","C0","C1","C2","C3","C4","C5","C6","C7","C8","C9","CA","CB","CC","CD","CE","CF","D0","D1","D2","D3","D4","D5","D6","D7","D8","D9","DA","DB","DC","DD","1E","DF","E0","E1","E2","E3","E4","E5","E6","E7","E8","E9","EA","EB","EC","ED","EE","EF","F0","F1","F2","F3","F4","F5","F6","F7","F8","F9","FA","FB","FC","FD","FE","FF","F0","F1","F2","F3","F4","F5","F6","F7","F8","F9","FA","FB","FC","FD","FE","FF"]

# Library Books
function urcl:library/spawn_books/_

# Screen, aka Executor
kill b4c2ef2d-f22f-40b1-9b81-452342af735c
function urcl:display/spawn/_
# Logs
kill 94cff2ce-2f43-4dc3-beb3-c0fddbe3609b
summon minecraft:text_display -21.5 62.0 -29.95 {UUID:[I;-1798311218,792939971,-1095515907,-605855589], alignment: "left", background: 1073741824, default_background: 1b, line_width: 116, see_through: 0b, shadow: 0b, text: {extra: ["                              "], text: "", color: "gray"}, text_opacity: 255}

# Camera
kill 3830870b-dbc7-4c9f-8aaf-7357133edd6e
summon minecraft:block_display -17.0 63.5 -26.875 {UUID:[I;942704395,-607695713,-1968213161,322887022], Rotation: [180f, 0f], block_state: {Name: "minecraft:air"}}

# Clear workspace
data remove storage urcl:runtime workspace

# Kick Players from Playing
gamemode adventure @a[predicate=urcl:sneak,tag=urcl.player]
tag @a[predicate=urcl:sneak,tag=urcl.player] remove urcl.player

tellraw @a {color:"gold",text:"LOADED URCL EMULATOR!"}
