rednet.open("back")

local base_pos = {x = 74, y = 0, z = 656}
local base_bigger_pos = {x = 141, y = 255, z = 757}
local dispacher_id = 24

while (true) do
	local pos = {gps.locate()}
	if (pos[1] >= base_pos.x and pos[1] <= base_bigger_pos.x and pos[3] >= base_pos.z and pos[3] <= base_bigger_pos.z) then
		rednet.send(dispacher_id, pos, "lights_dispacher_440")
	else os.sleep(2) end
	os.sleep(0.5)
end
