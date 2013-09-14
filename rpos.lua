-------------------------------------------------------
--
--	RPOS v2.2
--	Made By Joshua Robbins
--	The Reverse Polish Operating System
--	Made on 2/17/11, Last modified on 3/20/11
--
-------------------------------------------------------


stack = {}
cmdn = ""
sys = {}
vars = {sys = sys}
root = vars
path = {}
pname = {}
cpn = "root"
funcs = {}
pref = {}
help = {}
libfrom = {}
libs = {}

--sys vars declaration

sys["errs"] = 1
sys["disp"] = 0
sys["srcchr"] = "_"
sys["repchr"] = " "
sys["version"] = 2.2
sys["bdate"] = "3/20/11"
sys["joinchr"] = ""
sys["inc"] = 1
sys["pcf1"] = ""
sys["pcf2"] = "S"
sys["pcf3"] = " > "
sys["errmsg"] = ""
sys["pshloop"] = 1
sys["term"] = 0
sys["libs"] = libs
sys["platform"] = "lua"


-- Function declaration

funcs["add"] = function()
	local args = {}
	if GetArgs(args,2,"number","number") then return end
	push(args[1]+args[2])
end

funcs["sub"] = function()
	local args = {}
	if GetArgs(args,2,"number","number") then return end
	push(args[1]-args[2])
end

funcs["mul"] = function()
	local args = {}
	if GetArgs(args,2,"number","number") then return end
	push(args[1]*args[2])
end

funcs["div"] = function()
	local args = {}
	if GetArgs(args,2,"number","number") then return end
	push(args[1]/args[2])
end

funcs["disp"] = function()
	if CheckStack(1) then return end
	print(pop())
end

funcs["peek"] = function()
	if CheckStack(1) then return end
	print(peek())
end

funcs["dup"] = function()
	if CheckStack(1) then return end
	push(peek())
end

funcs["drop"] = function()
	if CheckStack(1) then return end
	pop()
end

funcs["swap"] = function()
	local args = {}
	if GetArgs(args,2) then return end
	push(args[1])
	push(args[2])
end

funcs["rot"] = function()
	local args = {}
	if GetArgs(args,3) then return end
	push(args[1])
	push(args[2])
	push(args[3])
end

funcs["clear"] = function()
	stack = {}
end

funcs["cls"] = function()
	os.execute("cls")
end

funcs["dump"] = function()
	for i,v in ipairs(stack) do
		print(i .. " : " .. dform(v))
	end
end

funcs["mkdir"] = function()
	local args = {}
	if GetArgs(args,1,"string") then return end
	vars[args[1]] = {}
end

funcs["chdir"] = function()
	local args = {}
	local v,dir
	if GetArgs(args,1,"string") then return end
	v = CheckIsDir(args[1],false,true)
	if not v then return end
	table.insert(path,vars)
	table.insert(pname,cpn)
	vars = v
	cpn = args[1]
	if args[1] == ".." then
		dir = table.remove(path)
		cpn = table.remove(pname)
		vars = dir
	else
		table.insert(path,vars)
		table.insert(pname,cpn)
		vars = v
		cpn = args[1]
	end
end

funcs["del"] = function()
	local args = {}
	if GetArgs(args,1,"string") then return end
	if not vars[args[1]] then err("Undefined item "..v) return end
	vars[args[1]] = nil
end

funcs["rcl"] = function()
	local args = {}
	if GetArgs(args,1,"string") then return end
	local v = CheckIsVar(args[1])
	if not v then return end
	push(v)
end

funcs["sto"] = function()
	local args = {}
	if GetArgs(args,2,"string") then return end
	vars[args[1]] = args[2]
end

funcs["list"] = function()
	local i,v
	for i,v in pairs(vars) do
		print(i .. " : " .. dform(v))
	end
end

funcs["dir"] = function()
	if vars == root then print("root") return end
	print(table.concat(pname,"\\").."\\"..cpn)
end

funcs["exec"] = function()
	local args = {}
	if GetArgs(args,1,"string") then return end
	parse(args[1])
end

funcs["eq"] = function()
	local args = {}
	if GetArgs(args,2) then return end
	if args[1]==args[2] then push(1) else push(0) end
end

