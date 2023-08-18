rednet.open("back")

local base_pos = {x = 74, y = 0, z = 656}
local base_bigger_pos = {x = 141, y = 255, z = 757}
local dispacher_id = 24
local pastebin_code = "ELZBcwXG"

function update()
	os.run({}, "pastebin", "get", pastebin_code, "ctech_os_tmp.lua")
	multishell.launch({}, "ctech_os_tmp.lua")
	os.exit(0, true)
end

function get_dispacher_order()
	local sender_id, message, distance_protocol = rednet.receive("ctech_phones_440", 0.5)
	if (sender_id == dispacher_id) then
		local cmd = {cmd = message[1], active = message[2]}
		if (cmd.cmd == "shutdown" and cmd.active) then os.shutdown() end
		if (cmd.cmd == "update" and cmd.active) then update() end
	end
end

while (true) do
	local pos = {gps.locate()}
	if (pos[1] >= base_pos.x and pos[1] <= base_bigger_pos.x and pos[3] >= base_pos.z and pos[3] <= base_bigger_pos.z) then
		rednet.send(dispacher_id, pos, "lights_dispacher_440")
	else os.sleep(2) end
	os.sleep(0.5)
end
