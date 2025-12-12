dofile("actor_list.lua")

local actor_pos_offset = {
	OoT=0x24,
	MM=0x24,
	AF=0x5C,
}
local actor_codeentry_offset = {
	OoT=0x138,
	MM=0x140,
	AF=0x170,
}

bgId_offset = 0x13C

-- Heap node structure
function node_valid(addr)
	return mainmemory.read_u16_be(addr-0x80000000) == 0x7373
end
function node_isfree(addr)
	return mainmemory.read_u16_be(addr-0x80000000+2)
end
function node_blocksize(addr)
	return mainmemory.read_u32_be(addr-0x80000000+4)
end
function node_next(addr)
	return mainmemory.read_u32_be(addr-0x80000000+8)
end
function node_prev(addr)
	return mainmemory.read_u32_be(addr-0x80000000+0xC)
end


heap_start = nil
overlay_table = nil

--find the heap
while true do
	for i=0,0x7FFFF0,0x10 do
		if mainmemory.read_u32_be(i) == 0x73730000 and
		   mainmemory.read_u32_be(i+0x4) > 0 and
		   mainmemory.read_u32_be(i+0x4) < 0x1000 and
		   mainmemory.read_u32_be(i+0x8) > 0x80000000 and
		   mainmemory.read_u32_be(i+0x8) < 0x80800000 and
		   mainmemory.read_u32_be(i+0xC) == 0 then
			
			heap_start = 0x80000000 + i
			
			arena_ptr = mainmemory.read_u32_be(i+0x1C)
			if 0x80000000 <= arena_ptr and arena_ptr < 0x80800000 and mainmemory.read_u32_be(arena_ptr-0x80000000) == heap_start then
				header_size = 0x30
			else
				header_size = 0x10
			end
			first_alloc_size = mainmemory.read_u32_be(i+0x4)
			game="OoT"
			if first_alloc_size < 0x600 then
				game = "AF"
			elseif first_alloc_size < 0xC00 then
				game = "OoT"
			else
				game = "MM"
			end
			if game == "OoT" then
				bgId_offset = 0x13C
			elseif game == "MM" then
				bgId_offset = 0x144
				
			end
			
			local node = heap_start
			while overlay_table == nil and node_valid(node) and node_next(node) ~= 0 do
				local possibly_overlay_table = mainmemory.read_u32_be(node+header_size+actor_codeentry_offset[game]-0x80000000)
				if possibly_overlay_table > 0x80000000 and possibly_overlay_table < 0x80800000 then
					overlay_table = possibly_overlay_table
				end
				node = node_next(node)
			end
			print(string.format("Heap found at %X (header_size=%X, game=%s), overlay table found at %X",heap_start,header_size,game,overlay_table))
			break
		end
	end
	
	if heap_start ~= nil then
		break -- Zelda heap found!
	else
		for i=1,100 do
			emu.frameadvance()
		end
	end
end

function probably_a_float(val)
	return val == 0 or val == 0x80000000 or (val >= 0x38000000 and val <= 0x4c000000) or (val >= 0xb8000000 and val <= 0xcc000000)
end

function summarize_node(header_addr)
	-- Heuristically try to figure out what this node actually is.
	local data_addr = header_addr + header_size
	local first_u16 = mainmemory.read_u16_be(data_addr-0x80000000)
	local first_u32 = mainmemory.read_u32_be(data_addr-0x80000000)
	
	local maybe_xpos = mainmemory.read_u32_be(data_addr-0x80000000+actor_pos_offset[game])
	local maybe_ypos = mainmemory.read_u32_be(data_addr-0x80000000+actor_pos_offset[game]+4)
	local maybe_zpos = mainmemory.read_u32_be(data_addr-0x80000000+actor_pos_offset[game]+8)
	if probably_a_float(maybe_xpos) and probably_a_float(maybe_ypos) and probably_a_float(maybe_zpos) and first_u16 <= #actor_defs[game] and first_u32 > 0 then
		return string.format("Actor %04X", first_u16)
	end
	if overlay_map[data_addr] then
		--return string.format("Overlay %04X %s", overlay_map[data_addr], actor_defs[game][overlay_map[data_addr]])
		return string.format("Overlay %04X", overlay_map[data_addr])
	end
	if first_u16 == 0x27BD or (first_u16 >= 0xAFA4 and first_u16 <= 0xAFA7) then
		return "Unknown Code"
	end
	if game == "OoT" and node_blocksize(header_addr) == 0x2010 then
		return "Get Item Object"
	end
	if game == "MM" and node_blocksize(header_addr) == 0x2000 then
		return "Get Item Object"
	end
	if game == "MM" and node_blocksize(header_addr) == 0x3800 then
		return "Worn Mask Object"
	end
	
	--No idea what it is
	if node_isfree(header_addr) > 0 then
		return "Nothing"
	else
		return "??? Unknown ???"
	end