funcs["ne"] = function()
	local args = {}
	if GetArgs(args,2) then return end
	if args[1]~=args[2] then push(1) else push(0) end
end

funcs["lt"] = function()
	local args = {}
	if GetArgs(args,2) then return end
	if args[1]<args[2] then push(1) else push(0) end
end

funcs["le"] = function()
	local args = {}
	if GetArgs(args,2) then return end
	if args[1]<=args[2] then push(1) else push(0) end
end

funcs["gt"] = function()
	local args = {}
	if GetArgs(args,2) then return end
	if args[1]>args[2] then push(1) else push(0) end
end

funcs["ge"] = function()
	local args = {}
	if GetArgs(args,2) then return end
	if args[1]>=args[2] then push(1) else push(0) end
end

funcs["not"] = function()
	local args = {}
	if GetArgs(args,1,"number") then return end
	if args[1]==1 then push(0) else push(1) end
end

funcs["and"] = function()
	local args = {}
	if GetArgs(args,2,"number","number") then return end
	if args[1]==1 and args[2]==1 then push(1) else push(0) end
end

funcs["or"] = function()
	local args = {}
	if GetArgs(args,2,"number","number") then return end
	if args[1]==1 or args[2]==1 then push(1) else push(0) end
end

funcs["doif"] = function()
	local args = {}
	if GetArgs(args,2,"string","number") then return end
	if args[2]==1 then parse(args[1]) end
end

funcs["while"] = function()
	local args = {}
	if GetArgs(args,2,"string","string") then return end
	parse(args[2])
	if pop()==0 then return end
	while true do
		parse(args[1].." "..args[2])
		if pop()==0 then return end
	end
end

funcs["rep"] = function()
	local args = {}
	local i
	if GetArgs(args,2,"string","number") then return end
	for i=1,args[2] do
		if sys["pshloop"]==1 then push(i) end
		parse(args[1])
	end
end

funcs["repdir"] = function()
	local args = {}
	local i,v,d
	if GetArgs(args,2,"string","string") then return end
	d = CheckIsDir(args[2],true,true)
	if not d then return end
	for i,v in pairs(d) do
		if sys["pshloop"]==1 then push(i) end
		parse(args[1])
	end
end

funcs["size"] = function()
	local args = {}
	local i,v,d,c
	if GetArgs(args,1,"string") then return end
	d = CheckIsDir(args[2],true,true)
	if not d then return end
	c = 0
	for i,v in pairs(d) do
		c = c + 1
	end
	push(c)
end

funcs["join"] = function()
	local args = {}
	if GetArgs(args,2) then return end
	push(args[1]..sys["joinchr"]..args[2])
end

funcs["move"] = function()
	local args = {}
	local od,nd
	if GetArgs(args,2,"string","string") then return end
	od = CheckIsDir(args[2])
	if not od then return end
	nd = CheckIsDir(args[1],false,true)
	if not nd then return end
	nd[args[2]] = od
	vars[args[2]] = nil
	if args[1]==".." then parse(">..") end
end

funcs["ren"] = function()
	local args = {}
	local od,nd
	if GetArgs(args,2,"string","string") then return end
	od = vars[args[2]]
	if not od then err("Undefined item "..args[2]) return end
	nd = args[1]
	vars[nd] = od
	vars[args[2]] = nil
end

funcs["copy"] = function()
	local args = {}
	local od,nd
	if GetArgs(args,2,"string","string") then return end
	od = CheckIsDir(args[2])
	if not od then return end
	nd = CheckIsDir(args[1],false,true)
	if not nd then return end
	nd[args[2]] = copy(od)
end

funcs["write"] = function()
	local v,tot
	tot = ""
	while true do
		v = io.read(1)
		if string.byte(v)==4 then break end
		tot = tot .. v
	end
	push(string.sub(tot,1,-2))
end

funcs["func"] = function()
	local args = {}
	if GetArgs(args,2,"string","string") then return end
	funcs[args[1]] = loadstring("parse(\""..args[2].."\")")
	libs.custom[args[1]] = args[2]
	libfrom[args[1]] = "custom"
end

funcs["isvar"] = function()
	local args = {}
	if GetArgs(args,1,"string") then return end
	args = vars[args[1]]
	if args then push(1) else push(0) end
