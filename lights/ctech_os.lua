rednet.open("back")
-- // test
local args = {...}

-- local os = args[1]
-- local shell = args[2]
-- local multishell = args[3]
local updateFiles = args[1]

local base_pos = {x = 40, y = 0, z = 594}
local base_bigger_pos = {x = 220, y = 0, z = 774}
local dispacher_id = 24
local pastebin_code = "ELZBcwXG"
local path = shell.getRunningProgram()
local version = "3.3"

function update()
	term.clear()
	term.setTextColor(colors.green)
	term.setCursorPos(2, 2)
	term.write("Update Required.. PLS wait")
	os.sleep(2)
	term.clear()
	os.run({shell = shell, exit = os.exit, multishell = multishell}, "rom/programs/http/pastebin.lua", "get", pastebin_code, "ctech_os_tmp.lua")
	multishell.launch({shell = shell, exit = os.exit, multishell = multishell}, "ctech_os_tmp.lua", true)
	exit()
end

function get_dispacher_order()
	local sender_id, message, distance_protocol = rednet.receive("ctech_phones_440", 1)
	if (sender_id == dispacher_id) then
		local cmd = {cmd = message[1], active = message[2]}
		if (cmd.cmd == "continue") then return end
		if (cmd.cmd == "shutdown" and cmd.active) then os.shutdown() end
		if (cmd.cmd == "update" and cmd.active) then update() end
	end
end

if (updateFiles == true) then
	print("updating files...")
	shell.run("rm", "ctech_os.lua")
	shell.run("rename", "ctech_os_tmp.lua", "ctech_os.lua")
	os.reboot()
end

while (true) do
	local pos = {gps.locate()}
	if (pos[1] ~= nil and pos[2] ~= nil and pos[3] ~= nil) then
		if (pos[1] >= base_pos.x and pos[1] <= base_bigger_pos.x and pos[3] >= base_pos.z and pos[3] <= base_bigger_pos.z) then
			rednet.send(dispacher_id, {pos, version}, "lights_dispacher_440")
			get_dispacher_order()
		else os.sleep(2) end
	end
	os.sleep(0.1)
end