end

function node_is_dynaPoly(header_addr)
	local summary = summarize_node(header_addr)
	local description = summary
	local data_addr = header_addr + header_size
	local actorId = tonumber(string.sub(description, -4), 16)
	local val = ""
	if actorId ~= nil and string.find(summary, "Actor") then
		local actor_name = actor_defs[game][actorId]
		if actor_name ~= "Door_Shutter" then
			local actor_desc = actor_defs[game.."_Names"][actorId]
			local found = false
			for _,v in pairs(dynaPolyActors) do
				if v == string.lower(actor_name) and game == "OoT" then
					found = true
					break
				end
			end
			
			if found or game == "MM" then
				--print(string.lower(actor_name))
				category = mainmemory.read_u8(data_addr+0x2-0x80000000)
				bgId = mainmemory.read_u32_be(data_addr+bgId_offset-0x80000000)
				params = mainmemory.read_u16_be(data_addr+0x1C-0x80000000)
				if bgId == 4294967295 then
					bgId = -1
				end
				if game == "OoT" or (game == "MM" and (category == 1 or category == 11) and actor_name ~= "Elf_Msg2") then 
					if actor_name == "Bg_Spot18_Obj" and params == 1 then
						actor_desc = "Goron Spear"
					elseif actor_name == "Bg_Spot18_Obj" and params == 0xFF00 then
						actor_desc = "Goron Statue"
					end
					val = actor_desc.." "..bgId.." "..string.format("0x%X", data_addr) --.." "..string.format("0x%X", params)
				end
			end
		end
	end
	
	return val
end

function describe_node(header_addr)
	local summary = summarize_node(header_addr)
	local description = summary
	local data_addr = header_addr + header_size
	
	local actorId = tonumber(string.sub(description, -4), 16)
	if actorId ~= nil then
		if game == "OoT" then
			description = description.." "..actor_defs[game][actorId].." - "..actor_defs[game.."_Names"][actorId]
		else
			description = description.." "..actor_defs[game][actorId]
		end
	end
	if node_tracking[summary] ~= nil and next(node_tracking[summary]) ~= nil then
		description = description.." -"
		for k,v in pairs(node_tracking[summary]) do
			local varValue
			if v%4 == 0 then
				varValue = mainmemory.read_u32_be(data_addr+v-0x80000000)
				description = description..string.format(" 0x%X(%X)=%08X", v, data_addr+v, varValue)
			elseif v%2 == 0 then
				varValue = mainmemory.read_u16_be(data_addr+v-0x80000000)
				description = description..string.format(" 0x%X(%X)=%04X", v, data_addr+v, varValue)
			else
				varValue = mainmemory.readbyte(data_addr+v-0x80000000)
				description = description..string.format(" 0x%X(%X)=%X", v, data_addr+v, varValue)
			end
		end
	end
	return description
end

function track(node_summary, vars)
	if vars == nil then vars = {} end
	node_tracking[node_summary] = vars
	return nil
end

function trackaddr(addr, val)
	if addr < 0x80000000 then addr = addr + 0x80000000 end
	if val == nil then val = true end
	address_tracking[addr] = val
	return nil