end

funcs["isdir"] = function()
	local args = {}
	if GetArgs(args,1,"string") then return end
	args = vars[args[1]]
	if type(args)=="table" then push(1) else push(0) end
end

funcs["isfunc"] = function()
	local args = {}
	if GetArgs(args,1,"string") then return end
	if funcs[args[1]] then push(1) else push(0) end
end

funcs["delfunc"] = function()
	local args = {}
	if GetArgs(args,1,"string") then return end
	funcs[args[1]] = nil
	libs[libfrom[args[1]]][args[1]] = nil
	libfrom[args[1]] = nil
end

funcs["alias"] = function()
	local args = {}
	if GetArgs(args,2,"string","string") then return end
	funcs[args[1]] = funcs[args[2]]
	libs.custom[args[1]] = args[2]
	libfrom[args[1]] = "custom"
end

funcs["type"] = function()
	local args = {}
	if GetArgs(args,1) then return end
	push(type(args[1]))
end

funcs["tos"] = function()
	if CheckStack(1) then return end
	push(tostring(pop()))
end

funcs["ton"] = function()
	if CheckStack(1) then return end
	push(tonumber(pop()))
end

funcs["prompt"] = function()
	local v
	if CheckStack(1) then return end
	v = pop()
	if v=="S" then
		pr2 = function() return #stack end
	elseif v=="D" then
		pr2 = function() if vars==root then return "root" else return table.concat(pname,"\\").."\\"..cpn end end
	elseif v=="C" then
		pr2 = function() return cpn end
	elseif v=="T" then
		pr2 = function() return (peek() or "nil") end
	else
		pr2 = function() return "" end
	end
end

funcs["lib"] = function()
	local args = {}
	local f,cont,i,v,s
	if GetArgs(args,1,"string") then return end
	args = args[1]
	f = io.open("RposData\\"..args..".rlib","r")
	cont = f:read("*a")
	lib = {}
	if not libs[args] then libs[args] = {} end
	s = loadstring(cont)
	if s then s() else err("Syntax error in library "..args) return end
	for i,v in pairs(lib) do
		funcs[i] = v
		libs[args][i] = i
		libfrom[i] = args
	end
	addhelp(args[1])
end

funcs["libcmd"] = function()
	local args = {}
	local f,cont,i,v,s
	if GetArgs(args,2,"string","string") then return end
	f = io.open("RposData\\"..args[1]..".rlib","r")
	cont = f:read("*a")
	lib = {}
	if not libs[args[1]] then libs[args[1]] = {} end
	s = loadstring(cont)
	if s then s() else err("Syntax error in library "..args[1]) return end
	for i in string.gmatch(args[2],"%S+") do
		funcs[i] = lib[i]
		libs[args[1]][i] = i
		libfrom[i] = args[1]
	end
	addhelp(args[1])
end

funcs["substr"]=function()
	if CheckStack(3) or CheckTypes("number","number","string") then return end
	local s3 = pop()
	local s2 = pop()
	local s1 = pop()
	push(string.sub(s1,s2,s3))
end

