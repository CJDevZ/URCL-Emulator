function urcl:gamerules

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
scoreboard objectives add urcl.runtime.port.xy dummy
scoreboard objectives add urcl.runtime.port.rgb dummy

# Register
scoreboard objectives add urcl.runtime.register.0 dummy
scoreboard objectives add urcl.runtime.register.1 dummy
scoreboard objectives add urcl.runtime.register.2 dummy
scoreboard objectives add urcl.runtime.register.3 dummy
scoreboard objectives add urcl.runtime.register.4 dummy
scoreboard objectives add urcl.runtime.register.5 dummy
scoreboard objectives add urcl.runtime.register.6 dummy
scoreboard objectives add urcl.runtime.register.7 dummy
scoreboard objectives add urcl.runtime.register.8 dummy
scoreboard objectives add urcl.runtime.register.9 dummy
scoreboard objectives add urcl.runtime.register.10 dummy
scoreboard objectives add urcl.runtime.register.11 dummy
scoreboard objectives add urcl.runtime.register.12 dummy
scoreboard objectives add urcl.runtime.register.13 dummy
scoreboard objectives add urcl.runtime.register.14 dummy
scoreboard objectives add urcl.runtime.register.15 dummy
scoreboard objectives add urcl.runtime.register.16 dummy
scoreboard objectives add urcl.runtime.register.17 dummy
scoreboard objectives add urcl.runtime.register.18 dummy
scoreboard objectives add urcl.runtime.register.19 dummy
scoreboard objectives add urcl.runtime.register.20 dummy
scoreboard objectives add urcl.runtime.register.21 dummy
scoreboard objectives add urcl.runtime.register.22 dummy
scoreboard objectives add urcl.runtime.register.23 dummy
scoreboard objectives add urcl.runtime.register.24 dummy
scoreboard objectives add urcl.runtime.register.25 dummy
scoreboard objectives add urcl.runtime.register.26 dummy
scoreboard objectives add urcl.runtime.register.27 dummy
scoreboard objectives add urcl.runtime.register.28 dummy
scoreboard objectives add urcl.runtime.register.29 dummy
scoreboard objectives add urcl.runtime.register.30 dummy
scoreboard objectives add urcl.runtime.register.31 dummy
scoreboard objectives add urcl.runtime.register.32 dummy
scoreboard objectives add urcl.runtime.register.33 dummy
scoreboard objectives add urcl.runtime.register.34 dummy
scoreboard objectives add urcl.runtime.register.35 dummy
scoreboard objectives add urcl.runtime.register.36 dummy
scoreboard objectives add urcl.runtime.register.37 dummy
scoreboard objectives add urcl.runtime.register.38 dummy
scoreboard objectives add urcl.runtime.register.39 dummy
scoreboard objectives add urcl.runtime.register.40 dummy
scoreboard objectives add urcl.runtime.register.41 dummy
scoreboard objectives add urcl.runtime.register.42 dummy
scoreboard objectives add urcl.runtime.register.43 dummy
scoreboard objectives add urcl.runtime.register.44 dummy
scoreboard objectives add urcl.runtime.register.45 dummy
scoreboard objectives add urcl.runtime.register.46 dummy
scoreboard objectives add urcl.runtime.register.47 dummy
scoreboard objectives add urcl.runtime.register.48 dummy
scoreboard objectives add urcl.runtime.register.49 dummy
scoreboard objectives add urcl.runtime.register.50 dummy
scoreboard objectives add urcl.runtime.register.51 dummy
scoreboard objectives add urcl.runtime.register.52 dummy
scoreboard objectives add urcl.runtime.register.53 dummy
scoreboard objectives add urcl.runtime.register.54 dummy
scoreboard objectives add urcl.runtime.register.55 dummy
scoreboard objectives add urcl.runtime.register.56 dummy
scoreboard objectives add urcl.runtime.register.57 dummy
scoreboard objectives add urcl.runtime.register.58 dummy
scoreboard objectives add urcl.runtime.register.59 dummy
scoreboard objectives add urcl.runtime.register.60 dummy
scoreboard objectives add urcl.runtime.register.61 dummy
scoreboard objectives add urcl.runtime.register.62 dummy
scoreboard objectives add urcl.runtime.register.63 dummy
scoreboard objectives add urcl.runtime.register.64 dummy
scoreboard objectives add urcl.runtime.register.65 dummy
scoreboard objectives add urcl.runtime.register.66 dummy
scoreboard objectives add urcl.runtime.register.67 dummy
scoreboard objectives add urcl.runtime.register.68 dummy
scoreboard objectives add urcl.runtime.register.69 dummy
scoreboard objectives add urcl.runtime.register.70 dummy
scoreboard objectives add urcl.runtime.register.71 dummy
scoreboard objectives add urcl.runtime.register.72 dummy
scoreboard objectives add urcl.runtime.register.73 dummy
scoreboard objectives add urcl.runtime.register.74 dummy
scoreboard objectives add urcl.runtime.register.75 dummy
scoreboard objectives add urcl.runtime.register.76 dummy
scoreboard objectives add urcl.runtime.register.77 dummy
scoreboard objectives add urcl.runtime.register.78 dummy
scoreboard objectives add urcl.runtime.register.79 dummy
scoreboard objectives add urcl.runtime.register.80 dummy
scoreboard objectives add urcl.runtime.register.81 dummy
scoreboard objectives add urcl.runtime.register.82 dummy
scoreboard objectives add urcl.runtime.register.83 dummy
scoreboard objectives add urcl.runtime.register.84 dummy
scoreboard objectives add urcl.runtime.register.85 dummy
scoreboard objectives add urcl.runtime.register.86 dummy
scoreboard objectives add urcl.runtime.register.87 dummy
scoreboard objectives add urcl.runtime.register.88 dummy
scoreboard objectives add urcl.runtime.register.89 dummy
scoreboard objectives add urcl.runtime.register.90 dummy
scoreboard objectives add urcl.runtime.register.91 dummy
scoreboard objectives add urcl.runtime.register.92 dummy
scoreboard objectives add urcl.runtime.register.93 dummy
scoreboard objectives add urcl.runtime.register.94 dummy
scoreboard objectives add urcl.runtime.register.95 dummy
scoreboard objectives add urcl.runtime.register.96 dummy
scoreboard objectives add urcl.runtime.register.97 dummy
scoreboard objectives add urcl.runtime.register.98 dummy
scoreboard objectives add urcl.runtime.register.99 dummy

