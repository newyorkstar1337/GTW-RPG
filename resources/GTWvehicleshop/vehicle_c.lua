--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

--[[ Create global vehicle data storage for clients ]]--
currentVehID = nil
veh_data_list = {{ }}
row,col = nil,nil

--[[ Create vehicle management GUI ]]--
x,y = guiGetScreenSize()
window = guiCreateWindow((x-600)/2, (y-400)/2, 600, 400, "Vehicle manager", false)
guiWindowSetMovable(window, true)
guiWindowSetSizable(window, false)
btn_show = guiCreateButton(10, 350, 90, 30, "Show", false, window)
btn_hide = guiCreateButton(100, 350, 90, 30, "Hide", false, window)
btn_lock = guiCreateButton(200, 350, 90, 30, "Lock", false, window)
btn_engine = guiCreateButton(290, 350, 90, 30, "Engine", false, window)
btn_recover = guiCreateButton(380, 350, 90, 30, "Recover", false, window)
btn_sell = guiCreateButton(470, 350, 90, 30, "Sell", false, window)
guiSetVisible( window, false )

--[[ Create the vehicle grid list ]]--
vehicle_list = guiCreateGridList( 10, 23, 580, 325, false, window )
col1 = guiGridListAddColumn( vehicle_list, "Name", 0.25 )
col2 = guiGridListAddColumn( vehicle_list, "Health", 0.1 )
col3 = guiGridListAddColumn( vehicle_list, "Fuel", 0.1 )
col4 = guiGridListAddColumn( vehicle_list, "Locked", 0.1 )
col5 = guiGridListAddColumn( vehicle_list, "Engine", 0.1 )
col6 = guiGridListAddColumn( vehicle_list, "Location", 0.3 )
guiGridListSetSelectionMode( vehicle_list, 0 )

--[[ Create vehicle trunk GUI ]]--
window_trunk = guiCreateWindow((x-600)/2, (y-400)/2, 600, 400, "Vehicle inventory", false)
guiWindowSetMovable(window_trunk, true)
guiWindowSetSizable(window_trunk, false)
btn_withdraw = guiCreateButton(10, 350, 110, 30, "Withdraw", false, window_trunk)
btn_deposit = guiCreateButton(120, 350, 110, 30, "Deposit", false, window_trunk)
btn_close = guiCreateButton(500, 350, 90, 30, "Close", false, window_trunk)
guiSetVisible( window_trunk, false )

--[[ Create the trunk grid list ]]--
label_vehicle = guiCreateLabel( 10, 23, 250, 20, "Vehicle trunk", false, window_trunk )
label_player = guiCreateLabel( 302, 23, 250, 20, "Your pocket", false, window_trunk )
inventory_list = guiCreateGridList( 10, 43, 288, 305, false, window_trunk )
player_items_list = guiCreateGridList( 302, 43, 288, 305, false, window_trunk )
col7 = guiGridListAddColumn( inventory_list, "Item", 0.46 )
col8 = guiGridListAddColumn( inventory_list, "Amount", 0.46 )
col9 = guiGridListAddColumn( player_items_list, "Item", 0.46 )
col10 = guiGridListAddColumn( player_items_list, "Amount", 0.46 )
guiGridListSetSelectionMode( inventory_list, 0 )
guiGridListSetSelectionMode( player_items_list, 0 )

--[[ Create a function to handle toggling of vehicle GUI ]]--
function toggleGUI( source )
	-- Show the vehicle GUI
	if not guiGetVisible( window ) then
		showCursor( true )
		guiSetVisible( window, true )
		guiSetInputEnabled( true )
		triggerServerEvent( "acorp_onListVehicles", localPlayer ) 
	else
		showCursor( false )
		guiSetVisible( window, false )
		guiSetInputEnabled( false )
	end
end 
addCommandHandler( "vehicles", toggleGUI )
bindKey( "F2", "down", "vehicles" )

--[[ Create a function to handle toggling of vehicle inventory GUI ]]--
function toggleInventoryGUI( source )
	-- Show the vehicle inventory GUI
	if getElementData(localPlayer,"isNearTrunk") then
		if not guiGetVisible( window_trunk ) then
			showCursor( true )
			guiSetVisible( window_trunk, true )
			guiSetInputEnabled( true )
			loadWeaponsToList() 
			setVehicleDoorOpenRatio( getElementData(localPlayer,"isNearTrunk"), 1, 1, 1000 )
		else
			showCursor( false )
			guiSetVisible( window_trunk, false )
			guiSetInputEnabled( false )
			setVehicleDoorOpenRatio( getElementData(localPlayer,"isNearTrunk"), 1, 0, 1000 )
		end
	end
end 
addCommandHandler( "inventory", toggleInventoryGUI )
bindKey( "F4", "down", "inventory" )

function loadWeaponsToList()
	if col7 and col8 and col9 and col10 then
		local weapons = getPedWeapons(localPlayer)
		guiGridListClear( player_items_list )
		guiGridListClear( inventory_list )
		for i,wep in pairs(getPedWeapons(localPlayer)) do
			local row = guiGridListAddRow( player_items_list )
			local slot = getSlotFromWeapon(wep)
			guiGridListSetItemText( player_items_list, row, col9, getWeaponNameFromID(wep), false, false )
			guiGridListSetItemText( player_items_list, row, col10, getPedTotalAmmo(localPlayer,slot), false, false )
		end
	end
end