funcs["len"] = function()
	if CheckStack(1) or CheckTypes("string") then return end
	push(#pop())
end

funcs["import"] = function()
	local args = {}
	local f,cont,i,v,s
	if GetArgs(args,1,"string") then return end
	f = io.open("RposData\\"..args[1]..".rfil","r")
	cont = f:read("*a")
	push(cont)
end

funcs["export"] = function()
	local args = {}
	local f,cont,i,v,s
	if GetArgs(args,2,"string") then return end
	f = io.open("RposData\\"..args[1]..".rfil","w")
	f:write(args[2])
end

funcs["inp"] = function()
	push(io.read("*l"))
end

funcs["call"] = function()
	local args = {}
	local f,cont,i,v,s
	if GetArgs(args,1,"string") then return end
	f = io.open("RposData\\"..args[1]..".rfil","r")
	cont = f:read("*a")
	parse(cont)
end

funcs["run"] = function()
	local args = {}
	local f,cont,i,v,s
	if GetArgs(args,1,"string") then return end
	f = io.open("RposData\\"..args[1]..".rfil","r")
	cont = f:read("*a")
	s = loadstring(cont)
	if s then s() else err("Syntax error in file "..args[1]) return end
end

funcs["save"] = function()
	local f
	sav = "return "..save(root)
	f = io.open("RposData\\saved.rsav","w")
	f:write(sav)
end

funcs["load"] = function()
	sav = loadfile("RposData\\saved.rsav")
	if sav == nil then err("Corrupted or nonexistant save file") return end
	root = sav()
	sys = root.sys
	vars = root
	path = {}
	pname = {}
	cpn = "root"
	sys.libs = libs
end

funcs["exit"] = function()
	if io.open("RposData\\onexit.rfil","r") then parse(io.open("RposData\\onexit.rfil","r"):read("*a")) end
	os.exit()
end

funcs["info"] = function()
	print("RPOS v"..sys["version"])
	print("Made by Joshua Robbins")
	print("Current Build: "..sys["bdate"])
	print("")
end

funcs["pshdir"] = function()
	if vars == root then push("") return end
	push(table.concat(pname,"\\",2).."\\"..cpn)
end

funcs["popdir"] = function()
	local s1
	if CheckStack(1) then return end
	s1 = pop()
	vars = root
	for str in string.gmatch(s1,"[^\\]+") do
		parse(">"..str)
	end
end

funcs["root"] = function()
	vars = root
	path = {}
	pname = {}
	cpn = "root"
end

funcs["help"] = function()
	local inp
	print([[
Welcome to RPOS Interactive Help!
Tpye the name of a command or a help topic to see it's help file, or type 'exit' to quit.
]])
	while true do
		io.write(">> ")
		inp = io.read("*l")
		if inp == "exit" then break end
		if help[inp] then print(help[inp]) else print("There is no help file for "..inp..".") end
	end
end

-- Prefix declaration

pref["\'"] = function(arg)
	push(arg)
end

pref["\""] = function(arg)
	push(string.gsub(arg,sys["srcchr"],sys["repchr"]))
end

pref["$"] = function(arg)
	local v = CheckIsVar(arg)
	if not v then return end
	push(v)
end

pref["="] = function(arg)
	local args = {}
	if GetArgs(args,1) then return end
	vars[arg] = args[1]
end

pref[">"] = function(arg)
	local v
	v = CheckIsDir(arg,false,true)
	if not v then return end
	if arg == ".." then
		dir = table.remove(path)
		cpn = table.remove(pname)
		vars = dir
	else
		table.insert(path,vars)
		table.insert(pname,cpn)
		vars = v
		cpn = arg
	end
end

pref[":"] = function(arg)
	vars[arg] = {}
end

pref["~"] = function(arg)
	if not vars[arg] then err("Undefined item "..v) return end
	vars[arg] = nil
end

pref["?"] = function(arg)
	if CheckStack(1) then return end
	if pop()==1 then parse(arg) end
end

pref["@"] = function(arg)
	local i,v,d
	d = CheckIsDir(arg,true,true)
	if not d then return end
	for i,v in pairs(d) do
		print(i .. " : " .. dform(v))
	end
end

pref["#"] = function(arg)
	local c,d,i,v
	d = CheckIsDir(arg,true,true)
	if not d then return end
	c = 0
	for i,v in pairs(d) do
		c = c + 1
	end
	print(c)
end

pref["&"] = function(arg)
	print(dform(vars[arg]))
end

pref["}"] = function(arg)
	local v,tot
	tot = ""
	while true do
		v = io.read(1)
		if string.byte(v)==4 then break end
		tot = tot .. v
	end
	vars[arg] = string.sub(tot,1,-2)
end

pref["*"] = function(args)
	local f,cont,i,v,s
	f = io.open("RposData\\"..args..".rlib","r")
	cont = f:read("*a")
	lib = {}
	if not libs[args] then libs[args] = {} end
	s = loadstring(cont)
	if s then s() else err("Syntax error in library "..args) return end
	for i,v in pairs(lib) do
		funcs[i] = v
		libs[args][i] = i
		libfrom[i] = args
	end
end

pref["%"] = function(arg)
	local f,cont,i,v,s
	f = io.open("RposData\\"..arg..".rfil","r")
	cont = f:read("*a")
	parse(cont)
end

pref["+"] = function(arg)
	if not CheckIsVar(arg) then return end
	vars[arg] = vars[arg] + sys["inc"]
end

pref["-"] = function(arg)
	if not CheckIsVar(arg) then return end
	vars[arg] = vars[arg] - sys["inc"]
end

-- Add all funcs to 'core' lib and add help file

libs["core"] = {}
libs["custom"] = {}
for i,v in pairs(funcs) do
	libs["core"][i] = i
	libfrom[i] = "core"
end

-- Helper functions declaration

function GetArgs(t,n,...)
	if CheckStack(n) then return true end
	local i,v,typs
	typs = {...}
	for i=1,n do
		v = pop()
		if typs[i] == nil or type(v)==typs[i] then
			table.insert(t,v)
		else
			err("Invalid data type of argument #"..i.." of command "..cmdn)
			return true
		end
	end
end

function push(var)
	table.insert(stack,var)
	if sys["disp"]==1 then print(var) end
end

function pop()
	return table.remove(stack)
end

function CheckStack(n)
	if #stack < n then err("Not enough arguments to command "..cmdn) end
	return #stack < n
end

function peek()
	return stack[#stack]
end

function dform(v)
	if type(v) == "table" then return "<DIR>" else return v end
end

function CheckTypes(...)
	local i,v,p
	p = #stack
	for i,v in pairs({...}) do
		if type(stack[p]) ~= v then
			err("Invalid data type of argument #"..i.." of command "..cmdn)
			return true
		end
		p = p-1
	end
	return false
end

function err(msg)
	if sys["errs"] == 0 then return end
	print("ERROR: "..msg)
	sys["errmsg"] = msg
	if sys["term"] == 1 then error("RPOS: term enabled.") end
end

function prompt()
	return sys["pcf1"]..pr2()..sys["pcf3"]
end

function pr2()
	return #stack
end

function CheckIsVar(v)
	if vars[v] == nil then
		err("Undefined variable "..v)
		return false
	end
	if type(vars[v])=="table" then
		err("Invalid variable "..v.." (Var expected, got dir)")
		return false
	end
	return vars[v]
end

function CheckIsDir(v,onedot,twodot)
	if onedot and v=="." then
		return vars
	end
	if twodot and v==".." then
		if vars == root then err("Cannot go up beyond root") return false end
		return path[#path]
	end
	if vars[v] == nil then
		err("Undefined directory "..v)
		return false
	end
	if type(vars[v]) ~= "table" then
		err("Invalid directory "..v.." (Dir expected, got var)")
	end
	return vars[v]
end

function copy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function save(dd)
	local i,v,ret
	ret = "{"
	for i,v in pairs(dd) do
		ret = ret .. "[\"" .. i .."\"]="
		if type(v) == "table" then
			ret = ret .. save(v)
		elseif type(v) == "string" then
			ret = ret .. "\"" .. v .. "\""
		elseif type(v) == "number" then
			ret = ret .. v
		else
			ret = ret .. "nil"
		end
		ret = ret .. ","
	end
	ret = ret .. "}"
	return ret
end

function addhelp(filename)
	local f,c,n,v
	f = io.open("RposData\\"..filename..".rhlp")
	if not f then return end
	c = f:read("*a")
	for n,v in string.gmatch(c,"<([^<>]*)>([^<>]*)<") do
		help[n]=v
	end
end

--Main logic

function parse(inp)
	local v,i,cmds
	cmds = {}
	for v in string.gmatch(inp,"%S+") do
		table.insert(cmds,v)
	end
	for i,v in ipairs(cmds) do
		cmdn = v
		if funcs[v] then
			funcs[v]()
		elseif pref[string.sub(v,1,1)] then
			pref[string.sub(v,1,1)](string.sub(v,2))
		elseif tonumber(v) then
			push(tonumber(v))
		else
			err("Invalid command "..v)
		end
	end
end

funcs.info()
if io.open("RposData\\onstart.rfil","r") then parse(io.open("RposData\\onstart.rfil","r"):read("*a")) end
addhelp("core")

while true do
	io.write(prompt())
	inp = io.read("*l")
	pcall(parse,inp)
end
