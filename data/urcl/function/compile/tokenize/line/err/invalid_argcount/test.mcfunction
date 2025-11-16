execute if data storage urcl:temp err[{error:"opcode"}] run return 1
execute if score #op urcl.temp = #requiredop urcl.temp run return 1

data modify storage urcl:temp err append value {error:"arg_count",message:["Invalid Arg Count. Expected: ",{score:{name:"#requiredop",objective:"urcl.temp"},interpret:true},". Got: ",{score:{name:"#op",objective:"urcl.temp"}},"."]}