end

client.SetGameExtraPadding(300,120,0,0)

event.onexit(function()
	client.SetGameExtraPadding(0,0,0,0)
	gui.clearGraphics()
end)

print("Usage: Click and drag to zoom. Use scroll wheel, middle-click, or X button to unzoom.\n"..
	"Click an actor in the heap to track actors of that type.\n"..
	"To track custom node offsets, type e.g. track('Overlay 009B',{0x5E6}) in console.\n"..
	"To track arbitrary addresses, type e.g. trackaddr(0x80000000, true) in console.\n")

local scrollbar_size = 20
local heapviz_size = 50
local reset_box_size = 20

local dragging_mouse = false
local dragging_mouse_for_scrollbar = false
local dragstart_x
if zoom_begin == nil then zoom_begin = 0 end
if zoom_end == nil then zoom_end = 1 end
if node_tracking == nil then node_tracking = {} end --global
if address_tracking == nil then address_tracking = {} end --global
local oldmouse = input.getmouse()
local inputs
local prev_inputs = input.get()
overlay_map = {}
while true do
	
	if emu.framecount() % 3 == 0 or client.ispaused() then

		--run through the current values of the game's overlay table
		for actorId=0,#actor_defs[game] do
			local loaded_ovl_pointer = mainmemory.read_u32_be(overlay_table-0x80000000+(0x20*actorId)+0x10)
			if loaded_ovl_pointer > 0 then
				overlay_map[loaded_ovl_pointer] = actorId
			end
		end
		
		--locate size and end of heap
		local node = heap_start
		while node_valid(node) and node_next(node) ~= 0 do
			node = node_next(node)
		end
		local heap_end = node + header_size + node_blocksize(node) -- varies per scene
		local heapsize = heap_end - heap_start
		
		-- Draw the heap
		local scale = 1/heapsize*client.screenwidth()/(zoom_end-zoom_begin)
		local offset = zoom_begin / (zoom_end-zoom_begin) * client.screenwidth()
		prev_inputs = inputs
		inputs = input.get()
		
		gui.use_surface("client")
		
		if node_valid(heap_start) then
			
			local mouse = input.getmouse() -- get mouse info (position, buttons pressed)
			local x_native = client.borderwidth()+mouse.X*(client.screenwidth()-2*client.borderwidth())/client.bufferwidth()
			local y_native = client.borderheight()+mouse.Y*(client.screenheight()-2*client.borderheight())/client.bufferheight()
			local y_dyna = 140
			
			local mouse_in_range = x_native >= 0 and x_native <= client.screenwidth() and y_native >= 0 and y_native <= client.screenheight()
			
			local just_released_drag = false
			if dragging_mouse and not mouse.Left then
				dragging_mouse = false
				local scale = zoom_end-zoom_begin
				if y_native > scrollbar_size and dragstart_x + 10 < x_native then
					zoom_end = zoom_begin + x_native / client.screenwidth() * scale
					zoom_begin = zoom_begin + dragstart_x / client.screenwidth() * scale
					just_released_drag = true
				elseif y_native > scrollbar_size and x_native + 10 < dragstart_x then
					local scale = zoom_end-zoom_begin
					zoom_end = zoom_begin + dragstart_x / client.screenwidth() * scale
					zoom_begin = zoom_begin + x_native / client.screenwidth() * scale
					just_released_drag = true
				elseif y_native > scrollbar_size+heapviz_size and y_native < scrollbar_size+heapviz_size+reset_box_size and x_native > client.screenwidth()-reset_box_size and x_native < client.screenwidth() then
					zoom_begin = 0
					zoom_end = 1
					just_released_drag = true
				end
				if zoom_begin < 0 then zoom_begin = 0 end
				if zoom_end > 1 then zoom_end = 1 end
			end
			
			gui.drawBox(0,0,client.screenwidth(),scrollbar_size, 0x80000000, 0x80E0E0E0) -- draw the scroll bar
			gui.drawBox(client.screenwidth()*zoom_begin,0,client.screenwidth()*zoom_end,scrollbar_size, 0x80000000, 0x80E0E0E0) -- draw the scoll bar backgorund?
			
			gui.drawBox(client.screenwidth()-reset_box_size,scrollbar_size+heapviz_size,client.screenwidth(),scrollbar_size+heapviz_size+reset_box_size,0x80000000,0x80C0C0C0)
			gui.drawLine(client.screenwidth()-reset_box_size,scrollbar_size+heapviz_size,client.screenwidth(),scrollbar_size+heapviz_size+reset_box_size,0x80000000)
			gui.drawLine(client.screenwidth()-reset_box_size,scrollbar_size+heapviz_size+reset_box_size,client.screenwidth(),scrollbar_size+heapviz_size,0x80000000)
			
			gui.drawBox(-offset, scrollbar_size, heapsize*scale - offset, scrollbar_size+heapviz_size, 0x80000000, 0xFF00FF00)
			node = heap_start
			local node_to_show = nil
			local printed_lines_count = 0
			local lines_to_print = ""
			
			-- Loop through the heap nodes
			while node ~= 0 and node_valid(node) do
				local x = (node-heap_start)*scale - offset
				local x2 = (node+header_size+node_blocksize(node)-heap_start)*scale - offset
				local node_summary = summarize_node(node)
				if node_isfree(node) > 0 then
					gui.drawBox(x, scrollbar_size, x2, scrollbar_size+heapviz_size, 0x80000000, 0xFFFF0000)
				elseif node_tracking[node_summary] ~= nil then
					gui.drawBox(x, scrollbar_size, x2, scrollbar_size+heapviz_size, 0x80000000, 0xFF00FFFF)
					gui.drawText(0,scrollbar_size+heapviz_size+45+15*printed_lines_count, string.format("%X - %s", node+header_size, describe_node(node)))
					printed_lines_count = printed_lines_count + 1
					
				else
					gui.drawLine(x, scrollbar_size, x, scrollbar_size+heapviz_size, 0x80000000)
					dynaDesc = node_is_dynaPoly(node)
					if dynaDesc ~= "" then
						gui.drawText(0, y_dyna, dynaDesc, nil, nil, 12)
						y_dyna = y_dyna + 20
					end
				end
				
				-- Pressing "g" key will print the whole heap
				if inputs.G and not prev_inputs.G then
					lines_to_print=lines_to_print..string.format("header:%X data:%X free:%X blocksize:%X next_addr:%X prev_addr:%X - %s\n", node, node+header_size, node_isfree(node), node_blocksize(node), node_next(node), node_prev(node), describe_node(node))
				end
				
				-- Pressing "h" key will print info for the currently selected actor
				if inputs.H and not prev_inputs.H then
					local actorid = mainmemory.read_u16_be(node+header_size-0x80000000)
					if node_tracking[node_summary] ~= nil and node_isfree(node) == 0 then
						lines_to_print=lines_to_print..string.format("header:%X data:%X free:%X blocksize:%X next_addr:%X prev_addr:%X - %s\n", node, node+header_size, node_isfree(node), node_blocksize(node), node_next(node), node_prev(node), describe_node(node))
					end
				end
				
				
				if mouse_in_range and y_native > scrollbar_size and y_native < scrollbar_size+heapviz_size and x <= x_native and x_native <= x2 then
					node_to_show = node
					--if not mouse.Left and oldmouse.Left and not just_released_drag then
					--	local actorid = mainmemory.read_u16_be(node+header_size-0x80000000)
					--	if node_tracking[node_summary] ~= nil then
					--		node_tracking[node_summary] = nil
					--	elseif node_isfree(node) == 0 then
					--		node_tracking[node_summary] = {}
					--		print(string.format("To track custom node offsets, type e.g. track('%s', {0x32,0xBE}) in console",node_summary))
					--	end
					--end
				end
				
				node = node_next(node)
			end
			-- End loop through the heap nodes
			
			if lines_to_print ~= "" then
				print(lines_to_print)
			end
			
			
			if not dragging_mouse and mouse_in_range then
				if mouse.Left then
					if y_native < scrollbar_size or dragging_mouse_for_scrollbar then
						dragging_mouse_for_scrollbar = true
						local new_centerpoint = x_native/client.screenwidth()
						local distance = (zoom_end-zoom_begin)/2
						if new_centerpoint < distance then new_centerpoint = distance end
						if new_centerpoint > 1-distance then new_centerpoint = 1-distance end
						zoom_begin = new_centerpoint - distance
						zoom_end = new_centerpoint + distance
					else
						dragging_mouse = true
						dragstart_x = x_native
					end
				elseif mouse.Middle then
					zoom_begin = 0
					zoom_end = 1
				else
					dragging_mouse_for_scrollbar = false
				end
			end
			if dragging_mouse then
				if x_native < 0 then x_native = 0 end
				if x_native > client.screenwidth() then x_native = client.screenwidth() end
				gui.drawBox(dragstart_x,scrollbar_size,x_native,scrollbar_size+heapviz_size, 0xC00000FF, 0xC000FFFF)
			end
			
			if mouse.Wheel ~= oldmouse.Wheel then
				if mouse.Wheel < oldmouse.Wheel then -- zoom out
					zoom_begin = zoom_begin - 0.1
					zoom_end = zoom_end + 0.1
				elseif mouse.Wheel > oldmouse.Wheel then -- zoom in
					local newzoom_center = x_native / client.screenwidth()
					if newzoom_center < zoom_begin then newzoom_center = zoom_begin end
					if newzoom_center > zoom_end then newzoom_center = zoom_end end
					zoom_begin = newzoom_center-(newzoom_center-zoom_begin)/1.5
					zoom_end = newzoom_center+(zoom_end-newzoom_center)/1.5
				end
				if zoom_begin < 0 then zoom_begin = 0 end
				if zoom_end > 1 then zoom_end = 1 end
			end
			
			if next(node_tracking) ~= nil then
				local tracked_str = "Tracked nodes:"
				for k,v in pairs(node_tracking) do
					if v then
						tracked_str = tracked_str..string.format(' %s,',k)
					end
				end
				tracked_str = tracked_str:sub(1, -2) --remove trailing comma
				gui.drawText(0,scrollbar_size+heapviz_size+15, tracked_str)
			end
			
			if node_to_show then
				local coord = x_native
				local str_to_draw = string.format("header: %X\ndata: %X\nfree: %X\nblocksize: %X\nnext_addr: %X\nprev_addr: %X\n\n%s", node_to_show, node_to_show+header_size, node_isfree(node_to_show), node_blocksize(node_to_show), node_next(node_to_show), node_prev(node_to_show), describe_node(node_to_show))
				local dir = "left"
				if x_native > client.screenwidth()*0.6 then
					dir = "right"
				end
				gui.drawText(x_native, y_native+25, str_to_draw, nil, nil, 12, nil, nil, dir)
			end
			
			for addr,v in pairs(address_tracking) do
				if v then
					local varValue
					if addr%4 == 0 then
						varValue = mainmemory.read_u32_be(addr-0x80000000)
						gui.drawText(0,scrollbar_size+heapviz_size+60+15*printed_lines_count, string.format("Tracked addr %X - %08X", addr, varValue))
					elseif addr%2 == 0 then
						varValue = mainmemory.read_u16_be(addr-0x80000000)
						gui.drawText(0,scrollbar_size+heapviz_size+60+15*printed_lines_count, string.format("Tracked addr %X - %04X", addr, varValue))
					else
						varValue = mainmemory.readbyte(addr-0x80000000)
						gui.drawText(0,scrollbar_size+heapviz_size+60+15*printed_lines_count, string.format("Tracked addr %X - %02X", addr, varValue))
					end
					printed_lines_count = printed_lines_count + 1
				end
			end
			
			oldmouse = mouse
		end
	
	end
	
	emu.frameadvance()
end