function receiveVehicleData(data_table)
	if col1 and col2 and col3 and col4 and col5 and col6 then
		-- Clear and refresh
		guiGridListClear( vehicle_list )
		veh_data_list = data_table
		
		-- Load vehicles to list
		for id, veh in pairs(data_table) do
			local row = guiGridListAddRow( vehicle_list )
			guiGridListSetItemText( vehicle_list, row, col1, getVehicleNameFromModel(data_table[id][2]), false, false )
			if currentVehID == tonumber(data_table[id][1]) then
				guiGridListSetItemColor( vehicle_list, row, col1, 100, 100, 255 )
			end
			guiGridListSetItemText( vehicle_list, row, col2, data_table[id][3], false, false )
			if data_table[id][3] > 70 then
				guiGridListSetItemColor( vehicle_list, row, col2, 0, 255, 0 )
			elseif data_table[id][3] > 30 then
				guiGridListSetItemColor( vehicle_list, row, col2, 255, 200, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col2, 255, 0, 0 )
			end
			guiGridListSetItemText( vehicle_list, row, col3, data_table[id][4], false, false )
			if data_table[id][4] > 80 then
				guiGridListSetItemColor( vehicle_list, row, col3, 0, 255, 0 )
			elseif data_table[id][4] > 20 then
				guiGridListSetItemColor( vehicle_list, row, col3, 255, 200, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col3, 255, 0, 0 )
			end
			local locked = "Open"
			if data_table[id][5] == 1 then
				locked = "Yes"
			end
			guiGridListSetItemText( vehicle_list, row, col4, locked, false, false )
			if data_table[id][5] == 1 then
				guiGridListSetItemColor( vehicle_list, row, col4, 0, 255, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col4, 255, 200, 0 )
			end
			local engine = "Off"
			if data_table[id][6] == 1 then
				engine = "On"
			end
			guiGridListSetItemText( vehicle_list, row, col5, engine, false, false )
			if data_table[id][6] == 1 then
				guiGridListSetItemColor( vehicle_list, row, col5, 0, 255, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col5, 255, 0, 0 )
			end
			local x,y,z, rx,ry,rz = unpack( fromJSON( data_table[id][7] ))
			local location = getZoneName(x,y,z)
			local city = getZoneName(x,y,z,true)
			guiGridListSetItemText( vehicle_list, row, col6, location.." ("..city..")", false, false )
			local px,py,pz = getElementPosition(localPlayer)
			local dist = getDistanceBetweenPoints3D( x,y,z, px,py,pz )
			if dist < 180 then
				guiGridListSetItemColor( vehicle_list, row, col6, 0, 255, 0 )
			else
				guiGridListSetItemColor( vehicle_list, row, col6, 255, 200, 0 )
			end
		end
	end
end
addEvent( "acorp_onReceivePlayerVehicleData", true )
addEventHandler( "acorp_onReceivePlayerVehicleData", root, receiveVehicleData )

--[[ Toggle vehicle visibility on click ]]--
addEventHandler("onClientGUIClick",vehicle_list,
function()
	row,col = guiGridListGetSelectedItem( vehicle_list )
	if row and col and veh_data_list[row+1] then	
		currentVehID = veh_data_list[row+1][1]
		for w=0, #veh_data_list do
			guiGridListSetItemColor( vehicle_list, w, col1, 255, 255, 255 )
		end
		guiGridListSetItemColor( vehicle_list, row, col1, 100, 100, 255 )
		guiGridListSetSelectedItem( vehicle_list, 0, 0)
	end
end)

--[[ Options in the button menu ]]--
addEventHandler( "onClientGUIClick", root,
function ( )
	if source == btn_show and currentVehID then
		triggerServerEvent( "acorp_onShowVehicles", localPlayer, currentVehID ) 	
	elseif source == btn_hide and currentVehID then
		triggerServerEvent( "acorp_onHideVehicles", localPlayer, currentVehID ) 
	elseif source == btn_lock and currentVehID then
		-- Update vehiclelist and lock status		
		if guiGridListGetItemText( vehicle_list, row, col4 ) == "Yes" then
			triggerServerEvent( "acorp_onLockVehicle", localPlayer, currentVehID, 0 )
			guiGridListSetItemText( vehicle_list, row, col4, "Open", false, false )
			guiGridListSetItemColor( vehicle_list, row, col4, 255, 200, 0 )
		else
			triggerServerEvent( "acorp_onLockVehicle", localPlayer, currentVehID, 1 )
			guiGridListSetItemText( vehicle_list, row, col4, "Yes", false, false )
			guiGridListSetItemColor( vehicle_list, row, col4, 0, 255, 0 )
		end	
	elseif source == btn_engine and currentVehID then
		-- Update vehiclelist and engine status		
		if guiGridListGetItemText( vehicle_list, row, col5 ) == "On" then
			triggerServerEvent( "acorp_onVehicleEngineToggle", localPlayer, currentVehID, 0 )
			guiGridListSetItemText( vehicle_list, row, col5, "Off", false, false )
			guiGridListSetItemColor( vehicle_list, row, col5, 255, 0, 0 )
		else
			triggerServerEvent( "acorp_onVehicleEngineToggle", localPlayer, currentVehID, 1 )
			guiGridListSetItemText( vehicle_list, row, col5, "On", false, false )
			guiGridListSetItemColor( vehicle_list, row, col5, 0, 255, 0 )
		end	
	elseif source == btn_close then
		showCursor( false )
		guiSetVisible( window_trunk, false )
		guiSetInputEnabled( false )
		setVehicleDoorOpenRatio( getElementData(localPlayer,"isNearTrunk"), 1, 0, 1000 )
	elseif source == btn_recover and currentVehID then
		triggerServerEvent( "acorp_onVehicleRespawn", localPlayer, currentVehID )
	elseif source == btn_sell and currentVehID then
		triggerServerEvent( "acorp_onVehicleSell", localPlayer, currentVehID, veh_data_list[row+1][2] )
		guiGridListRemoveRow( vehicle_list, row )
		currentVehID = nil			
	end
end)

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end
