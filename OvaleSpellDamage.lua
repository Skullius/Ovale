--[[--------------------------------------------------------------------
    Ovale Spell Priority
    Copyright (C) 2012 Sidoine
    Copyright (C) 2012, 2013 Johnny C. Lam

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License in the LICENSE
    file accompanying this program.
--]]--------------------------------------------------------------------

-- Add-on that registers how many damage made the last spell cast by the player

local _, Ovale = ...
local OvaleSpellDamage = Ovale:NewModule("OvaleSpellDamage", "AceEvent-3.0")
Ovale.OvaleSpellDamage = OvaleSpellDamage

--<private-static-properties>
-- Forward declarations for module dependencies.
local OvaleGUID = nil

local select = select
local strfind = string.find

-- Player's GUID.
local self_guid = nil
--</private-static-properties>

--<public-static-properties>
OvaleSpellDamage.value = {}
--</public-static-properties>

--<public-static-methods>
function OvaleSpellDamage:OnInitialize()
	OvaleGUID = Ovale.OvaleGUID
end

function OvaleSpellDamage:OnEnable()
	self_guid = OvaleGUID:GetGUID("player")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function OvaleSpellDamage:OnDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function OvaleSpellDamage:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local time, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = select(1, ...)

	if sourceGUID == self_guid then
		if strfind(event, "SPELL_PERIODIC_DAMAGE")==1 or strfind(event, "SPELL_DAMAGE")==1 then
			local spellId, spellName, spellSchool, amount = select(12, ...)
			self.value[spellId] = amount
		end
	end
end

function OvaleSpellDamage:Get(spellId)
	return self.value[spellId]
end
--</public-static-methods>
