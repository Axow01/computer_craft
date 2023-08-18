rednet.open("top")

-- Here are the args you need to put in the function
-- {x = 0, y = 0, z = 0, autorized = {8, 9}, receiver_id = 3, name = "Office CTech", lpos = {x = 0, y = 0, z = 0}}
local rooms = {}
local function add_room(args)
	table.insert(rooms, args)
end

add_room({x = 94, y = 60, z = 652, autorized = nil, receiver_id = 22, name = "Reactor Laboratory", lpos = {x = 117, y = 70, z = 682}})
add_room({x = 119, y = 59, z = 691, autorized = {8, 9}, receiver_id = 3, name = "Office CTech", lpos = {x = 149, y = 66, z = 721}})

-- local base_center = {x = 0, y = 0, z = 0, autorized = {}}
-- local base_center_b = {x = 0, y = 0, z = 0}
local screen_id = 5
local phones = {}
-- local phones_id = {}

local function check_pos(pos, bigger_pos, smaller_pos)
	if (pos.x >= smaller_pos.x and pos.x <= bigger_pos.x) then
		if (pos.y >= smaller_pos.y and pos.y <= bigger_pos.y) then
			if (pos.z >= smaller_pos.z and pos.z <= bigger_pos.z) then
				return true
			end
		end
	end
	return false
end

local function check_autorization(room, sender_id)
	if (room.autorized == nil) then return true end
	for i = 1, #room.autorized do
		if (room.autorized[i] == sender_id) then
			return true
		end
	end
	return false
end

local function check_all(phone_pos, room, room_b, sender_id)
	if (check_pos(phone_pos, room_b, room)) then
		if (check_autorization(room, sender_id)) then
			rednet.send(room.receiver_id, true, "lights_activation_440")
		else
			rednet.send(room.receiver_id, "alarm", "lights_activation_440")
		end
		return true
	end
	return false
end

local function close_lights(phones, room, room_b)
	local status = false
	for i = 1, #phones do
		if (check_pos(phones[i][2], room_b, room)) then status = true end
	end
	if (status == false) then
		rednet.send(room.receiver_id, false, "lights_activation_440")
	end
end

local function add_phone(sender_id, pos)
	for i = 1, #phones do
		if (phones[i][1] == sender_id) then
			phones[i][2] = pos
			return
		end
	end
	table.insert(phones, {sender_id, pos})
end

term.clear()
term.setCursorBlink(false)
term.setCursorPos(1, 1)
term.setTextColor(colors.green)
term.write("ID: "..os.getComputerID().."\n")
term.setCursorPos(2, 1)

while (true) do
	local sender_id, message, distance_or_protocol = rednet.receive("lights_dispacher_440")
	local pos = {x = message[1], y = message[2], z = message[3]}

	add_phone(sender_id, pos)
	for i = 1, #rooms do
		check_all(pos, rooms[i], rooms[i].lpos, sender_id)
		close_lights(phones, rooms[i], rooms[i].lpos)
	end
	rednet.send(screen_id, {phones, rooms}, "lights_dispacher_440")
end
