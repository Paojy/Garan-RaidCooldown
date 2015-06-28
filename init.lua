local name = "Garan-RaidCooldown"
RDCD = LibStub("AceAddon-3.0"):NewAddon(name)

if not RDCD then return end

if not RDCD.events then
	RDCD.events = LibStub("CallbackHandler-1.0"):New(RDCD)
end

local frame = RDCD.frame
if (not frame) then
	frame = CreateFrame("Frame", name .. "_Frame", UIParent)
	RDCD.frame = frame
end

RDCD.frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -190)
RDCD.frame:SetSize(130, 8)
RDCD.frame:SetFrameStrata("MEDIUM")
RDCD.frame:SetFrameLevel(1)


--[[
	GetSpecializationInfoForClassID(classID, specNum)
	
	1战士 狂暴72 武器71 防御73
	2骑士 惩戒70 神圣65 防护66
	3猎人 射击254 野兽253 生存255
	4盗贼 刺杀259 战斗260 敏锐261
	5牧师 戒律256 暗影258 神圣257
	6死骑 鲜血250 冰霜251 邪恶252
	7萨满 元素262 增强263 恢复264
	8法师 奥术62 火焰63 冰霜64
]]--
------------------------------------------------------
------------------[[  Cooldowns  ]]-------------------
------------------------------------------------------
RDCD.L = {}

RDCD.cooldowns = {
-- Paladin
	[31821] = { -- Devotion Aura 虔诚光环
		index = 101,
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		cast = 6,
		class = "PALADIN",
		spec = 65,
	},
	[6940] = { -- Hand of Sacrifice 牺牲之手
		index = 201,
		name = "HOS",
		succ = "SPELL_CAST_SUCCESS",
		CD = 120,
		cast = 12,
		class = "PALADIN",
	},
	[1022] = { -- 保护之手
		index = 202,
		name = "HOP",
		succ = "SPELL_CAST_SUCCESS",
		CD = 300,
		cast = 10,
		class = "PALADIN",
	},
-- Priest
	[62618] = { -- Power Word: Barrier 真言术：障
		index = 102,
		name = "PWB",
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		cast = 10,
		class = "PRIEST",
		spec = 256,
	},
	[33206] = { -- Pain Suppression 痛苦压制
		index = 203,
		name = "PS",
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		cast = 8,
		class = "PRIEST", 
		spec = 256,
	},
	[64843] = { -- Divine Hymn 神圣赞美诗
		index = 103,
		name = "DH",
		succ = "SPELL_CAST_SUCCESS",
		CD = 180, 
		cast = 8,
		class = "PRIEST",
		spec = 257,
	},	
	[47788] = { -- Guardian Spirit 守护之魂
		index = 204,
		succ = "SPELL_CAST_SUCCESS",
		name = "GS",
		CD = 180,
		cast = 10,
		class = "PRIEST", 
		spec = 257,
	},	
-- Druid
	[740] = { -- Tranquility 宁静
		index = 104,
		succ = "SPELL_CAST_SUCCESS",
		name = "T",
		CD = 480,
		cast = 8,
		class = "DRUID",
	},
	[102342] = { -- Ironbark 铁木树皮
		index = 205,
		succ = "SPELL_CAST_SUCCESS",
		name = "FE",
		CD = 120,
		cast = 8,
		class = "DRUID",
		spec = 105,
	},
	[20484] = { -- Rebirth 复生
		index = 401,
		succ = "SPELL_RESURRECT",
		name = "R",
		CD = 600,
		class = "DRUID",
	},
-- Shaman
	[98008] = { -- Spirit Link Totem 灵魂链接图腾
		index = 104,
		succ = "SPELL_CAST_SUCCESS",
		name = "SLT",
		CD = 180,
		cast = 6,
		class = "SHAMAN", 
		spec = 264,
	},
	[108280] = { -- Healing Tide Totem 治疗之潮图腾
		index = 105,
		succ = "SPELL_CAST_SUCCESS",
		name = "HTT",
		CD = 180,
		class = "SHAMAN",
		--talent = 5,
	},
 -- Monk
	[116849] = {	-- Life Cocoon 作茧缚命
		index = 206,
		succ = "SPELL_CAST_SUCCESS",
		name = "LIFE",
		CD = 120,
		cast = 12,
		class = "MONK",
		spec = 270,
	},
	[115310] = {	-- Revival 还魂术
		index = 107,
		succ = "SPELL_CAST_SUCCESS",
		name = "REV",
		CD = 180,
		class = "MONK",
		spec = 270,
	},
	--[115072] = {	-- 移花接木
		--index = 109,
		--succ = "SPELL_HEAL",
		--name = "YIHUA",
		--CD = 15,
		--class = "MONK",
	--},
-- Warlock
	[95750] = { -- Soulstone Resurrection 灵魂石复活
		index = 302,
		succ = "SPELL_RESURRECT",
		name = "SR",
		CD = 600,
		class = "WARLOCK",
	},
-- Death Knight
	[61999] = { -- Raise Ally 亡者大军
		index = 502,
		succ = "SPELL_RESURRECT", 
		name = "RA",
		CD = 600,
		class = "DEATHKNIGHT",
	},
	[51052] = { -- Anti-Magic Zone 反魔法领域
		index = 110,
		succ = "SPELL_CAST_SUCCESS",
		name = "AMZ",
		CD = 120,
		cast = 10,
		class = "DEATHKNIGHT",
		talent = 2,
	},
-- Warrior
	[97462] = { -- Rallying Cry 集结呐喊
		index = 111,
		succ = "SPELL_CAST_SUCCESS",
		name = "RC",
		CD = 180,
		cast = 10,
		class = "WARRIOR",
	},
--Rogue
	[76577] = { -- Smoke Bomb 烟雾弹
		index = 113,
		succ = "SPELL_CAST_SUCCESS",
		name = "SBO",
		CD = 180,
		cast = 5,
		class = "ROGUE",
	},
}
--------------------------------------------------------

RDCD.cooldownReduction = {
	[740] = { -- Tranquility 宁静
				spellID = 740,
				CD = 180,
				spec = 105,
			},
	[6940] = { -- Hand of Sacrifice 牺牲之手 惩戒骑一分半
				spellID = 740,
				CD = 90,
				spec = 70,
			},
}

RDCD.CDSpells = {}

for k, v in pairs(RDCD.cooldowns) do
	RDCD.CDSpells[GetSpellInfo(k)] = k
end
------------------------------------------------------
--------------[[  Default Options  ]]-----------------
------------------------------------------------------
local default_Settings = {
	height = 18,
	width = 150,
	maxgroup = 5,
	maxline = 40,
	clickable = true,
	locked = false,
	onlyactive = false,
	boardcast = {
		use = true,
		ready = false,
		},
	spells = {
		-- 123 = true,
		-- 234 = false,
		-- 220 = true,
	},
	editbox = {},
	savedgrouping = {},
}

for spellID, cooldown in pairs(RDCD.cooldowns) do
	default_Settings.spells[spellID] = true
end

function RDCD.ResetVariables()
	RDCDDB = {}
end

function RDCD.LoadVariables()
	for a, b in pairs(default_Settings) do
		if type(b) ~= "table" then
			if RDCDDB[a] == nil then
				RDCDDB[a] = b
			end
		else
			if RDCDDB[a] == nil then
				RDCDDB[a] = {}
			end
			for k, v in pairs(b) do
				if RDCDDB[a][k] == nil then
					RDCDDB[a][k] = v
				end
			end
		end
	end
end