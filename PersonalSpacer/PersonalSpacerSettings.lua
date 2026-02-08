-- Personal Spacer Settings UI
-- Requires LibAddonMenu-2.0

local LAM = LibAddonMenu2

-- Texture names (must match files in Textures/)
local TEXTURE_DEFAULT = "PersonalSpacer/Textures/spacer_circle.dds"
local TEXTURE_DIM = "PersonalSpacer/Textures/spacer_circle_DIM.dds"
local TEXTURE_BRIGHT = "PersonalSpacer/Textures/spacer_circle_BRIGHT.dds"

local function CreateSettingsPanel()
    local panelData = {
        type = "panel",
        name = "Personal Spacer",
        displayName = "|cFFD700Personal Spacer|r",
        author = "AETzAR and Kael",
        version = "1.2.0",
        registerForRefresh = true,
        website = "https://github.com/AETzAR/PersonalSpacer",
        slashCommand = "/spacer settings",
    }

    local optionsTable = {
        {
            type = "header",
            name = "|cFFD700Core Settings|r",
            width = "full",
        },
        {
            type = "checkbox",
            name = "Enable Spacer",
            tooltip = "Show/hide the ground circle.",
            getFunc = function() return isEnabled end,
            setFunc = function(value)
                ToggleSpacer(value)
                PersonalSpacer_SavedVars.enabled = value
            end,
            width = "full",
        },
        {
            type = "slider",
            name = "Radius (meters)",
            tooltip = "Adjust the radius of the circle.",
            min = 5,
            max = 30,
            step = 1,
            getFunc = function() return currentRadius end,
            setFunc = function(value)
                if SetSpacerRadius(value) then
                    PersonalSpacer_SavedVars.radius = value
                end
            end,
            width = "full",
        },
        {
            type = "dropdown",
            name = "Base Texture",
            tooltip = "Choose the default circle texture.",
            choices = { "Default", "Dim", "Bright" },
            choicesValues = { TEXTURE_DEFAULT, TEXTURE_DIM, TEXTURE_BRIGHT },
            getFunc = function()
                return PersonalSpacer_SavedVars.baseTexture or TEXTURE_DEFAULT
            end,
            setFunc = function(value)
                PersonalSpacer_SavedVars.baseTexture = value
                if spacerControl then
                    spacerControl:SetTexture(value)
                end
            end,
            width = "full",
        },
        {
            type = "colorpicker",
            name = "Circle Color",
            tooltip = "Tint the circle texture (white texture recommended).",
            getFunc = function()
                if spacerControl then
                    return spacerControl:GetColor()
                end
                return unpack(DEFAULT_COLOR)
            end,
            setFunc = function(r, g, b, a)
                if spacerControl then
                    spacerControl:SetColor(r, g, b, a)
                    PersonalSpacer_SavedVars.color = { r, g, b, a }
                end
            end,
            width = "full",
        },
        {
            type = "header",
            name = "|cFFD700Respect the Dark|r",
            width = "full",
        },
        {
            type = "checkbox",
            name = "Enable Context‑Aware Fading",
            tooltip = "Circle brightness adapts to stealth, combat, crafting, and peaceful moments.",
            getFunc = function() return RESPECT_DARK_ENABLED end,
            setFunc = function(value)
                RESPECT_DARK_ENABLED = value
                PersonalSpacer_SavedVars.respectDark = value
            end,
            width = "full",
        },
        {
            type = "checkbox",
            name = "Auto Texture Switching",
            tooltip = "Automatically switch textures based on context (uses Dim/Bright variants).",
            getFunc = function() return PersonalSpacer_SavedVars.autoTexture or false end,
            setFunc = function(value)
                PersonalSpacer_SavedVars.autoTexture = value
            end,
            width = "full",
            disabled = function() return not RESPECT_DARK_ENABLED end,
        },
        {
            type = "checkbox",
            name = "Auto‑Hide in Safe Zones",
            tooltip = "Fade to minimal visibility in cities, inns, and homes.",
            getFunc = function() return AUTO_HIDE_IN_PEACE end,
            setFunc = function(value)
                AUTO_HIDE_IN_PEACE = value
                PersonalSpacer_SavedVars.autoHide = value
            end,
            width = "full",
        },
        {
            type = "slider",
            name = "Peaceful Opacity",
            tooltip = "Visibility when in safe, non‑active contexts.",
            min = 0.05,
            max = 0.5,
            step = 0.05,
            getFunc = function() return PEACEFUL_ALPHA end,
            setFunc = function(value)
                PEACEFUL_ALPHA = value
                PersonalSpacer_SavedVars.peacefulAlpha = value
            end,
            width = "full",
            disabled = function() return not RESPECT_DARK_ENABLED end,
        },
        {
            type = "header",
            name = "|cFFD700Advanced|r",
            width = "full",
        },
        {
            type = "description",
            text = "This addon uses only approved UI APIs.|nNo combat automation, no targeting, no game‑mechanics interaction.|n|nDesigned for accessibility and spatial awareness.",
            width = "full",
        },
        {
            type = "button",
            name = "Reset to Defaults",
            tooltip = "Restore all settings to initial values.",
            func = function()
                DEFAULT_RADIUS = 10
                RESPECT_DARK_ENABLED = true
                AUTO_HIDE_IN_PEACE = true
                SetSpacerRadius(DEFAULT_RADIUS)
                if spacerControl then
                    spacerControl:SetColor(unpack(DEFAULT_COLOR))
                    spacerControl:SetTexture(TEXTURE_DEFAULT)
                end
                d("Personal Spacer reset to defaults.")
            end,
            width = "full",
        },
    }

    LAM:RegisterAddonPanel("PersonalSpacerSettings", panelData)
    LAM:RegisterOptionControls("PersonalSpacerSettings", optionsTable)
end

-- Initialize when ready
local function InitSettings()
    if LAM then
        CreateSettingsPanel()
    else
        EVENT_MANAGER:RegisterForEvent("PersonalSpacer_LAM", EVENT_ADD_ON_LOADED, function(_, addonName)
            if addonName == "LibAddonMenu-2.0" then
                CreateSettingsPanel()
                EVENT_MANAGER:UnregisterForEvent("PersonalSpacer_LAM", EVENT_ADD_ON_LOADED)
            end
        end)
    end
end

EVENT_MANAGER:RegisterForEvent("PersonalSpacer_SettingsInit", EVENT_ADD_ON_LOADED, function(_, addonName)
    if addonName == "PersonalSpacer" then
        InitSettings()
        EVENT_MANAGER:UnregisterForEvent("PersonalSpacer_SettingsInit", EVENT_ADD_ON_LOADED)
    end
end)