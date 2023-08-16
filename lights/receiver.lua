
rednet.open("left")

local dispacher_id = 24

term.clear()
term.setCursorPos(1, 1)
term.setCursorBlink(false)
term.setTextColor(colors.green)
term.write("Receiver: "..os.getComputerID())

while (true) do
	local sender_id, message, distance_or_protocol = rednet.receive("lights_activation_440")
	if (dispacher_id == 3) then
		if (message == true) then redstone.setAnalogOutput("back", 15)
		elseif (message == false) then redstone.setAnalogOutput("back", 0)
		elseif (message == "alarm") then print("alarm not handled here.") end
	end
end
