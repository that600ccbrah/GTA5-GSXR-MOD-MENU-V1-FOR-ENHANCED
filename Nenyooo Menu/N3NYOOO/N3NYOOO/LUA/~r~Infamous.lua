
gui.pushNotification("Welcome", "This infamous lua is an example lua for N3NY000")

local states = {
    god_mode = false,
    godmode_init = false,
    invisible = false,
    invisible_init = false,

    supercar = false,

    dirtLevel = 0
}
 
function mainScript()
   if states.god_mode then
       if not states.godmode_init then  
           states.godmode_init = true
           ENTITY.SET_ENTITY_INVINCIBLE(util.getLocalPlayerHandle(), true)
       end
   else
       if states.godmode_init then 
           ENTITY.SET_ENTITY_INVINCIBLE(util.getLocalPlayerHandle(), false)
           states.godmode_init = false
       end
   end
  
   if states.invisible then
       states.invisible_init = true
       ENTITY.SET_ENTITY_VISIBLE(util.getLocalPlayerHandle(), false,false)
   else
       if states.invisible_init then 
           ENTITY.SET_ENTITY_VISIBLE(util.getLocalPlayerHandle(), true, true)
           states.invisible_init = false
       end
   end
end

script.addScript(mainScript)


gui.createMainTab("~r~Infamous")

gui.addSub("Player","Player related options.",0,function() end)
gui.addSub("Vehicle","Vehicle related options.",1,function() end)
gui.addSub("Recovery","Recovery related options.",2,function() end)


gui.createSubTab("Player",0)
gui.addToggle("God Mode", "Toggles invincibility.", states.god_mode, function()
 states.god_mode = not states.god_mode
if states.god_mode then
    gui.pushNotification("God mode", "God mode is now enabled!")
    else
    gui.pushNotification("God mode", "God mode is now disabled!")
 end

end)

gui.addToggle("Invisible Mode", "Toggles invisibility.", states.invisible, function()
 states.invisible = not states.invisible
if states.invisible then
    gui.pushNotification("Invisible", "Invisible is now enabled!")
    else
    gui.pushNotification("Invisible", "Invisible is now disabled!")
 end

end)

function vehicleSuperMode()
   if states.supercar then
      VEHICLE.SET_VEHICLE_FIXED(util.getLocalVehicleHandle())
   end
end

script.addScript(vehicleSuperMode)


gui.createSubTab("Vehicle",1)
gui.addToggle("Super Car", "Your car becomes stronger.", states.supercar, function()
 states.supercar = not states.supercar
if states.supercar then
    gui.pushNotification("Super Car", "Super Car is now enabled!")
    else
    gui.pushNotification("Super Car", "Super Car is now disabled!")
 end

end)



gui.addInt("Dirt Level", "Adjust dirtness of your Vehicle.", dirtLevel, 0, 100, 1, 1,false, function(newValue)
    dirtLevel = newValue
    VEHICLE.SET_VEHICLE_DIRT_LEVEL(util.getLocalVehicleHandle(), dirtLevel)
    if dirtLevel == 0 then
        gui.pushNotification("Dirt Level", "Your vehicle is clean!")
        else
        gui.pushNotification("Dirt Level", "Your vehicle is dirty!")
    end

end)

local car_modes = {
    "Normal",
    "Sport",
    "Offroad",
    "Drift",
    "Super"
}

gui.addChoose("Drive Mode", "Adjust handling of your current vehicle.", car_modes, 0, false, function(selectedIndex)
    local vehicle = util.getLocalVehicleHandle()
    if vehicle == 0 then
        gui.pushNotification("Drive Mode", "You're not in a vehicle!")
        return
    end

    local mode = car_modes[selectedIndex + 1] -- Ensure selectedIndex is 0-based

    if mode == "Sport" then
        VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 100)
        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(vehicle, 10)
        VEHICLE.SET_VEHICLE_REDUCE_GRIP(vehicle, false)
        gui.pushNotification("Drive Mode", "Sport mode activated!")

    elseif mode == "Offroad" then
        VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 30)
        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(vehicle, 1)
        VEHICLE.SET_VEHICLE_REDUCE_GRIP(vehicle, false)
        gui.pushNotification("Drive Mode", "Offroad grip enabled!")

    elseif mode == "Drift" then
        VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 20)
        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(vehicle, 999)
        VEHICLE.SET_VEHICLE_REDUCE_GRIP(vehicle, true)
        gui.pushNotification("Drive Mode", "Drift mode activated!")

    elseif mode == "Super" then
        VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 999)
        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(vehicle, 999)
        VEHICLE.SET_VEHICLE_REDUCE_GRIP(vehicle, true)
        gui.pushNotification("Drive Mode", "Super mode activated!")

    else
        VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 1000)
        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(vehicle, 1000)
        VEHICLE.SET_VEHICLE_REDUCE_GRIP(vehicle, false)
        gui.pushNotification("Drive Mode", "Normal mode enabled.")
    end
end)

gui.addButton("Spawn Vehicle", "Input name to spawn a vehicle.", function()
    script.queue(function() 
        local input = util.getKeyboardInput()

        if input == "" then
            gui.pushNotification("Spawn Vehicle", "You need to input a vehicle name!")
            return
        end

        local model = util.joaat(input)
        if util.requestModel(model) then
            local playerPed = PLAYER.PLAYER_PED_ID()
            local playerPos = ENTITY.GET_ENTITY_COORDS(playerPed)
            local heading = ENTITY.GET_ENTITY_HEADING(playerPed)

            local vehicle = VEHICLE.CREATE_VEHICLE(model, playerPos.x, playerPos.y, playerPos.z, heading, true, false)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, true, true)
            PED.SET_PED_INTO_VEHICLE(playerPed, vehicle, -1)

            gui.pushNotification("Spawn Vehicle", "Vehicle spawned successfully!")
        else
            gui.pushNotification("Spawn Vehicle", "Failed to spawn vehicle.")
        end
    end)
end)

local nightClubLoopToggle = false
local lastNightClubNotify = 0

function nightClubLoop()
    if not nightClubLoopToggle then return end

    if thread.isThreadRunning("am_mp_nightclub") then
        STATS.STAT_SET_INT(util.joaat(util.getMPX() .. "CLUB_POPULARITY"), 1000, true)
        STATS.STAT_SET_INT(util.joaat(util.getMPX() .. "CLUB_PAY_TIME_LEFT"), -1, true)
        script.wait(1000)
    else
        --local now = util.currentTimeMillis()
        --if now - lastNightClubNotify > 5000 then
        --    lastNightClubNotify = now
        --    gui.pushNotification("Night Club Loop", "You need to be in a nightclub!")
        --end
    end
end


 script.addScript(nightClubLoop)
gui.createSubTab("Recovery",2)

gui.addToggle("Night Club Loop", "Toggles Night Club loop.", nightClubLoopToggle, function()
    nightClubLoopToggle = not nightClubLoopToggle
    if nightClubLoopToggle then
        gui.pushNotification("Night Club Loop", "Night Club loop is now enabled!")
    else
        gui.pushNotification("Night Club Loop", "Night Club loop is now disabled!")
    end
end)

