scoreboard players set >C bitlib 0

execute if predicate bitlib:msb_xor run scoreboard players operation >C bitlib += -2147483648 __int__
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 1073741824
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 536870912
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 268435456
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 134217728
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 67108864
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 33554432
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 16777216
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 8388608
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 4194304
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 2097152
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 1048576
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 524288
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 262144
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 131072
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 65536
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 32768
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 16384
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 8192
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 4096
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 2048
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 1024
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 512
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 256
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 128
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 64
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 32
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 16
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 8
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 4
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 2
scoreboard players operation >A bitlib += >A bitlib
scoreboard players operation >B bitlib += >B bitlib

execute if predicate bitlib:msb_xor run scoreboard players add >C bitlib 1

return run scoreboard players operation >A bitlib = >C bitlib