local Events      = Ext.Require("Shared/Events.lua")
local Utility     = Ext.Require("Shared/Utility.lua")

local MOD_UUIDS   = {
	["5eSpells"] = "fb5f528d-4d48-4bf2-a668-2274d3cfba96",
	Mystra       = "4b516620-9c56-aa18-96ae-a9ee4f57b515"
}

local COSMIC_LISTS = {
    {
        uuid = "fddbf5f5-b74f-422f-8d58-6cf0cab777ea", level = 3    -- AlwaysPrepared SLevel 3
        entries = {
            {{"5eSpells", "Projectile_MinuteMeteors"}},
            {{"Mystra", "Shout_MelfsMinuteMeteors"}}
        }
    },
    {
        uuid = "d0b874b1-6d16-40f6-8ee2-49eab10fee93", level = 3    -- SLevel 3
        entries = {
            {{"5eSpells", "Projectile_MinuteMeteors"}},
            {{"Mystra", "Shout_MelfsMinuteMeteors"}}
        }
    },
    {
        uuid = "4ea77ce1-4c71-425b-a2bc-562ac0764710", level = 5    -- AlwaysPrepared SLevel 5
        entries = {
            {{"5eSpells", "Target_FarStep"}},
            {{"Mystra", "Shout_FarStep"}}
        }
    },
    {
        uuid = "75342813-b966-45de-a3e4-76c85146f440", level = 5    -- SLevel 5
        entries = {
            {{"5eSpells", "Target_FarStep"}},
            {{"Mystra", "Shout_FarStep"}}
        }
    }
}

local function ResolveSpell(entry)
    for _, pair in ipairs(entry) do
        if Ext.Mod.IsLoaded(MOD_UUIDS[pair[1]]) then return pair[2] end
    end
end

local function SortSpellList(spells)
    table.sort(spells, function(a, b)
		local sa, sb = Ext.Stats.Get(a), Ext.Stats.Get(b)
		local la = tonumber(sa and sa.Level) or 0
		local lb = tonumber(sb and sb.Level) or 0
		if la ~= lb then return la > lb end
		-- local ea = (sa and sa.SpellSchool) or ""
		-- local eb = (sb and sb.SpellSchool) or ""
		-- if ea ~= eb then return ea < eb end
		return Utility.ResolveDisplayName(sa and sa.DisplayName, a)
			 < Utility.ResolveDisplayName(sb and sb.DisplayName, b)
	end)
    return spells
end

local function MergeLists()
    if Ext.Mod.IsModLoaded("71f4c896-045d-4bb9-b7ad-55f1332b61d2") then -- Spell List Sorter
		local blacklist = Mods.SpellListSorter.Blacklist
		for _, list in ipairs(COSMIC_LISTS) do blacklist[list.uuid] = true end
	end

    local foundMods = {}
	for mod, uuid in pairs(MOD_UUIDS) do
		if Ext.Mod.IsModLoaded(uuid) then foundMods[#foundMods + 1] = Ext.Mod.GetMod(uuid).Info.Name end
	end

--  if #foundMods == 0 then
--		NZWPrint():C10("[NZW]"):C11(" No spell mods found, skipping"):Print()
--		return
--	end

    local additions = {}

	local function add(uuid, spell)
		additions[uuid] = additions[uuid] or {}
		additions[uuid][spell] = true
	end

    for srcIdx, src in ipairs(COSMIC_LISTS) do
		for _, entry in ipairs(src.entries) do
			local spell = ResolveSpell(entry)
			if spell and Ext.Stats.Get(spell, nil, false) ~= nil then
				if src.level == 0 then
					add(src.uuid, spell)
				else
					for trgtIdx = srcIdx, #COSMIC_LISTS do
						add(COSMIC_LISTS[trgtIdx].uuid, spell)
					end
				end
			end
		end
	end

    for uuid, spellSet in pairs(additions) do
		local list = Ext.StaticData.Get(uuid, "SpellList")
		if list then
			local spells = {}
			local seen   = {}
			{{"ATT", "Target_Weird"}},
			{{"Valk", "Zone_ValkranaVerweskundir"}}
		}
	}
}

local function ResolveSpell(entry)
	for _, pair in ipairs(entry) do
		if Ext.Mod.IsModLoaded(MOD_UUIDS[pair[1]]) then return pair[2] end
	end
end

local function SortSpellList(spells)
	table.sort(spells, function(a, b)
		local sa, sb = Ext.Stats.Get(a), Ext.Stats.Get(b)
		local la = tonumber(sa and sa.Level) or 0
		local lb = tonumber(sb and sb.Level) or 0
		if la ~= lb then return la > lb end
		-- local ea = (sa and sa.SpellSchool) or ""
		-- local eb = (sb and sb.SpellSchool) or ""
		-- if ea ~= eb then return ea < eb end
		return Utility.ResolveDisplayName(sa and sa.DisplayName, a)
			 < Utility.ResolveDisplayName(sb and sb.DisplayName, b)
	end)
	return spells
end

local function MergeLists()
	if Ext.Mod.IsModLoaded("71f4c896-045d-4bb9-b7ad-55f1332b61d2") then
		local blacklist = Mods.SpellListSorter.Blacklist
		for _, list in ipairs(WITCH_LISTS) do blacklist[list.uuid] = true end
	end

	local foundMods = {}
	for mod, uuid in pairs(MOD_UUIDS) do
		if Ext.Mod.IsModLoaded(uuid) then foundMods[#foundMods + 1] = Ext.Mod.GetMod(uuid).Info.Name end
	end

--	if #foundMods == 0 then
--		NZWPrint():C10("[NZW]"):C11(" No spell mods found, skipping"):Print()
--		return
--	end

	local additions = {}

	local function add(uuid, spell)
		additions[uuid] = additions[uuid] or {}
		additions[uuid][spell] = true
	end

	for srcIdx, src in ipairs(WITCH_LISTS) do
		for _, entry in ipairs(src.entries) do
			local spell = ResolveSpell(entry)
			if spell and Ext.Stats.Get(spell, nil, false) ~= nil then
				if src.level == 0 then
					add(src.uuid, spell)
				else
					for trgtIdx = srcIdx, #WITCH_LISTS do
						add(WITCH_LISTS[trgtIdx].uuid, spell)
					end
				end
			end
		end
	end

	for uuid, spellSet in pairs(additions) do
		local list = Ext.StaticData.Get(uuid, "SpellList")
		if list then
			local spells = {}
			local seen   = {}
			for _, spell in pairs(list.Spells) do
				spells[#spells + 1] = spell
				seen[spell]         = true
			end
			local added = false
			for spell in pairs(spellSet) do
				if not seen[spell] then
					spells[#spells + 1] = spell
					added               = true
				end
			end
			if added then list.Spells = SortSpellList(spells) end
		end
	end

--  local p = NZWPrint():C10("[NZW]"):C11(" ")
--	for i, name in ipairs(foundMods) do
--		p:C2(name)
--		if i < #foundMods - 1 then
--			p:C11(", ")
--		elseif i < #foundMods then
--			p:C11(" and ")
--		end
--	end
	p:C11(" found, merging Spell Lists"):Print()
end

Events.StatsLoaded.Subscribe(MergeLists)