-- Personal Spacer - ESO AddOn
-- Author: AETzAR
-- Design Philosophy: "Respect the Dark" — illuminate only when needed, return peace when not.
-- Version: 1.2.0

local ADDON_NAME = "PersonalSpacer"
local SPACER_VERSION = "1.2.0"

-- Defaults
local DEFAULT_RADIUS = 10
local DEFAULT_COLOR = { 1, 0.8, 0.2, 0.4 } -- RGBA: Gold, translucent
local DEFAULT_ENABLED = false
local RESPECT_DARK_ENABLED = true
local FADE_DURATION = 500 -- ms for smooth transitions
local PEACEFUL_ALPHA = 0.15
local ACTIVE_ALPHA = 0.4
local STEALTH_ALPHA = 0.6
local COMBAT_ALPHA = 0.5
local AUTO_HIDE_IN_PEACE = true
local METERS_TO_UNITS = 64

-- Texture paths (must match files in Textures/)
local TEXTURE_DEFAULT = "PersonalSpacer/Textures/spacer_circle.dds"
local TEXTURE_DIM = "PersonalSpacer/Textures/spacer_circle_DIM.dds"
local TEXTURE_BRIGHT = "PersonalSpacer/Textures/spacer_circle_BRIGHT.dds"

-- Runtime
local spacerControl = nil
local isEnabled = DEFAULT_ENABLED
local currentRadius = DEFAULT_RADIUS

-- Saved variables
PersonalSpacer_SavedVars = PersonalSpacer_SavedVars or {
    enabled = DEFAULT_ENABLED,
    radius = DEFAULT_RADIUS,
    color = DEFAULT_COLOR,
    respectDark = RESPECT_DARK_ENABLED,
    autoHide = AUTO_HIDE_IN_PEACE,
    autoTexture = false,
    baseTexture = TEXTURE_DEFAULT,
    lastContext = "peaceful"
}

-- Create the spacer control
local function CreateSpacerControl()
    local control = WINDOW_MANAGER:CreateControl("PersonalSpacerCircle", GuiRoot, CT_TEXTURE)
    
    -- Set saved texture or default
    local savedTexture = PersonalSpacer_SavedVars.baseTexture or TEXTURE_DEFAULT
    control:SetTexture(savedTexture)
    
    local diameter = currentRadius * METERS_TO_UNITS
    control:SetDimensions(diameter, diameter)
    
    control:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
    control:SetColor(unpack(DEFAULT_COLOR))
    control:SetAlpha(0)
    control:SetBlendMode(TEX_BLEND_MODE_ALPHA)
    control:SetDrawLayer(DL_OVERLAY)
    control:SetDrawTier(DT_MEDIUM)
    control:SetHidden(true)
    
    return control
end

-- Determine player context
local function GetPlayerContext()
    local isInCombat = IsUnitInCombat("player")
    local isStealthed = IsStealthed()
    local isCrafting = GetCraftingInteractionType() ~= 0
    local isBattleground = IsActiveWorldBattleground()
    local isInHouse = IsHousingZone()
    
    local isPeaceful = not isInCombat and not isStealthed 
                      and not isCrafting and not isBattleground
    
    if isPeaceful and isInHouse then
        return "home"
    elseif isStealthed then
        return "stealth"
    elseif isInCombat then
        return "combat"
    elseif isCrafting then
        return "crafting"
    elseif isPeaceful then
        return "peaceful"
    else
        return "active"
    end
end

-- Smooth alpha transition
local function SmoothAlpha(control, targetAlpha, deltaTime)
    local currentAlpha = control:GetAlpha()
    if math.abs(currentAlpha - targetAlpha) < 0.01 then
        return targetAlpha
    end
    
    local speed = 5.0 * (deltaTime or 0.05)
    local newAlpha = currentAlpha + (targetAlpha - currentAlpha) * speed
    control:SetAlpha(newAlpha)
    return newAlpha
end

-- World to screen conversion
local function WorldToScreen(x, y, z)
    local success, sx, sy = GuiRoot:ConvertWorldToScreen(x, y, z)
    return success and sx or 0, success and sy or 0
end

-- Update spacer position and appearance
local lastUpdate = 0
local function UpdateSpacerPosition()
    if not spacerControl or not isEnabled then return end
    
    local now = GetFrameTimeSeconds()
    local delta = now - (lastUpdate or 0)
    lastUpdate = now
    
    -- Get context
    local context = GetPlayerContext()
    PersonalSpacer_SavedVars.lastContext = context
    
    -- Auto texture switching (if enabled)
    if RESPECT_DARK_ENABLED and (PersonalSpacer_SavedVars.autoTexture or false) then
        local newTexture
        if context == "peaceful" or context == "home" then
            newTexture = TEXTURE_DIM
        elseif context == "stealth" or context == "combat" then
            newTexture = TEXTURE_BRIGHT
        else
            newTexture = TEXTURE_DEFAULT
        end
        
        if spacerControl:GetTexture() ~= newTexture then
            spacerControl:SetTexture(newTexture)
        end
    end
    
    -- Determine target alpha
    local targetAlpha = 0
    if RESPECT_DARK_ENABLED then
        if context == "peaceful" and AUTO_HIDE_IN_PEACE then
            targetAlpha = PEACEFUL_ALPHA
        elseif context == "stealth" then
            targetAlpha = STEALTH_ALPHA
        elseif context == "combat" then
            targetAlpha = COMBAT_ALPHA
        elseif context == "home" then
            targetAlpha = PEACEFUL_ALPHA * 0.5
        else
            targetAlpha = ACTIVE_ALPHA
        end
    else
        targetAlpha = ACTIVE_ALPHA
    end
    
    -- Apply smooth alpha transition
    SmoothAlpha(spacerControl, targetAlpha, delta)
    
    -- Update position
    local x, y, z = GetUnitRawWorldPosition("player")
    z = z - 50 -- Ground adjustment
    local screenX, screenY = WorldToScreen(x, y, z)
    
    local cameraDistance = GetCameraDistance()
    local scale = 1.0 + (cameraDistance / 200)
    
    spacerControl:ClearAnchors()
    spacerControl:SetAnchor(CENTER, GuiRoot, TOPLEFT, screenX, screenY)
    spacerControl:SetScale(scale)
