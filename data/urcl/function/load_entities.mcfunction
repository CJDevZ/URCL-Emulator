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
