local rotationName = "Overlord"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spells.victoryRush },
        [2] = { mode = "Off", value = 4, overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spells.victoryRush }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.shieldBlock },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.shieldBlock }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Movement Button
    local MoverModes = {
        [1] = { mode = "On", value = 1, overlay = "Mover Enabled", tip = "Will use Charge.", highlight = 1, icon = br.player.spells.charge },
        [2] = { mode = "Off", value = 2, overlay = "Mover Disabled", tip = "Will NOT use Charge.", highlight = 0, icon = br.player.spells.charge }
    };
    br.ui:createToggle(MoverModes, "Mover", 3, 0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")

        br.ui:checkSectionState(section)
    end
    optionTable = { {
        [1] = "Rotation Options",
        [2] = rotationOptions,
    } }
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals
local cast
local cd
local mode
local ui
local unit
local units
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    --Shield Block
    if unit.hp() < 70 then
        if cast.able.shieldBlock() and unit.exists("target") and unit.distance("target") < 5 then
            if cast.shieldBlock() then
                ui.debug("Casting Shield Block")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()

end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    cast        = br.player.cast
    cd          = br.player.cd
    mode        = br.player.ui.mode
    ui          = br.player.ui
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or br.pause() or mode.rotation == 4
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = ui.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = ui.time()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                -- Start Attack
                if mode.mover == 1 and cast.able.charge("target") then
                    if br.getDistance("player", "target") >= 8 and br.getDistance("player", "target") <= 25 then
                        if cast.charge("target") then
                            ui.debug("Casting Charge")
                            return true
                        end
                    end
                end

                if unit.distance("target") <= 6 then
                    if unit.hp("target") < 20 and cast.able.execute() then
                        if cast.execute() then
                            ui.debug("Casting Execute")
                            return true
                        end
                    end
                    -- actions=auto_attack
                    if not cast.auto.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                        if cast.autoAttack() then
                            ui.debug("Casting Auto Attack")
                            return true
                        end
                    end
                    -- Victory Rush
                    if cast.able.victoryRush() then
                        if cast.victoryRush() then
                            ui.debug("Casting Victory Rush")
                            return true
                        end
                    end
                    -- Shield Slam
                    if cast.able.shieldSlam() then
                        if cast.shieldSlam() then
                            ui.debug("Casting Shield Slam")
                            return true
                        end
                    end
                    -- WhirlWind
                    if cast.able.whirlwind() then
                        if cast.whirlwind() then
                            ui.debug("Casting Whirlwind")
                            return true
                        end
                    end
                    -- Slam
                    if cast.able.slam() then
                        if cast.slam() then
                            ui.debug("Casting Slam")
                            return true
                        end
                    end
                    --Pummel Interrupt
                    -- if br.canInterrupt() then
                    --     if  cast.able.pummel() then
                    --         if cast.pummel() then ui.debug("Casting Pummel") return true end
                    --     end
                    --end
                end
            end -- End In Combat Rotation
        end
    end         -- Pause
end             -- End runRotation
local id = 1446 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
