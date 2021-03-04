local rotationName = "Kuu M+"
if br.shaman == nil then
    br.shaman = {}
end
if br.shaman.resto == nil then
    br.shaman.resto = {}
end
if br.shaman.resto["Healing Rain"] == nil then
    br.shaman.resto["Healing Rain"] = 0
end
if br.shaman.resto["Earthen Wall Totem"] == nil then
    br.shaman.resto["Earthen Wall Totem"] = 0
end

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown Button
    local CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.healingTideTotem},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.healingTideTotem},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.healingTideTotem}
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.astralShift}
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.windShear}
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 3, 0)
    -- Decurse Button
    local DecurseModes = {
        [1] = {mode = "On", value = 1, overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purifySpirit},
        [2] = {mode = "Off", value = 2, overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purifySpirit}
    }
    br.ui:createToggle(DecurseModes, "Decurse", 4, 0)
    -- DPS Button
    local DPSModes = {
        [1] = {mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.lightningBolt},
        [2] = {mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.healingSurge}
    }
    br.ui:createToggle(DPSModes, "DPS", 5, 0)
    -- Ghost Wolf Button
    local GhostWolfModes = {
        [1] = {mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will Ghost Wolf when movement detected", highlight = 1, icon = br.player.spell.ghostWolf},
        [2] = {mode = "Hold", value = 2, overlay = "Hold Enabled", tip = "Will Ghost Wolf when key is held down", highlight = 0, icon = br.player.spell.ghostWolf}
    }
    br.ui:createToggle(GhostWolfModes, "GhostWolf", 6, 0)
    -- Healing Rain Button
    local HealingRModes = {
        [1] = {mode = "On", value = 1, overlay = "Healing Rain Enabled", tip = "Will use Healing Rain", highlight = 1, icon = br.player.spell.healingRain},
        [2] = {mode = "Off", value = 2, overlay = "Healing Rain Disabled", tip = "Will not use Healing Rain", highlight = 0, icon = br.player.spell.healingRain}
    }
    br.ui:createToggle(HealingRModes, "HealingR", 7, 0)
end

--------------
--- COLORS ---
--------------
local colorBlue = "|cff00CCFF"
local colorGreen = "|cff00FF00"
local colorRed = "|cffFF0000"
local colorWhite = "|cffFFFFFF"
local colorGold = "|cffFFDD11"

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.22")
        br.ui:createCheckbox(section, "Disable Auto Ground Cast Circle Cancel")
        br.ui:createCheckbox(section, "OOC Healing", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Ghost Wolf
        br.ui:createCheckbox(section, "Auto Ghost Wolf", "|cff0070deCheck this to automatically control GW transformation based on toggle bar setting.")
        br.ui:createDropdownWithout(section, "Ghost Wolf Key", br.dropOptions.Toggle, 6, "|cff0070deSet key to hold down for Ghost Wolf")
        -- Water Walking
        br.ui:createCheckbox(section, "Water Walking")
        -- Earth Shield
        br.ui:createCheckbox(section, "Earth Shield")
        -- Water Shield
        br.ui:createCheckbox(section, "Water Shield")
        -- Chain Lightning
        br.ui:createCheckbox(section, "Chain Lightning")
        -- Flametongue Weapon
        br.ui:createCheckbox(section, "Flametongue Weapon", "Apply Flametongue Weapon when using DPS key")
        -- Temple of Seth
        br.ui:createSpinner(section, "Temple of Seth", 80, 0, 100, 5, "|cffFFFFFFMinimum Health to Heal Seth NPC. Default: 80")
        -- Bursting Stack
        br.ui:createSpinnerWithout(section, "Bursting", 1, 1, 10, 1, "", "|cffFFFFFFWhen Bursting stacks are above this amount, CDs/AoE Healing will be triggered.")
        -- DPS Threshold
        br.ui:createSpinnerWithout(section, "DPS Threshold", 50, 0, 100, 5, "|cffFFFFFFMinimum Health to stop DPS. Default: 50")
        -- Critical HP
        br.ui:createSpinner(section, "Critical HP", 30, 0, 100, 5, "|cffFFFFFFWill stop casting a DPS Spell if party member drops below value. Default: 30")
        -- Mana Pot
        br.ui:createSpinner(section, "Mana Pot", 30, 0, 100, 5, "|cffFFFFFFWill use mana pot if mana below this value. Default: 30")
        -- Mana Tide Totem
        br.ui:createSpinner(section, "Mana Tide Totem", 30, 0, 100, 5, "|cffFFFFFFWill use mana tide if mana below this value. Default: 75")
        br.ui:checkSectionState(section)
        -- -- Burst Damage Options
        section = br.ui:createSection(br.ui.window.profile, "Raid Burst Damage Options")
        br.ui:createSpinner(
            section,
            "Burst Count",
            1,
            1,
            10,
            1,
            "Set which burst damage (ie. Grong Tantrum/Opulence Wail) number you need to cover with CDs.  Uncheck to use CDs whenever available."
        )
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround"}, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround"}, 1, "", "")
        -- Cloudburst Totem
        br.ui:createSpinner(section, "Cloudburst Totem", 90, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Cloudburst Totem Targets", 3, 0, 40, 1, "Minimum Cloudburst Totem Targets (excluding yourself)")
        -- Ascendance
        br.ui:createSpinner(section, "Ascendance", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Ascendance Targets", 3, 0, 40, 1, "Minimum Ascendance Targets (excluding yourself)")
        -- Healing Tide Totem
        br.ui:createSpinner(section, "Healing Tide Totem", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Healing Tide Totem Targets", 3, 0, 40, 1, "Minimum Healing Tide Totem Targets (excluding yourself)")
        -- Spirit Link Totem
        br.ui:createSpinner(section, "Spirit Link Totem", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Spirit Link Totem Targets", 3, 0, 40, 1, "Minimum Spirit Link Totem Targets")
        -- Ancestral Protection Totem
        br.ui:createSpinner(section, "Ancestral Protection Totem", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Ancestral Protection Totem Targets", 3, 0, 40, 1, "Minimum Ancestral Protection Totem Targets")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
        br.ui:createSpinner(section, "Healthstone", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        end
        -- Astral Shift
        br.ui:createSpinner(section, "Astral Shift", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Purge
        br.ui:createDropdown(section, "Purge", {"|cffFFFF00Selected Target", "|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        br.ui:createSpinnerWithout(section, "Purge Min Mana", 50, 0, 100, 5, "|cffFFFFFFMinimum Mana to Use Purge At")
        -- Capacitor Totem
        br.ui:createSpinner(section, "Capacitor Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Earthen Wall Totem
        br.ui:createSpinner(section, "Earthen Wall Totem", 95, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Earthen Wall Totem Targets", 1, 0, 40, 1, "Minimum Earthen Wall Totem Targets")
        br.ui:createCheckbox(section, "EW on Melee", "Cast on Melee only")
        -- Ancestral Spirit
        br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target", "|cffFF0000Mouseover Target", "|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Wind Shear
        br.ui:createCheckbox(section, "Wind Shear")
        -- Capacitor Totem
        br.ui:createCheckbox(section, "Capacitor Totem")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Covenant Options
        section = br.ui:createSection(br.ui.window.profile, "Covenants")
        -- Night Fae
        br.ui:createSpinner(section, "Fae Transfusion", 85, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Fae Transfusion Targets", 2, 0, 40, 1, "Minimum Fae Transfusion Targets")
        -- Kyrian
        br.ui:createSpinner(section, "Vesper Totem", 85, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Vesper Totem Targets", 2, 0, 40, 1, "Minimum Vesper Totem Targets")
        -- Necrolord
        br.ui:createSpinner(section, "Primordial Wave", 90, 0, 100, 5, "Health Percent to Cast At")
        -- Venthyr
        br.ui:createSpinner(section, "Chain Harvest", 85, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Chain Harvest Targets", 2, 0, 40, 1, "Minimum Chain Harvest Targets")
        br.ui:checkSectionState(section)
        -- Manual Keys
        section = br.ui:createSection(br.ui.window.profile, "Manual Keys")
        -- Healing Rain
        br.ui:createDropdown(
            section,
            "Healing Rain Key",
            br.dropOptions.Toggle,
            6,
            colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Healing Rain manual usage."
        )
        -- Spirit Link
        br.ui:createDropdown(
            section,
            "Spirit Link Totem Key",
            br.dropOptions.Toggle,
            6,
            colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Spirit Link Totem manual usage."
        )
        -- Ascendance
        br.ui:createDropdown(
            section,
            "Ascendance Key",
            br.dropOptions.Toggle,
            6,
            colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Ascendance manual usage."
        )
        -- Healing Tide Totem
        br.ui:createDropdown(
            section,
            "Healing Tide Key",
            br.dropOptions.Toggle,
            6,
            colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Healing Tide Totem manual usage."
        )
        -- Tremor Totem
        br.ui:createDropdown(
            section,
            "Tremor Totem Key",
            br.dropOptions.Toggle,
            6,
            colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Tremor Totem manual usage."
        )
        -- DPS Key
        br.ui:createDropdown(
            section,
            "DPS Key",
            br.dropOptions.Toggle,
            6,
            "|cffFFFFFFHold down key to ONLY do DPS." ..
                colorRed .. " WARNING: " .. colorWhite .. "Will keep Healing Rain and Riptide up but will not do any other healing while key is held down!"
        )
        br.ui:checkSectionState(section)
        -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        -- Healing Rain
        br.ui:createSpinnerWithout(section, "Healing Rain", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Healing Rain Targets", 2, 0, 40, 1, "Minimum Healing Rain Targets")
        br.ui:createCheckbox(section, "Healing Rain on Melee", "Cast on Melee only")
        br.ui:createCheckbox(section, "Healing Rain on CD", "Requires Healing Rain on Melee to be checked to work")
        -- Downpour
        br.ui:createSpinner(section, "Downpour", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Downpour Targets", 2, 0, 40, 1, "Minimum Downpour Targets")
        br.ui:createCheckbox(section, "Downpour on Melee", "Cast on Melee only")
        -- Riptide
        br.ui:createSpinner(section, "Riptide", 90, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Stream Totem
        br.ui:createSpinner(section, "Healing Stream Totem", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Unleash Life
        br.ui:createSpinner(section, "Unleash Life", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Wave
        br.ui:createSpinner(section, "Healing Wave", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Surge
        br.ui:createSpinner(section, "Healing Surge", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Chain Heal
        br.ui:createSpinner(section, "Chain Heal", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Chain Heal Targets", 3, 0, 40, 1, "Minimum Chain Heal Targets")
        -- Wellspring
        br.ui:createSpinner(section, "Wellspring", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Wellspring Targets", 3, 0, 40, 1, "Minimum Wellspring Targets")
        -- Surge of Earth
        br.ui:createSpinner(section, "Surge of Earth", 75, 0, 100, 5, "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugRestoration", 0.1) then
        --print("Running: "..rotationName)
        --------------
        --- Locals ---
        --------------
        local buff = br.player.buff
        local cast = br.player.cast
        local charges = br.player.charges
        local deadMouse, hasMouse, playerMouse = br.GetUnitIsDeadOrGhost("mouseover"), br.GetObjectExists("mouseover"), br._G.UnitIsPlayer("mouseover")
        local deadtar, playertar = br.GetUnitIsDeadOrGhost("target"), br._G.UnitIsPlayer("target")
        local combatTime = br.getCombatTime()
        local covenant = br.player.covenant
        local cd = br.player.cd
        local debuff = br.player.debuff
        local drinking = br._G.UnitBuff("player", 192001) ~= nil or br._G.UnitBuff("player", 225737) ~= nil
        local gcd = br.player.gcd
        local gcdMax = br.player.gcdMax
        local healPot = br.getHealthPot()
        local inCombat = br.player.inCombat
        local inInstance = br.player.instance == "party"
        local inRaid = br.player.instance == "raid"
        local falling, swimming, flying, moving = br.getFallTime(), br._G.IsSwimming(), br._G.IsFlying(), br._G.GetUnitSpeed("player") > 0
        local lastSpell = br.lastSpellCast
        local level = br.player.level
        local mode = br.player.ui.mode
        local php = br.player.health
        local power, powmax, powgen = br.player.power.mana.percent(), br.player.power.mana.max(), br.player.power.mana.regen()
        local pullTimer = br.DBM:getPulltimer()
        local race = br.player.race
        local racial = br.player.getRacial()
        local runeforge = br.player.runeforge
        local spell = br.player.spell
        local talent = br.player.talent
        local tanks = br.getTanksTable()
        local wolf = br.player.buff.ghostWolf.exists()
        local ttd = br.getTTD
        local ttm = br.player.power.mana.ttm()
        local ui = br.player.ui
        local units = br.player.units
        local enemies = br.player.enemies
        local friends = {}
        local burst = nil

        --units.get(8)
        --units.get(40)
        enemies.get(5)
        enemies.get(10)
        enemies.get(10, "target")
        enemies.get(20)
        enemies.get(30)
        enemies.get(40, nil, nil, true)
        enemies.get(40)
        friends.yards40 = br.getAllies("player", 40)

        local lowest = {}
        lowest.unit = "player"
        lowest.hp = 100
        for i = 1, #br.friend do
            if br.friend[i].hp < lowest.hp then
                lowest = br.friend[i]
            end
        end

        if inInstance and select(3, br._G.GetInstanceInfo()) == 8 then
            for i = 1, #tanks do
                local ourtank = tanks[i].unit
                local Burststack = br.getDebuffStacks(ourtank, 240443)
                if Burststack >= ui.value("Bursting") then
                    burst = true
                    break
                else
                    burst = false
                end
            end
        end

        local tankIsNotMoving = nil
        for i = 1, #tanks do
            local tank = tanks[i].unit
            if not br.isMoving(tank) then
                tankIsNotMoving = true
            end
        end
        local dpsSpells = {spell.lightningBolt, spell.chainLightning, spell.lavaBurst, spell.flameShock}
        local function castingDPSSpells()
            for i = 1, #dpsSpells do
                if br.isCastingSpell(dpsSpells[i]) and br.isChecked("Critical HP") and lowest.hp <= br.getValue("Critical HP") then
                    return true
                end
            end
        end
        local movingCheck = not br.isMoving("player") and not br._G.IsFalling() or (br.isMoving("player") and buff.spiritwalkersGrace.exists("player"))

        --------------------
        --- Action Lists ---
        --------------------
        -- Action List - Extras
        local function actionList_Extras()
            -- Dummy Test
            if ui.checked("DPS Testing") then
                if br.GetObjectExists("target") then
                    if br.getCombatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and br.isDummy() then
                        br._G.StopAttack()
                        br._G.ClearTarget()
                        br._G.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                        br.profileStop = true
                    end
                end
            end -- End Dummy Test
            -- Water Walking
            if falling > 1.5 and buff.waterWalking.exists() then
                br._G.CancelUnitBuffID("player", spell.waterWalking)
            end
            if ui.checked("Water Walking") and not inCombat and br._G.IsSwimming() and not buff.waterWalking.exists() then
                if cast.waterWalking() then
                    br.addonDebug("Casting Waterwalking")
                    return
                end
            end
            -- Ancestral Spirit
            if ui.checked("Ancestral Spirit") and not inCombat and movingCheck and br.timer:useTimer("Resurrect", 4) then
                if ui.value("Ancestral Spirit") == 1 and br._G.UnitIsPlayer("target") and br.GetUnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") then
                    if cast.ancestralSpirit("target", "dead") then
                        br.addonDebug("Casting Ancestral Spirit")
                        return true
                    end
                end
                if ui.value("Ancestral Spirit") == 2 and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
                    if cast.ancestralSpirit("mouseover", "dead") then
                        br.addonDebug("Casting Ancestral Spirit")
                        return true
                    end
                end
                if ui.value("Ancestral Spirit") == 3 then
                    local deadPlayers = {}
                    for i = 1, #br.friend do
                        if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) then
                            br._G.tinsert(deadPlayers, br.friend[i].unit)
                        end
                    end
                    if #deadPlayers > 1 then
                        if cast.ancestralVision() then
                            br.addonDebug("Casting Ancestral Vision")
                            return true
                        end
                    elseif #deadPlayers == 1 then
                        if cast.ancestralSpirit(deadPlayers[1], "dead") then
                            br.addonDebug("Casting Ancestral Spirit")
                            return true
                        end
                    end
                end
            end
        end -- End Action List - Extras
        -- Action List - Defensive
        local function actionList_Defensive()
            -- Earth Shield
            if cast.able.earthShield() then
                -- check if shield already exists
                local foundShield = false
                if ui.checked("Earth Shield") then
                    for i = 1, #br.friend do
                        if buff.earthShield.exists(br.friend[i].unit) then
                            foundShield = true
                        end
                    end
                    -- if no shield found, apply to focus if exists
                    if foundShield == false then
                        if br.GetUnitExists("focus") == true then
                            if not buff.earthShield.exists("focus") and not br.GetUnitIsDeadOrGhost("focus") then
                                if cast.earthShield("focus") then
                                    br.addonDebug("Casting Earth Shield")
                                    return
                                end
                            end
                        else
                            for i = 1, #tanks do
                                if not buff.earthShield.exists(tanks[i].unit) and br.getDistance(tanks[i].unit) <= 40 and not br.GetUnitIsDeadOrGhost(tanks[i].unit) then
                                    if cast.earthShield(tanks[i].unit) then
                                        br.addonDebug("Casting Earth Shield")
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Water Shield
            if ui.checked("Water Shield") and not buff.waterShield.exists() then
                if cast.waterShield() then
                    br.addonDebug("Casting Water Shield")
                    return
                end
            end
            -- Temple of Seth
            if inCombat and ui.checked("Temple of Seth") and br.player.eID and br.player.eID == 2127 then
                for i = 1, br._G.GetObjectCount() do
                    local thisUnit = br._G.GetObjectWithIndex(i)
                    if br.GetObjectID(thisUnit) == 133392 then
                        local sethObject = thisUnit
                        if br.getHP(sethObject) < 100 and br.getBuffRemain(sethObject, 274148) == 0 and lowest.hp >= ui.value("Temple of Seth") then
                            if not buff.riptide.exists(sethObject) then
                                br._G.CastSpellByName(br._G.GetSpellInfo(61295), sethObject)
                                br.addonDebug("Casting Riptide")
                                return
                            --cast.riptide("target") then return true end
                            end
                            if br.getHP(sethObject) < 50 and movingCheck then
                                --if cast.healingSurge("target") then return true end
                                br._G.CastSpellByName(br._G.GetSpellInfo(8004), sethObject)
                                br.addonDebug("Casting Healing Surge")
                                return
                            else
                                --if cast.healingWave("target") then return true end
                                if movingCheck then
                                    br._G.CastSpellByName(br._G.GetSpellInfo(77472), sethObject)
                                    br.addonDebug("Casting Healing Wave")
                                    return
                                end
                            end
                        end
                    end
                end
            end
            if br.useDefensive() then
                -- Healthstone
                if ui.checked("Healthstone") and php <= ui.value("Healthstone") and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(166799)) then
                    if br.canUseItem(5512) then
                        br.addonDebug("Using Healthstone")
                        br.useItem(5512)
                    elseif br.canUseItem(healPot) then
                        br.addonDebug("Using Health Pot")
                        br.useItem(healPot)
                    end
                end
                -- Heirloom Neck
                if ui.checked("Heirloom Neck") and php <= ui.value("Heirloom Neck") then
                    if br.hasEquiped(122668) then
                        if br._G.GetItemCooldown(122668) == 0 then
                            br.useItem(122668)
                            br.addonDebug("Using Heirloom Neck")
                            return
                        end
                    end
                end
                -- Gift of the Naaru
                if ui.checked("Gift of the Naaru") and php <= ui.value("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if br.castSpell("player", racial, false, false, false) then
                        br.addonDebug("Casting Gift of the Naaru")
                        return
                    end
                end
                -- Astral Shift
                if ui.checked("Astral Shift") and php <= ui.value("Astral Shift") and inCombat then
                    if cast.astralShift() then
                        br.addonDebug("Casting Astral Shift")
                        return
                    end
                end
                -- Capacitor Totem
                if cd.capacitorTotem.remain() <= gcd then
                    if ui.checked("Capacitor Totem - HP") and php <= ui.value("Capacitor Totem - HP") and inCombat and lastSpell ~= spell.capacitorTotem and #enemies.yards5 > 0 then
                        if cast.capacitorTotem("player") then
                            br.addonDebug("Casting Capacitor Totem")
                            return
                        end
                    end
                    if ui.checked("Capacitor Totem - AoE") and #enemies.yards5 >= ui.value("Capacitor Totem - AoE") and inCombat and lastSpell ~= spell.capacitorTotem then
                        if cast.capacitorTotem("player") then
                            br.addonDebug("Casting Capacitor Totem")
                            return
                        end
                    end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        -- Action List - Interrupts
        local function actionList_Interrupts()
            if br.useInterrupts() and inCombat and not buff.ghostWolf.exists() then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if br.canInterrupt(thisUnit, ui.value("Interrupt At")) then
                        -- Wind Shear
                        if ui.checked("Wind Shear") and br.getFacing("player", thisUnit) then
                            if cast.windShear(thisUnit) then
                                br.addonDebug("Casting Wind Shear")
                                return
                            end
                        end
                        -- Capacitor Totem
                        if ui.checked("Capacitor Totem") and cd.global.remains() == 0 then
                            if cast.capacitorTotem(thisUnit) then
                                br.addonDebug("Casting Capacitor Totem")
                                return
                            end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
        local function ghostWolf()
            -- Ghost Wolf
            if not (br._G.IsMounted() or br._G.IsFlying()) and ui.checked("Auto Ghost Wolf") then
                if mode.ghostWolf == 1 then
                    if
                        ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and br.isMoving("player") and not buff.ghostWolf.exists() and
                            not buff.spiritwalkersGrace.exists()
                     then
                        if cast.ghostWolf() then
                            br.addonDebug("Casting Ghost Wolf")
                        end
                    elseif movingCheck and buff.ghostWolf.exists() and br.timer:useTimer("Delay", 0.5) then
                        br._G.RunMacroText("/cancelAura Ghost Wolf")
                    end
                elseif mode.ghostWolf == 2 then
                    if not buff.ghostWolf.exists() and br.isMoving("player") then
                        if br.SpecificToggle("Ghost Wolf Key") and not br._G.GetCurrentKeyBoardFocus() then
                            if cast.ghostWolf() then
                                br.addonDebug("Casting Ghost Wolf")
                            end
                        end
                    elseif buff.ghostWolf.exists() then
                        if br.SpecificToggle("Ghost Wolf Key") and not br._G.GetCurrentKeyBoardFocus() then
                            return
                        else
                            if br.timer:useTimer("Delay", 0.25) then
                                br._G.RunMacroText("/cancelAura Ghost Wolf")
                            end
                        end
                    end
                end
            end
        end
        -- Action List - Pre-Combat
        local function actionList_PreCombat()
            if ui.checked("Pig Catcher") then
                br.bossHelper()
            end
            local prepullOpener = inRaid and ui.checked("Pre-pull Opener") and pullTimer <= ui.value("Pre-pull Opener")
            -- Healing Rain
            if movingCheck and cd.healingRain.remain() <= gcd then
                if (br.SpecificToggle("Healing Rain Key") and not br._G.GetCurrentKeyBoardFocus()) and ui.checked("Healing Rain Key") then
                    if br._G.CastSpellByName(br._G.GetSpellInfo(spell.healingRain), "cursor") then
                        br.addonDebug("Casting Healing Rain")
                        return
                    end
                end
            end
            -- Riptide
            if ui.checked("Riptide") and not buff.ghostWolf.exists() then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= ui.value("Riptide") and buff.riptide.refresh(br.friend[i].unit) then
                        if cast.riptide(br.friend[i].unit) then
                            br.addonDebug("Casting Riptide")
                            return
                        end
                    end
                end
            end
            -- Healing Stream Totem
            if ui.checked("Healing Stream Totem") and movingCheck and cd.healingStreamTotem.remain() <= gcd and not talent.cloudburstTotem then
                if lowest.hp <= ui.value("Healing Stream Totem") then
                    if cast.healingStreamTotem(lowest.unit) then
                        br.addonDebug("Casting Healing Stream Totem")
                        return
                    end
                end
            end
            -- Healing Surge
            if ui.checked("Healing Surge") and movingCheck then
                if lowest.hp <= ui.value("Healing Surge") and (buff.tidalWaves.exists() or level < 34) then
                    if cast.healingSurge(lowest.unit) then
                        br.addonDebug("Casting Healing Surge")
                        return
                    end
                end
            end
            -- Healing Wave
            if ui.checked("Healing Wave") and movingCheck then
                if lowest.hp <= ui.value("Healing Wave") and (buff.tidalWaves.exists() or level < 34) then
                    if cast.healingWave(lowest.unit) then
                        br.addonDebug("Casting Healing Wave")
                        return
                    end
                end
            end
            -- Chain Heal
            if ui.checked("Chain Heal") and movingCheck then
                if br.chainHealUnits(spell.chainHeal, 15, ui.value("Chain Heal"), ui.value("Chain Heal Targets")) then
                    br.addonDebug("Casting Chain Heal")
                    return true
                end
            end
            -- Healing Surge
            if ui.checked("Healing Surge") and movingCheck then
                if lowest.hp <= 50 then
                    if cast.healingSurge(lowest.unit) then
                        br.addonDebug("Casting Healing Surge")
                        return
                    end
                end
            end
            -- Healing Wave below 65
            if ui.checked("Healing Wave") and movingCheck and not burst then
                if lowest.hp <= 65 then
                    if cast.healingWave(lowest.unit) then
                        br.addonDebug("Casting Healing Wave")
                        return
                    end
                end
            end
        end -- End Action List - Pre-Combat
        -- Action List - DPS
        local function actionList_DPS()
            -- Lava Burst - Lava Surge
            if buff.lavaSurge.exists() then
                if debuff.flameShock.exists("target") and br.getFacing("player", "target") then
                    if cast.lavaBurst() then
                        br.addonDebug("Casting Lava Burst (Lava Surge)")
                        return true
                    end
                else
                    for i = 1, #enemies.yards40f do
                        local thisUnit = enemies.yards40f[i]
                        if debuff.flameShock.exists(thisUnit) then
                            if cast.lavaBurst(thisUnit) then
                                br.addonDebug("Casting Lava Burst (Lava Surge)")
                                return true
                            end
                        end
                    end
                end
            end
            -- Flameshock
            for i = 1, #enemies.yards40f do
                local thisUnit = enemies.yards40f[i]
                if not debuff.flameShock.exists(thisUnit) then
                    if cast.flameShock(thisUnit) then
                        br.addonDebug("Casting Flame Shock")
                        return
                    end
                end
            end
            -- Lava Burst
            if (debuff.flameShock.remain("target") > br.getCastTime(spell.lavaBurst) or level < 20) and movingCheck and br.getFacing("player", "target") then
                if cast.lavaBurst() then
                    br.addonDebug("Casting Lava Burst")
                    return
                end
            end
            -- Chain Lightning
            if ui.checked("Chain Lightning") and #enemies.yards10t >= 2 and movingCheck and br.getFacing("player", "target") then
                if cast.chainLightning() then
                    br.addonDebug("Casting Chain Lightning")
                    return
                end
            end
            -- Lightning Bolt
            if movingCheck and br.getFacing("player", "target") then
                if cast.lightningBolt() then
                    br.addonDebug("Casting Lightning Bolt")
                    return
                end
            end
        end -- End Action List - DPS
        local function actionList_Explosive()
            --Flameshock
            if not debuff.flameShock.exists("target") and br.getFacing("player", "target") then
                if cast.flameShock() then
                    br.addonDebug("Casting Flame Shock")
                    return
                end
            end
            --Lavaburst (Lava Surge Buff)
            if buff.lavaSurge.exists() and debuff.flameShock.exists("target") and br.getFacing("player", "target") then
                if cast.Lavaburst then
                    br.addonDebug("Casting Lava Burst")
                    return
                end
            end
        end

        local function actionList_dpsKey()
            --Healing Rain
            if mode.healingR == 1 and movingCheck and br._G.GetTime() - br.shaman.resto["Healing Rain"] >= 2 then
                if not buff.healingRain.exists() then
                    if br.isChecked("Healing Rain on Melee") then
                        -- get melee players
                        for i = 1, #tanks do
                            -- get the tank's target
                            local tankTarget = br._G.UnitTarget(tanks[i].unit)
                            if tankTarget ~= nil and br.getDistance(tankTarget, "player") < 30 then
                                -- get players in melee range of tank's target
                                local meleeFriends = br.getAllies(tankTarget, 5)
                                -- get the best ground circle to encompass the most of them
                                local loc = nil
                                if br.isChecked("Healing Rain on CD") then
                                    -- return
                                    if #meleeFriends >= br.getValue("Healing Rain Targets") then
                                        if #meleeFriends < 12 then
                                            loc = br.getBestGroundCircleLocation(meleeFriends, br.getValue("Healing Rain Targets"), 6, 10)
                                        else
                                            if br.castWiseAoEHeal(meleeFriends, spell.healingRain, 10, 100, br.getValue("Healing Rain Targets"), 6, true, true) then
                                                br.addonDebug("Casting Healing Rain")
                                                if br._G.SpellIsTargeting() then
                                                    br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                                    br._G.SpellStopTargeting()
                                                    br.addonDebug(colorRed .. "Canceling Spell")
                                                end
                                                return
                                            end
                                        end
                                    end
                                else
                                    local meleeHurt = {}
                                    for j = 1, #meleeFriends do
                                        if meleeFriends[j].hp < br.getValue("Healing Rain") then
                                            br._G.tinsert(meleeHurt, meleeFriends[j])
                                        end
                                    end
                                    if #meleeHurt >= br.getValue("Healing Rain Targets") then
                                        if #meleeHurt < 12 then
                                            loc = br.getBestGroundCircleLocation(meleeHurt, br.getValue("Healing Rain Targets"), 6, 10)
                                        else
                                            if br.castWiseAoEHeal(meleeHurt, spell.healingRain, 10, br.getValue("Healing Rain"), br.getValue("Healing Rain Targets"), 6, true, true) then
                                                br.addonDebug("Casting Healing Rain")
                                                if br._G.SpellIsTargeting() then
                                                    br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                                    br._G.SpellStopTargeting()
                                                    br.addonDebug(colorRed .. "Canceling Spell")
                                                end
                                                return
                                            end
                                        end
                                    end
                                end
                                if loc ~= nil then
                                    local px, py, pz = br._G.ObjectPosition("player")
                                    loc.z = select(3, br._G.TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                    if
                                        loc.z ~= nil and br._G.TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and
                                        br._G.TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil
                                     then
                                        -- Check z and LoS, ignore terrain and m2 collisions
                                        if cast.healingRain() then
                                            br._G.ClickPosition(loc.x, loc.y, loc.z)
                                            br.addonDebug("Casting Healing Rain (Cast Ground)")
                                            if br._G.SpellIsTargeting() then
                                                br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                                br._G.SpellStopTargeting()
                                                br.addonDebug(colorRed .. "Canceling Spell")
                                            end
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if br.castWiseAoEHeal(br.friend, spell.healingRain, 10, br.getValue("Healing Rain"), br.getValue("Healing Rain Targets"), 6, true, true) then
                            br.addonDebug("Casting Healing Rain (Wise AoE)")
                            if br._G.SpellIsTargeting() then
                                br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                br._G.SpellStopTargeting()
                                br.addonDebug(colorRed .. "Canceling Spell")
                            end
                            return
                        end
                    end
                end
            end
            --Riptide
            if ui.checked("Riptide") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= ui.value("Riptide") and buff.riptide.refresh(br.friend[i].unit) then
                        if cast.riptide(br.friend[i].unit) then
                            br.addonDebug("Casting Riptide")
                            return
                        end
                    end
                end
            end
            -- Flametongue Weapon
            if ui.checked("Flametongue Weapon") and not br.player.unit.weaponImbue.exists(5400) then
                if cast.flametongueWeapon("player") then
                    br.addonDebug("Casting Flametongue Weapon")
                    return
                end
            end
            if br.isExplosive("target") then
                actionList_Explosive()
            else
                actionList_DPS()
            end
        end

        local function actionList_Cooldowns()
            if br.useCDs() then
                -- Spirit Link Totem
                if ui.checked("Spirit Link Totem") and not moving and cd.spiritLinkTotem.remain() <= gcd then
                    if br.castWiseAoEHeal(br.friend, spell.spiritLinkTotem, 12, ui.value("Spirit Link Totem"), ui.value("Spirit Link Totem Targets"), 40, false, true) then
                        br.addonDebug("Casting Spirit Link Totem")
                        return
                    end
                end
                -- Spiritual Mana Potion
                if ui.checked("Mana Pot") and power <= ui.value("Mana Pot") and inCombat and br.hasItem(171268) then
                    if br.canUseItem(171268) then
                        br.useItem(171268)
                        br.addonDebug("Using Spiritual Mana Pot")
                        return
                    end
                end
                -- Racial Buff
                if ui.checked("Racial") and (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target", "ground") then
                            br.addonDebug("Casting Racial")
                            return true
                        end
                    else
                        if cast.racial("player") then
                            br.addonDebug("Casting Racial")
                            return true
                        end
                    end
                end
                -- Trinkets
                if
                    ui.checked("Trinket 1") and br.canTrinket(13) and not br.hasEquiped(165569, 13) and not br.hasEquiped(160649, 13) and not br.hasEquiped(158320, 13) and
                        not br.hasEquiped(169314, 13)
                 then
                    if ui.value("Trinket 1 Mode") == 1 then
                        if br.getLowAllies(ui.value("Trinket 1")) >= ui.value("Min Trinket 1 Targets") or burst == true then
                            br.useItem(13)
                            br.addonDebug("Using Trinket 1")
                            return true
                        end
                    elseif ui.value("Trinket 1 Mode") == 2 then
                        if (lowest.hp <= ui.value("Trinket 1") or burst == true) and lowest.hp ~= 250 then
                            br._G.UseItemByName(br._G.GetInventoryItemID("player", 13), lowest.unit)
                            br.addonDebug("Using Trinket 1 (Target)")
                            return true
                        end
                    elseif ui.value("Trinket 1 Mode") == 3 and #tanks > 0 then
                        for i = 1, #tanks do
                            -- get the tank's target
                            local tankTarget = br._G.UnitTarget(tanks[i].unit)
                            if tankTarget ~= nil then
                                -- get players in melee range of tank's target
                                local meleeFriends = br.getAllies(tankTarget, 5)
                                -- get the best ground circle to encompass the most of them
                                local loc = nil
                                if #meleeFriends < 12 then
                                    loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                                else
                                    local meleeHurt = {}
                                    for j = 1, #meleeFriends do
                                        if meleeFriends[j].hp < ui.value("Trinket 1") then
                                            br._G.tinsert(meleeHurt, meleeFriends[j])
                                        end
                                    end
                                    if #meleeHurt >= ui.value("Min Trinket 1 Targets") or burst == true then
                                        loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                    end
                                end
                                if loc ~= nil then
                                    br.useItem(13)
                                    br.addonDebug("Using Trinket 1 (Ground)")
                                    local px, py, pz = br._G.ObjectPosition("player")
                                    loc.z = select(3, br._G.TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                    if
                                        loc.z ~= nil and br._G.TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and
                                        br._G.TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil
                                     then -- Check z and LoS, ignore terrain and m2 collisions
                                        br._G.ClickPosition(loc.x, loc.y, loc.z)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                if
                    ui.checked("Trinket 2") and br.canTrinket(14) and not br.hasEquiped(165569, 14) and not br.hasEquiped(160649, 14) and not br.hasEquiped(158320, 14) and
                        not br.hasEquiped(169314, 13)
                 then
                    if ui.value("Trinket 2 Mode") == 1 then
                        if br.getLowAllies(ui.value("Trinket 2")) >= ui.value("Min Trinket 2 Targets") or burst == true then
                            br.useItem(14)
                            br.addonDebug("Using Trinket 2")
                            return true
                        end
                    elseif ui.value("Trinket 2 Mode") == 2 then
                        if (lowest.hp <= ui.value("Trinket 2") or burst == true) and lowest.hp ~= 250 then
                            br._G.UseItemByName(br._G.GetInventoryItemID("player", 14), lowest.unit)
                            br.addonDebug("Using Trinket 2 (Target)")
                            return true
                        end
                    elseif ui.value("Trinket 2 Mode") == 3 and #tanks > 0 then
                        for i = 1, #tanks do
                            -- get the tank's target
                            local tankTarget = br._G.UnitTarget(tanks[i].unit)
                            if tankTarget ~= nil then
                                -- get players in melee range of tank's target
                                local meleeFriends = br.getAllies(tankTarget, 5)
                                -- get the best ground circle to encompass the most of them
                                local loc = nil
                                if #meleeFriends < 12 then
                                    loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                                else
                                    local meleeHurt = {}
                                    for j = 1, #meleeFriends do
                                        if meleeFriends[j].hp < ui.value("Trinket 2") then
                                            br._G.tinsert(meleeHurt, meleeFriends[j])
                                        end
                                    end
                                    if #meleeHurt >= ui.value("Min Trinket 2 Targets") or burst == true then
                                        loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                    end
                                end
                                if loc ~= nil then
                                    br.useItem(14)
                                    br.addonDebug("Using Trinket 2 (Ground)")
                                    br._G.ClickPosition(loc.x, loc.y, loc.z)
                                    return true
                                end
                            end
                        end
                    end
                end
                -- Healing Tide Totem
                if ui.checked("Healing Tide Totem") and not buff.ascendance.exists() and cd.healingTideTotem.remain() <= gcd then
                    if
                        br.getLowAllies(ui.value("Healing Tide Totem")) >= ui.value("Healing Tide Totem Targets") or burst == true
                     then
                        if cast.healingTideTotem() then
                            br.addonDebug("Casting Healing Tide Totem")
                            br.shaman.HTTimer = br._G.GetTime()
                            return
                        end
                    end
                end
                -- Ascendance
                if ui.checked("Ascendance") and talent.ascendance and cd.ascendance.remain() <= gcd and (not br.shaman.HTTimer or br._G.GetTime() - br.shaman.HTTimer > 10) then
                    if
                        br.getLowAllies(ui.value("Ascendance")) >= ui.value("Ascendance Targets") or burst == true
                     then
                        if cast.ascendance() then
                            br.addonDebug("Casting Ascendance")
                            return
                        end
                    end
                end
                -- Mana Tide Totem
                if ui.checked("Mana Tide Totem") and power < ui.value("Mana Tide Totem") then
                    if cast.manaTideTotem() then
                        br.addonDebug("Casting Mana Tide Totem")
                        return
                    end
                end
                -- Ancestral Protection Totem
                if ui.checked("Ancestral Protection Totem") and cd.ancestralProtectionTotem.remain() <= gcd then
                    if
                        br.castWiseAoEHeal(
                            br.friend,
                            spell.ancestralProtectionTotem,
                            20,
                            ui.value("Ancestral Protection Totem"),
                            ui.value("Ancestral Protection Totem Targets"),
                            10,
                            false,
                            false
                        )
                     then
                        br.addonDebug("casting Ancestral Protection Totem")
                        return
                    end
                end
            end
        end
        local function actionList_AMR()
            -- Healing Rain Key
            if movingCheck and cd.healingRain.remain() <= gcd then
                if (br.SpecificToggle("Healing Rain Key") and not br._G.GetCurrentKeyBoardFocus()) and ui.checked("Healing Rain Key") then
                    if br._G.CastSpellByName(br._G.GetSpellInfo(spell.healingRain), "cursor") then
                        br.addonDebug("Casting Healing Rain")
                        return true
                    end
                end
            end
            --Spirit Link Key
            if (br.SpecificToggle("Spirit Link Totem Key") and not br._G.GetCurrentKeyBoardFocus()) and ui.checked("Spirit Link Totem Key") then
                if br._G.CastSpellByName(br._G.GetSpellInfo(spell.spiritLinkTotem), "cursor") then
                    br.addonDebug("Casting Spirit Link Totem")
                    return true
                end
            end
            -- Ascendance Key
            if (br.SpecificToggle("Ascendance Key") and not br._G.GetCurrentKeyBoardFocus()) and ui.checked("Ascendance Key") then
                if cast.ascendance() then
                    br.addonDebug("Casting Ascendance")
                    return true
                end
            end
            -- Tremor Totem Key
            if (br.SpecificToggle("Tremor Totem Key") and not br._G.GetCurrentKeyBoardFocus()) and ui.checked("Tremor Totem Key") then
                if cast.tremorTotem("player") then
                    br.addonDebug("Casting Tremor Totem")
                    return true
                end
            end
            -- Healing Tide Key
            if (br.SpecificToggle("Healing Tide Key") and not br._G.GetCurrentKeyBoardFocus()) and ui.checked("Healing Tide Key") then
                if cast.healingTideTotem() then
                    br.addonDebug("Casting Healing Tide Totem")
                    return true
                end
            end
            -- Earthen Wall Totem
            if
                ui.checked("Earthen Wall Totem") and talent.earthenWallTotem and cd.earthenWallTotem.remain() <= gcdMax and
                    br._G.GetTime() - br.shaman.resto["Earthen Wall Totem"] >= 2
             then
                if ui.checked("EW on Melee") then
                    -- get melee players
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = br._G.UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil and br.getDistance(tankTarget, "player") < 30 then
                            -- get players in melee range of tank's target
                            local meleeFriends = br.getAllies(tankTarget, 5)
                            -- get the best ground circle to encompass the most of them
                            local loc = nil
                            local meleeHurt = {}
                            for j = 1, #meleeFriends do
                                if meleeFriends[j].hp < ui.value("Earthen Wall Totem") then
                                    br._G.tinsert(meleeHurt, meleeFriends[j])
                                end
                            end
                            if #meleeHurt >= ui.value("Earthen Wall Totem Targets") then
                                if #meleeHurt < 12 then
                                    loc = br.getBestGroundCircleLocation(meleeHurt, ui.value("Earthen Wall Totem Targets"), 6, 10)
                                else
                                    if br.castWiseAoEHeal(meleeHurt, spell.earthenWallTotem, 10, ui.value("Earthen Wall Totem"), ui.value("Earthen Wall Totem Targets"), 6, true, true) then
                                        br.addonDebug("Casting Earthen Wall Totem")
                                        if br._G.SpellIsTargeting() then
                                            br.shaman.resto["Earthen Wall Totem"] = br._G.GetTime()
                                            br._G.SpellStopTargeting()
                                            br.addonDebug(colorRed .. "Canceling Spell")
                                        end
                                        return true
                                    end
                                end
                            end
                            if loc ~= nil then
                                if br.castGroundAtLocation(loc, spell.earthenWallTotem) then
                                    br.addonDebug("Casting Earthen Wall Totem (Cast Ground)")
                                    if br._G.SpellIsTargeting() then
                                        br.shaman.resto["Earthen Wall Totem"] = br._G.GetTime()
                                        br._G.SpellStopTargeting()
                                        br.addonDebug(colorRed .. "Canceling Spell")
                                    end
                                    return true
                                end
                            end
                        end
                    end
                else
                    if br.castWiseAoEHeal(br.friend, spell.earthenWallTotem, 20, ui.value("Earthen Wall Totem"), ui.value("Earthen Wall Totem Targets"), 6, false, true) then
                        br.addonDebug("Casting Earthen Wall Totem (Wise AoE")
                        if br._G.SpellIsTargeting() then
                            br.shaman.resto["Earthen Wall Totem"] = br._G.GetTime()
                            br._G.SpellStopTargeting()
                            br.addonDebug(colorRed .. "Canceling Spell")
                        end
                        return true
                    end
                end
            end
            -- Purify Spirit
            if mode.decurse == 1 and cd.purifySpirit.remain() <= gcd and lowest.hp > 30 then
                for i = 1, #friends.yards40 do
                    if br.canDispel(br.friend[i].unit, spell.purifySpirit) then
                        if cast.purifySpirit(br.friend[i].unit) then
                            br.addonDebug("Casting Purify Spirit")
                            return true
                        end
                    end
                end
            end
            -- Healing Rain on CD
            if
                mode.healingR == 1 and movingCheck and (ui.checked("Healing Rain on CD") or buff.heavyRainfall.exists()) and br._G.GetTime() - br.shaman.resto["Healing Rain"] >= 2 and
                    lowest.hp > 50
             then
                if not buff.healingRain.exists() then
                    -- get melee players
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = br._G.UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil and br.getDistance(tankTarget, "player") < 30 then
                            -- get players in melee range of tank's target
                            local meleeFriends = br.getAllies(tankTarget, 5)
                            -- get the best ground circle to encompass the most of them
                            local loc = nil
                            if not br.isMoving(tanks[i].unit) then
                                if #meleeFriends < 12 then
                                    local x, y, z = br.GetObjectPosition(tanks[i].unit)
                                    loc = {
                                        ["x"] = x + math.random(-2, 2),
                                        ["y"] = y + math.random(-2, 2),
                                        ["z"] = z
                                    }
                                else
                                    if br.castWiseAoEHeal(meleeFriends, spell.healingRain, 10, 100, 1, 6, true, true) then
                                        br.addonDebug("Casting Healing Rain (CD)")
                                        if br._G.SpellIsTargeting() then
                                            br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                            br._G.SpellStopTargeting()
                                            br.addonDebug(colorRed .. "Canceling Spell")
                                        end
                                        return true
                                    end
                                end
                            end
                            if loc ~= nil then
                                if br.castGroundAtLocation(loc, spell.healingRain) then
                                    br.addonDebug("Casting Healing Rain (Cast Ground CD)")
                                    if br._G.SpellIsTargeting() then
                                        br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                        br._G.SpellStopTargeting()
                                        br.addonDebug(colorRed .. "Canceling Spell")
                                    end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            -- Chain Heal with Legendary
            if ui.checked("Chain Heal") and movingCheck and runeforge.spiritwalkersTidalTotem.equiped and buff.spiritwalkersTidalTotem.exists() then
                if br.chainHealUnits(spell.chainHeal, 15, ui.value("Chain Heal"), ui.value("Chain Heal Targets")) then
                    br.addonDebug("Casting Chain Heal")
                    return true
                end
            end
            -- Healing Wave with Legendary
            if ui.checked("Healing Wave") and movingCheck and runeforge.spiritwalkersTidalTotem.equiped and buff.spiritwalkersTidalTotem.exists() then
                if lowest.hp <= ui.value("Healing Wave") then
                    if cast.healingWave(lowest.unit) then
                        br.addonDebug("Casting Healing Wave")
                        return true
                    end
                end
            end
            -- Cooldowns
            if actionList_Cooldowns() then
                return true
            end
            -- Fae Transfusion Heal
            if covenant.nightFae.active and ((br.getLowAllies(ui.value("Fae Transfusion")) >= ui.value("Fae Transfusion Targets")) or buff.faeTransfusionRecast.remain() < 3) then
                if br.castWiseAoEHeal(br.friend, spell.faeTransfusion, 10, ui.value("Fae Transfusion"), ui.value("Fae Transfusion Targets"), 4, false, true) then
                    br.addonDebug("Casting Fae Transfusion (Wise AoE)")
                    return true
                end
            end
            -- Vesper Totem
            if covenant.kyrian.active and br.getLowAllies(ui.value("Vesper Totem")) >= ui.value("Vesper Totem Targets") then
                if br.castWiseAoEHeal(br.friend, spell.vesperTotem, 10, ui.value("Vesper Totem"), ui.value("Vesper Totem Targets"), 6, false, true) then
                    br.addonDebug("Casting Vesper Totem (Wise AoE)")
                    return true
                end
            end
            -- Unleash Life
            if ui.checked("Unleash Life") and talent.unleashLife and not br.hasEquiped(137051) and cd.unleashLife.remain() <= gcd then
                if lowest.hp <= ui.value("Unleash Life") then
                    if castingDPSSpells() then
                        br.addonDebug(colorRed .. "Crit HP detected, cancelling DPS spell")
                        br._G.SpellStopCasting()
                    end
                    if cast.unleashLife(lowest.unit) then
                        br.addonDebug("Casting Unleash Life")
                        return true
                    end
                end
            end
            -- Cloud Burst Totem
            if ui.checked("Cloudburst Totem") and talent.cloudburstTotem and not buff.cloudburstTotem.exists() and cd.cloudburstTotem.remain() <= gcd and #enemies.yards40 > 0 then
                if br.getLowAllies(ui.value("Cloudburst Totem")) >= ui.value("Cloudburst Totem Targets") then
                    if cast.cloudburstTotem("player") then
                        br.addonDebug("Casting Cloud Burst Totem")
                        br.ChatOverlay(colorGreen .. "Cloudburst Totem!")
                        return true
                    end
                end
            end
            -- Healing Wave (Necrolord)
            if covenant.necrolord.active and buff.primordialWave.exists() and movingCheck then
                if cast.healingWave(lowest.unit) then
                    br.addonDebug("Casting Healing Wave (Primordial Wave buff)")
                    return true
                end
            end
            -- Primordial Wave
            if ui.checked("Primordial Wave") and covenant.necrolord.active then
                for i = 1, #br.friend do
                    if buff.riptide.refresh(br.friend[i].unit) and br.friend[i].hp < (ui.value("Primordial Wave")) then
                        if cast.primordialWave(br.friend[i].unit) then
                            br.addonDebug("Casting Primordial Wave")
                            return true
                        end
                    end
                end
            end
            --Chain Harvest
            if ui.checked("Chain Harvest") and covenant.venthyr.active then
                if br.getLowAllies(ui.value("Chain Harvest")) >= ui.value("Chain Harvest Targets") then
                    if castingDPSSpells() then
                        br.addonDebug(colorRed .. "Crit HP detected, cancelling DPS spell")
                        br._G.SpellStopCasting()
                    end
                    if cast.chainHarvest(lowest.unit) then
                        br.addonDebug("Casting Chain Harvest")
                        return true
                    end
                end
            end
            -- Healing Rain
            if movingCheck and cd.healingRain.remain() <= gcd and br._G.GetTime() - br.shaman.resto["Healing Rain"] >= 2 then
                if not buff.healingRain.exists() and mode.healingR == 1 then
                    if ui.checked("Healing Rain on Melee") then
                        -- get melee players
                        for i = 1, #tanks do
                            -- get the tank's target
                            local tankTarget = br._G.UnitTarget(tanks[i].unit)
                            if tankTarget ~= nil and br.getDistance(tankTarget, "player") < 30 then
                                -- get players in melee range of tank's target
                                local meleeFriends = br.getAllies(tankTarget, 5)
                                -- get the best ground circle to encompass the most of them
                                local loc = nil
                                local meleeHurt = {}
                                for j = 1, #meleeFriends do
                                    if meleeFriends[j].hp < ui.value("Healing Rain") then
                                        br._G.tinsert(meleeHurt, meleeFriends[j])
                                    end
                                end
                                if #meleeHurt >= ui.value("Healing Rain Targets") then
                                    if #meleeHurt < 12 then
                                        loc = br.getBestGroundCircleLocation(meleeHurt, ui.value("Healing Rain Targets"), 6, 10)
                                    else
                                        if br.castWiseAoEHeal(meleeHurt, spell.healingRain, 10, ui.value("Healing Rain"), ui.value("Healing Rain Targets"), 6, true, true) then
                                            br.addonDebug("Casting Healing Rain")
                                            if br._G.SpellIsTargeting() then
                                                br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                                br._G.SpellStopTargeting()
                                                br.addonDebug(colorRed .. "Canceling Spell")
                                            end
                                            return true
                                        end
                                    end
                                end
                                if loc ~= nil then
                                    if br.castGroundAtLocation(loc, spell.healingRain) then
                                        br.addonDebug("Casting Healing Rain (Cast Ground)")
                                        if br._G.SpellIsTargeting() then
                                            br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                            br._G.SpellStopTargeting()
                                            br.addonDebug(colorRed .. "Canceling Spell")
                                        end
                                        return true
                                    end
                                end
                            end
                        end
                    else
                        if br.castWiseAoEHeal(br.friend, spell.healingRain, 10, ui.value("Healing Rain"), ui.value("Healing Rain Targets"), 6, true, true) then
                            br.addonDebug("Casting Healing Rain (Wise AoE)")
                            if br._G.SpellIsTargeting() then
                                br.shaman.resto["Healing Rain"] = br._G.GetTime()
                                br._G.SpellStopTargeting()
                                br.addonDebug(colorRed .. "Canceling Spell")
                            end
                            return true
                        end
                    end
                end
            end
            -- Wellspring
            if ui.checked("Wellspring") and talent.wellspring and cd.wellspring.remain() <= gcd and movingCheck then
                if br.healConeAround(ui.value("Wellspring Targets"), ui.value("Wellspring"), 90, 30, 0) then
                    if cast.wellspring() then
                        br.addonDebug("Casting Wellspring")
                        return true
                    end
                end
            end
            -- Surge of Earth
            if ui.checked("Surge of Earth") and talent.surgeOfEarth then
                for i = 1, #tanks do
                    local unitsAroundTank = br.getAllies(tanks[i].unit, 8)
                    if #unitsAroundTank > 0 and br.getLowAlliesInTable(ui.value("Surge of Earth"), unitsAroundTank) >= 3 and buff.earthShield.stacks(tanks[i].unit) >= 3 then
                        if cast.surgeOfEarth() then
                            br.addonDebug("Casting Surge Of Earth")
                            return true
                        end
                    end
                end
            end
            -- Chain Heal
            if ui.checked("Chain Heal") and movingCheck then
                if talent.unleashLife and talent.highTide then
                    if cast.unleashLife(lowest.unit) then
                        return true
                    end
                    if buff.unleashLife.remain() > 2 then
                        if br.chainHealUnits(spell.chainHeal, 15, ui.value("Chain Heal"), ui.value("Chain Heal Targets") + 1) then
                            br.addonDebug("Casting Chain Heal")
                            return true
                        end
                    end
                elseif talent.highTide then
                    if br.chainHealUnits(spell.chainHeal, 15, ui.value("Chain Heal"), ui.value("Chain Heal Targets") + 1) then
                        br.addonDebug("Casting Chain Heal")
                        return true
                    end
                else
                    if br.chainHealUnits(spell.chainHeal, 15, ui.value("Chain Heal"), ui.value("Chain Heal Targets")) then
                        br.addonDebug("Casting Chain Heal")
                        return true
                    end
                end
            end
            -- Healing Surge (2 stacks)
            if ui.checked("Healing Surge") and movingCheck then
                if lowest.hp <= ui.value("Healing Surge") and buff.tidalWaves.stack() == 2 then
                    if castingDPSSpells() then
                        br.addonDebug(colorRed .. "Crit HP detected, cancelling DPS spell")
                        br._G.SpellStopCasting()
                    end
                    if cast.healingSurge(lowest.unit) then
                        br.addonDebug("Casting Healing Surge")
                        return true
                    end
                end
            end
            -- Healing Wave
            if ui.checked("Healing Wave") and movingCheck and not burst then
                if lowest.hp <= ui.value("Healing Wave") and buff.tidalWaves.stack() == 2 then
                    if castingDPSSpells() then
                        br.addonDebug(colorRed .. "Crit HP detected, cancelling DPS spell")
                        br._G.SpellStopCasting()
                    end
                    if cast.healingWave(lowest.unit) then
                        br.addonDebug("Casting Healing Wave")
                        return true
                    end
                end
            end
            -- Riptide
            if ui.checked("Riptide") and charges.riptide.count() > 0 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= ui.value("Riptide") and buff.riptide.refresh(br.friend[i].unit) then
                        if cast.riptide(br.friend[i].unit) then
                            br.addonDebug("Casting Riptide (Party)")
                            return true
                        end
                    end
                end
            end
            -- Downpour
            if cd.downpour.remain() <= gcd and movingCheck then
                if ui.checked("Downpour") then
                    if ui.checked("Downpour on Melee") then
                        -- get melee players
                        for i = 1, #tanks do
                            -- get the tank's target
                            local tankTarget = br._G.UnitTarget(tanks[i].unit)
                            if tankTarget ~= nil and br.getDistance(tankTarget) <= 40 then
                                -- get players in melee range of tank's target
                                local meleeFriends = br.getAllies(tankTarget, 5)
                                -- get the best ground circle to encompass the most of them
                                local loc = nil
                                local meleeHurt = {}
                                for j = 1, #meleeFriends do
                                    if meleeFriends[j].hp < ui.value("Downpour") then
                                        br._G.tinsert(meleeHurt, meleeFriends[j])
                                    end
                                end
                                if #meleeHurt >= ui.value("Downpour Targets") then
                                    if #meleeHurt < 12 then
                                        loc = br.getBestGroundCircleLocation(meleeHurt, ui.value("Downpour Targets"), 6, 10)
                                    else
                                        if br.castWiseAoEHeal(meleeHurt, spell.downpour, 10, ui.value("Downpour"), ui.value("Downpour Targets"), 6, true, true) then
                                            if br._G.SpellIsTargeting() then
                                                br._G.SpellStopTargeting()
                                                br.addonDebug(colorRed .. "Canceling Spell")
                                            end
                                            br.addonDebug("Casting Downpour")
                                            return true
                                        end
                                    end
                                end
                                if loc ~= nil then
                                    if br.castGroundAtLocation(loc, spell.downpour) then
                                        if br._G.SpellIsTargeting() then
                                            br._G.SpellStopTargeting()
                                            br.addonDebug(colorRed .. "Canceling Spell")
                                        end
                                        br.addonDebug("Casting Downpour")
                                        return true
                                    end
                                end
                            end
                        end
                    else
                        if br.castWiseAoEHeal(br.friend, spell.downpour, 10, ui.value("Downpour"), ui.value("Downpour Targets"), 6, true, true) then
                            if br._G.SpellIsTargeting() then
                                br._G.SpellStopTargeting()
                                br.addonDebug(colorRed .. "Canceling Spell")
                            end
                            br.addonDebug("Casting Downpour")
                            return true
                        end
                    end
                end
            end
            -- Healing Stream Totem
            if ui.checked("Healing Stream Totem") and not talent.cloudburstTotem and movingCheck and not buff.swirlingCurrents.exists() then
                if lowest.hp <= ui.value("Healing Stream Totem") then
                    if not talent.echoOfTheElements then
                        if cast.healingStreamTotem(lowest.unit) then
                            br.addonDebug("Casting Healing Stream Totem")
                            return true
                        end
                    elseif talent.echoOfTheElements and (not br.shaman.HSTime or br._G.GetTime() - br.shaman.HSTime > 15) then
                        if cast.healingStreamTotem(lowest.unit) then
                            br.addonDebug("Casting Healing Stream Totem")
                            br.shaman.HSTime = br._G.GetTime()
                            return true
                        end
                    end
                end
            end
            -- Healing Surge
            if ui.checked("Healing Surge") and movingCheck then
                if lowest.hp <= ui.value("Healing Surge") then
                    if castingDPSSpells() then
                        br.addonDebug(colorRed .. "Crit HP detected, cancelling DPS spell")
                        br._G.SpellStopCasting()
                    end
                    if cast.healingSurge(lowest.unit) then
                        br.addonDebug("Casting Healing Surge")
                        return true
                    end
                end
            end
            -- Healing Wave
            if ui.checked("Healing Wave") and movingCheck and not burst then
                if lowest.hp <= ui.value("Healing Wave") then
                    if castingDPSSpells() then
                        br.addonDebug(colorRed .. "Crit HP detected, cancelling DPS spell")
                        br._G.SpellStopCasting()
                    end
                    if cast.healingWave(lowest.unit) then
                        br.addonDebug("Casting Healing Wave")
                        return true
                    end
                end
            end
            -- Chain Lightning with legendaries (To Do)
            if runeforge.chainsOfDevastation.equiped and not buff.chainsOfDevastationHeal.exists() then
                if cast.chainLightning() then
                    br.addonDebug("Casting Chain Lightning (Chains of Devastation)")
                end
            end
        end
        -----------------
        --- Rotations ---
        -----------------
        if not ui.checked("HE Active") and br.timer:useTimer("Error delay", 0.5) then
            br._G.print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
            return
        end
        if inCombat and not ui.checked("Disable Auto Ground Cast Circle Cancel") then
            if br._G.SpellIsTargeting() then
                br._G.SpellStopTargeting()
                br.addonDebug(colorRed .. "Canceling Spell")
            end
        end
        ghostWolf()
        actionList_Interrupts()
        -- Pause
        if br.pause() or cd.global.remains() > 0 then
            return true
        else
            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------
            if not inCombat and not br._G.IsMounted() and not drinking then
                if (buff.ghostWolf.exists() and mode.ghostWolf == 1) or not buff.ghostWolf.exists() then
                    actionList_Extras()
                    if ui.checked("OOC Healing") then
                        actionList_PreCombat()
                    end
                    -- Purify Spirit
                    if mode.decurse == 1 and cd.purifySpirit.remain() <= gcd then
                        for i = 1, #friends.yards40 do
                            if br.canDispel(br.friend[i].unit, spell.purifySpirit) then
                                if cast.purifySpirit(br.friend[i].unit) then
                                    br.addonDebug("Casting Purify Spirit")
                                    return
                                end
                            end
                        end
                    end
                end
            end -- End Out of Combat Rotation
            -----------------------------
            --- In Combat - Rotations ---
            -----------------------------
            if inCombat and not br._G.IsMounted() and not drinking then
                if (buff.ghostWolf.exists() and mode.ghostWolf == 1) or not buff.ghostWolf.exists() then
                    actionList_Defensive()
                    -- Purge
                    if ui.checked("Purge") and lowest.hp > ui.value("DPS Threshold") and power >= ui.value("Purge Min Mana") then
                        if ui.value("Purge") == 1 then
                            if br.canDispel("target", spell.purge) and br.GetObjectExists("target") then
                                if cast.purge("target") then
                                    br.addonDebug("Casting Purge")
                                    return true
                                end
                            end
                        elseif ui.value("Purge") == 2 then
                            for i = 1, #enemies.yards30 do
                                local thisUnit = enemies.yards30[i]
                                if br.canDispel(thisUnit, spell.purge) then
                                    if cast.purge(thisUnit) then
                                        br.addonDebug("Casting Purge")
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    if ui.checked("DPS Key") and br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() then
                        if actionList_dpsKey() then
                            return
                        end
                    end
                    if actionList_AMR() then
                        return
                    end
                    --if not ui.checked("Healing Rain on CD") or buff.healingRain.exists() or mode.healingR ~= 1 or not tankIsNotMoving then
                    if
                        mode.dPS == 1 and br.GetUnitExists("target") and br._G.UnitCanAttack("player", "target") and br.getFacing("player", "target") and
                            lowest.hp > ui.value("DPS Threshold")
                     then
                        br.addonDebug("Using DPS APL as lowest unit is at " .. tostring(lowest.hp))
                        if br.isExplosive("target") then
                            actionList_Explosive()
                        else
                            actionList_DPS()
                        end
                    end
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
--local id = 264
local id = 264
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
br._G.tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)