# Math
scoreboard objectives add urcl.math dummy
scoreboard players set -1 __int__ -1
scoreboard players set 2 __int__ 2
scoreboard players set 5 __int__ 5
scoreboard players set 12 __int__ 12
scoreboard players set 15 __int__ 15
scoreboard players set 64 __int__ 64
scoreboard players set 256 __int__ 256
scoreboard players set 65536 __int__ 65536

# Stop All
scoreboard players reset * urcl.runtime.alive

# ROM
data modify storage urcl:rom ops set value [{id:0b,name:"ADD",args:[[1],[0,1],[0,1]]},{id:1b,name:"RSH",args:[[1],[1]]},{id:2b,name:"LOD",args:[[1],[0,1]]},{id:3b,name:"STR",args:[[0,1],[0,1]]},{id:4b,name:"BGE",args:[[0,1],[0,1],[0,1]]},{id:5b,name:"NOR",args:[[1],[0,1],[0,1]]},{id:6b,name:"SUB",args:[[1],[0,1],[0,1]]},{id:7b,name:"JMP",args:[[0,1]]},{id:8b,name:"MOV",args:[[1],[0,1]]},{id:9b,name:"NOP",args:[]},{id:10b,name:"IMM",args:[[1],[0]]},{id:11b,name:"LSH",args:[[1],[1]]},{id:12b,name:"INC",args:[[1],[1]]},{id:13b,name:"DEC",args:[[1],[1]]},{id:14b,name:"NEG",args:[[1],[1]]},{id:15b,name:"AND",args:[[1],[0,1],[0,1]]},{id:16b,name:"OR",args:[[1],[0,1],[0,1]]},{id:17b,name:"NOT",args:[[1],[1]]},{id:18b,name:"XNOR",args:[[1],[0,1],[0,1]]},{id:19b,name:"XOR",args:[[1],[0,1],[0,1]]},{id:20b,name:"NAND",args:[[1],[0,1],[0,1]]},{id:21b,name:"BRL",args:[[0,1],[0,1],[0,1]]},{id:22b,name:"BRG",args:[[0,1],[0,1],[0,1]]},{id:23b,name:"BRE",args:[[0,1],[0,1],[0,1]]},{id:24b,name:"BNE",args:[[0,1],[0,1],[0,1]]},{id:25b,name:"BOD",args:[[0,1],[1]]},{id:26b,name:"BEV",args:[[0,1],[1]]},{id:27b,name:"BLE",args:[[0,1],[0,1],[0,1]]},{id:28b,name:"BRZ",args:[[0,1],[0,1]]},{id:29b,name:"BNZ",args:[[0,1],[1]]},{id:30b,name:"BRN",args:[[0,1],[1]]},{id:31b,name:"BRP",args:[[0,1],[1]]},{id:32b,name:"PSH",args:[[0,1]]},{id:33b,name:"POP",args:[[1]]},{id:34b,name:"CAL",args:[[0,1]]},{id:35b,name:"RET",args:[]},{id:36b,name:"HLT",args:[]},{id:37b,name:"CPY",args:[[0,1],[0,1]]},{id:38b,name:"BRC",args:[[0,1],[0,1],[0,1]]},{id:39b,name:"BNC",args:[[0,1],[0,1],[0,1]]},{id:40b,name:"MLT",args:[[1],[0,1],[0,1]]},{id:41b,name:"UMLT",args:[[1],[0,1],[0,1]]},{id:42b,name:"SUMLT",args:[[1],[0,1],[0,1]]},{id:43b,name:"DIV",args:[[1],[0,1],[0,1]]},{id:44b,name:"SDIV",args:[[1],[0,1],[0,1]]},{id:45b,name:"MOD",args:[[1],[0,1],[0,1]]},{id:46b,name:"BSR",args:[[1],[0,1],[0,1]]},{id:47b,name:"BSL",args:[[1],[0,1],[0,1]]},{id:48b,name:"SRS",args:[[1],[1]]},{id:49b,name:"BSS",args:[[1],[0,1],[0,1]]},{id:50b,name:"SBRL",args:[[0,1],[0,1],[0,1]]},{id:51b,name:"SBRG",args:[[0,1],[0,1],[0,1]]},{id:52b,name:"SBLE",args:[[0,1],[0,1],[0,1]]},{id:53b,name:"SBGE",args:[[0,1],[0,1],[0,1]]},{id:54b,name:"SETE",args:[[1],[0,1],[0,1]]},{id:55b,name:"SETNE",args:[[1],[0,1],[0,1]]},{id:56b,name:"SETG",args:[[1],[0,1],[0,1]]},{id:57b,name:"SETL",args:[[1],[0,1],[0,1]]},{id:58b,name:"SETGE",args:[[1],[0,1],[0,1]]},{id:59b,name:"setle",args:[[1],[0,1],[0,1]]},{id:60b,name:"SETC",args:[[1],[0,1],[0,1]]},{id:61b,name:"SETNC",args:[[1],[0,1],[0,1]]},{id:62b,name:"SSETG",args:[[1],[0,1],[0,1]]},{id:63b,name:"SSETL",args:[[1],[0,1],[0,1]]},{id:64b,name:"SSETGE",args:[[1],[0,1],[0,1]]},{id:65b,name:"SSETLE",args:[[1],[0,1],[0,1]]},{id:66b,name:"LLOD",args:[[1],[0,1],[0,1]]},{id:67b,args:[[0,1],[0,1],[0,1]],name:"LSTR"},{id:68b,name:"ABS",args:[[1],[1]]},{id:69b,name:"IN",args:[[1],[0]]},{id:70b,name:"OUT",args:[[0],[0,1]]}]
data modify storage urcl:rom arg_types set value {r:1b,R:1b,"$":1b,m:2b,M:2b,"#":2b}
data modify storage urcl:rom hex set value ["00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F","10","11","12","13","14","15","16","17","18","19","1A","1B","1C","1D","1E","1F","20","21","22","23","24","25","26","27","28","29","2A","2B","2C","2D","2E","2F","30","31","32","33","34","35","36","37","38","39","3A","3B","3C","3D","3E","3F","40","41","42","43","44","45","46","47","48","49","4A","4B","4C","4D","4E","4F","50","51","52","53","54","55","56","57","58","59","5A","5B","5C","5D","5E","5F","60","61","62","63","64","65","66","67","68","69","6A","6B","6C","6D","6E","6F","70","71","72","73","74","75","76","77","78","79","7A","7B","7C","7D","7E","7F","80","81","82","83","84","85","86","87","88","89","8A","8B","8C","8D","8E","8F","90","91","92","93","94","95","96","97","98","99","9A","9B","9C","9D","9E","9F","A0","A1","A2","A3","A4","A5","A6","A7","A8","A9","AA","AB","AC","AD","AE","AF","B0","B1","B2","B3","B4","B5","B6","B7","B8","B9","BA","BB","BC","BD","BE","BF","C0","C1","C2","C3","C4","C5","C6","C7","C8","C9","CA","CB","CC","CD","CE","CF","D0","D1","D2","D3","D4","D5","D6","D7","D8","D9","DA","DB","DC","DD","1E","DF","E0","E1","E2","E3","E4","E5","E6","E7","E8","E9","EA","EB","EC","ED","EE","EF","F0","F1","F2","F3","F4","F5","F6","F7","F8","F9","FA","FB","FC","FD","FE","FF","F0","F1","F2","F3","F4","F5","F6","F7","F8","F9","FA","FB","FC","FD","FE","FF"]

# Clear workspace
data remove storage urcl:runtime workspace

# Kick Players from Playing
gamemode adventure @a[predicate=urcl:sneak,tag=urcl.player]
tag @a[predicate=urcl:sneak,tag=urcl.player] remove urcl.player

tellraw @a {color:"gold",text:"LOADED URCL EMULATOR!"}

schedule function urcl:load_entities 1s