end

-- Toggle spacer
local function ToggleSpacer(enable)
    if enable == nil then enable = not isEnabled end
    isEnabled = enable
    
    if not spacerControl then
        spacerControl = CreateSpacerControl()
    end
    
    if isEnabled then
        spacerControl:SetHidden(false)
        EVENT_MANAGER:RegisterForUpdate(ADDON_NAME .. "Updater", 50, UpdateSpacerPosition)
        d("Personal Spacer enabled. Context: " .. GetPlayerContext())
    else
        -- Fade out before hiding
        local fadeOut = function()
            local alpha = spacerControl:GetAlpha()
            if alpha > 0.01 then
                spacerControl:SetAlpha(alpha * 0.8)
            else
                spacerControl:SetHidden(true)
                EVENT_MANAGER:UnregisterForUpdate(ADDON_NAME .. "FadeOut")
            end
        end
        EVENT_MANAGER:RegisterForUpdate(ADDON_NAME .. "FadeOut", 50, fadeOut)
        d("Personal Spacer fading out.")
    end
    PersonalSpacer_SavedVars.enabled = isEnabled
end

-- Set radius
local function SetSpacerRadius(newRadius)
    if type(newRadius) == "number" and newRadius >= 5 and newRadius <= 30 then
        currentRadius = newRadius
        if spacerControl then
            local diameter = currentRadius * METERS_TO_UNITS
            spacerControl:SetDimensions(diameter, diameter)
        end
        PersonalSpacer_SavedVars.radius = newRadius
        return true
    end
    return false
end

-- Set texture directly (for slash command)
local function SetSpacerTexture(texturePath)
    if spacerControl then
        spacerControl:SetTexture(texturePath)
        PersonalSpacer_SavedVars.baseTexture = texturePath
        return true
    end
    return false
end

-- Slash commands
SLASH_COMMANDS["/spacer"] = function(args)
    args = args and string.lower(args) or ""
    
    if args == "on" then
        ToggleSpacer(true)
    elseif args == "off" then
        ToggleSpacer(false)
    elseif args == "toggle" then
        ToggleSpacer()
    elseif args == "context" then
        d("Current context: " .. GetPlayerContext())
    elseif string.find(args, "radius") then
        local radius = tonumber(string.match(args, "radius%s+(%d+)"))
        if radius and SetSpacerRadius(radius) then
            d("Radius set to " .. radius .. "m.")
        else
            d("Invalid radius. Use /spacer radius 5-30")
        end
    elseif args == "texture default" then
        SetSpacerTexture(TEXTURE_DEFAULT)
        d("Texture: Default")
    elseif args == "texture dim" then
        SetSpacerTexture(TEXTURE_DIM)
        d("Texture: Dim")
    elseif args == "texture bright" then
        SetSpacerTexture(TEXTURE_BRIGHT)
        d("Texture: Bright")
    elseif args == "respect" then
        RESPECT_DARK_ENABLED = not RESPECT_DARK_ENABLED
        d("Respect the Dark mode: " .. (RESPECT_DARK_ENABLED and "ON" or "OFF"))
    elseif args == "autotexture" then
        PersonalSpacer_SavedVars.autoTexture = not (PersonalSpacer_SavedVars.autoTexture or false)
        d("Auto texture switching: " .. (PersonalSpacer_SavedVars.autoTexture and "ON" or "OFF"))
    else
        d("Personal Spacer v" .. SPACER_VERSION)
        d("  /spacer on|off|toggle")
        d("  /spacer radius <5-30>")
        d("  /spacer texture [default|dim|bright]")
        d("  /spacer context")
        d("  /spacer respect")
        d("  /spacer autotexture")
        d("  /spacer settings")
    end
end

SLASH_COMMANDS["/personalring"] = SLASH_COMMANDS["/spacer"]

-- Initialize
local function Initialize()
    -- Load saved settings
    currentRadius = PersonalSpacer_SavedVars.radius or DEFAULT_RADIUS
    RESPECT_DARK_ENABLED = PersonalSpacer_SavedVars.respectDark or true
    AUTO_HIDE_IN_PEACE = PersonalSpacer_SavedVars.autoHide or true
    
    -- Apply saved color
    if PersonalSpacer_SavedVars.color then
        DEFAULT_COLOR = PersonalSpacer_SavedVars.color
    end
    
    -- Create control
    spacerControl = CreateSpacerControl()
    
    -- Restore enabled state
    if PersonalSpacer_SavedVars.enabled then
        ToggleSpacer(true)
    end
    
    d(ADDON_NAME .. " v" .. SPACER_VERSION .. " loaded.")
    d("Philosophy: Respect the Dark — illuminate only when needed.")
    d("Type /spacer for options.")
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, function(_, addonName)
    if addonName ~= ADDON_NAME then return end
    Initialize()
    EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
end)