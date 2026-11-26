-- MYSTIC STORE | Cosmetics & Visuals Panel V3 (Sincronizar RGB Nick + Tag)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer

local AUTO_EXEC_URL = "https://raw.githubusercontent.com/wmrlq26-lab/Mh-kkj/refs/heads/main/mystic_store.lua"
local CONFIG_FILE = "mystic_store_config.txt"

local factory = RS:WaitForChild("StumbleOriginal056Factory", 15)

local function safeRequireModule(parent, name)
	if not parent then return nil end
	local m = parent:FindFirstChild(name) or parent:WaitForChild(name, 8)
	if m and m:IsA("ModuleScript") then
		local ok, res = pcall(require, m)
		if ok then return res end
	end
	return nil
end

local catalog = safeRequireModule(factory, "CharacterCatalog")
local appearance = safeRequireModule(factory, "CharacterAppearance")
if type(catalog) ~= "table" then catalog = { skins = {}, colors = {} } end
if type(appearance) ~= "table" then appearance = { Build = function() end } end

local function safeRequire(parent, name)
	local m = parent and parent:FindFirstChild(name)
	if m and m:IsA("ModuleScript") then
		local ok, res = pcall(require, m)
		if ok then return res end
	end
	return nil
end

local punchCatalog = safeRequire(RS, "PunchCatalog")
local punchSkinFx  = safeRequire(RS, "PunchSkinFx")
local trailCatalog = safeRequire(RS, "TrailCatalog")

local function buildListFromItems(catTbl, fallback)
	if type(catTbl) ~= "table" or type(catTbl.Items) ~= "table" then return fallback end
	local out = {}
	for _, item in ipairs(catTbl.Items) do
		if type(item) == "table" and item.id then
			out[#out + 1] = {
				id   = tostring(item.id),
				name = tostring(item.name or item.id),
				fx   = item.fx and tostring(item.fx) or tostring(item.id),
			}
		end
	end
	return (#out > 0) and out or fallback
end

local SKIN_THUMBS = {
	BonecoNoob = "rbxassetid://118862627495693", Noob = "rbxassetid://118862627495693",
	BonecoNoobListrado = "rbxassetid://123665214738883", NoobListrado = "rbxassetid://123665214738883",
	BonecoNoobMacacao = "rbxassetid://81011195574652", NoobMacacao = "rbxassetid://81011195574652",
	BonecoNoobMoleton = "rbxassetid://74327146599508", BonecoNoobMoletom = "rbxassetid://74327146599508",
	NoobMoleton = "rbxassetid://74327146599508", NoobMoletom = "rbxassetid://74327146599508",
	BonecoLencoBranco = "rbxassetid://73534313721213", LencoBranco = "rbxassetid://73534313721213",
	BonecoLencoPreto = "rbxassetid://99316488557407", LencoPreto = "rbxassetid://99316488557407",
	BonecoLencoFina = "rbxassetid://128097782503860", LencoFina = "rbxassetid://128097782503860", Fina = "rbxassetid://128097782503860",
	BonecoRegata = "rbxassetid://99523890013382", Regata = "rbxassetid://99523890013382",
	BonecoCj = "rbxassetid://99523890013382", Cj = "rbxassetid://99523890013382",
	BonecoTubaraoSelvagem = "rbxassetid://82680508471835", BonecoTubarao = "rbxassetid://72759977600957", Tubarao = "rbxassetid://72759977600957",
	BonecoSurfistaMulher = "rbxassetid://82027486949934", SurfistaGarota = "rbxassetid://82027486949934",
	BonecoSurfista = "rbxassetid://126552756172125", Surfista = "rbxassetid://126552756172125",
	BonecoMergulhador = "rbxassetid://111462560382365", Mergulhador = "rbxassetid://111462560382365",
	BonecoGuardaVidas = "rbxassetid://124221411864523", GuardaVidas = "rbxassetid://124221411864523",
	BonecoNadador = "rbxassetid://74448258557733", Nadador = "rbxassetid://74448258557733",
	BonecoNinja = "rbxassetid://89432289655302", Ninja = "rbxassetid://89432289655302",
	BonecoNinjaRelampago = "rbxassetid://129238776540496", NinjaRelampago = "rbxassetid://129238776540496",
	BonecoNinjaSombras = "rbxassetid://131093549072285", NinjaSombras = "rbxassetid://131093549072285",
	BonecoSamurai = "rbxassetid://78123448519700", Samurai = "rbxassetid://78123448519700",
	BonecoPiloto = "rbxassetid://93324803701908", Piloto = "rbxassetid://93324803701908",
	BonecoPalhaco = "rbxassetid://88085886598135", Palhaco = "rbxassetid://88085886598135",
	BonecoHomemCorvo = "rbxassetid://109925176493321", HomemCorvo = "rbxassetid://109925176493321",
	BonecoCraque = "rbxassetid://114408052876048", BonecoCraque10 = "rbxassetid://114408052876048", Craque10 = "rbxassetid://114408052876048",
	BonecoTungTungSahur = "rbxassetid://116340072271737", TungTungSahur = "rbxassetid://116340072271737",
	BonecoGhostyface = "rbxassetid://92816297410366", Ghostyface = "rbxassetid://92816297410366",
	BonecoMascarado = "rbxassetid://93456843850862", Mascarado = "rbxassetid://93456843850862",
	BonecoBoxeador = "rbxassetid://100918705396649", Boxeador = "rbxassetid://100918705396649",
	BonecoMumia = "rbxassetid://76159099371538", Mumia = "rbxassetid://76159099371538",
}

local function normalizeText(str)
	local s = string.lower(tostring(str or ""))
	s = s:gsub("[áàâãä]", "a"):gsub("[éèêë]", "e"):gsub("[íìîï]", "i")
	     :gsub("[óòôõö]", "o"):gsub("[úùûü]", "u"):gsub("[ç]", "c")
	     :gsub("[%s_%-]+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	return s
end

local function isForbiddenRedLenco(item)
	if not item then return false end
	local txt = normalizeText(item.name) .. " " .. normalizeText(item.id)
	local compact = txt:gsub("%s+", "")
	if string.find(txt, "lenco vermelho", 1, true)
		or string.find(txt, "lenco vermelha", 1, true)
		or string.find(compact, "lencovermelho", 1, true)
		or string.find(compact, "lencovermelha", 1, true)
		or (string.find(txt, "lenco", 1, true) and string.find(txt, "vermelh", 1, true))
	then
		return true
	end
	return false
end

local SKIN_THUMBS_COMPACT = {}
for k, v in pairs(SKIN_THUMBS) do
	local ck = normalizeText(k):gsub("%s+", "")
	if ck ~= "" and not SKIN_THUMBS_COMPACT[ck] then SKIN_THUMBS_COMPACT[ck] = v end
end

local function findSkinThumbRaw(item)
	if not item then return "" end
	local id, name = tostring(item.id or ""), tostring(item.name or "")
	local combined = normalizeText(name) .. " " .. normalizeText(id)
	if string.find(combined, "molet", 1, true) or string.find(combined, "hood", 1, true) then
		return "rbxassetid://74327146599508"
	end
	if SKIN_THUMBS[id] then return SKIN_THUMBS[id] end
	if SKIN_THUMBS[name] then return SKIN_THUMBS[name] end
	local cId = normalizeText(id):gsub("%s+", "")
	if cId ~= "" and SKIN_THUMBS_COMPACT[cId] then return SKIN_THUMBS_COMPACT[cId] end
	local cNm = normalizeText(name):gsub("%s+", "")
	if cNm ~= "" and SKIN_THUMBS_COMPACT[cNm] then return SKIN_THUMBS_COMPACT[cNm] end
	return ""
end

local THUMB_CACHE = {}
local function resolveThumbAsset(rawId)
	if type(rawId) ~= "string" or rawId == "" then return "" end
	if THUMB_CACHE[rawId] then return THUMB_CACHE[rawId] end
	local n = rawId:match("(%d+)$")
	local r = n and ("rbxassetid://" .. n) or rawId
	THUMB_CACHE[rawId] = r
	return r
end

local RARITIES = {
	"COMUM", "RARO", "EPICO", "LENDARIO", "MITICO",
	"13TH FRIDAY", "BETA", "SUMMER 1", "SUMMER 2",
}

local RARITY_MATCHERS = {
	COMUM = { "noob", "noob listrado", "noob macacao", "noob moleton", "noob moletom", "moleton", "moletom", "hoodie" },
	RARO = { "ninja relampago", "ninja vermelho", "samurai", "boneconinjarelampago", "boneconinjavermelho", "boneconinjasombras", "bonecosamurai" },
	EPICO = { "piloto", "boxeador", "palhaco", "lenco preto", "lenco branco", "lenco fina", "fina", "bonecopiloto", "bonecoboxeador", "bonecopalhaco", "bonecolencopreto", "bonecolencobranco", "bonecolencofina" },
	LENDARIO = { "homem corvo", "bonecohomemcorvo" },
	MITICO = { "craque 10", "craque", "bonecocraque" },
	["13TH FRIDAY"] = { "ghostyface", "mascarado", "mumia", "bonecoghostyface", "bonecomascarado", "bonecomumia" },
	BETA = { "tung tung sahur", "tung tung", "regata", "ninja", "tungtungsahur" },
	["SUMMER 1"] = { "tubarao", "mergulhador", "guarda-vidas", "guarda vidas", "bonecotubaraoselvagem", "bonecomergulhador", "bonecoguardavidas" },
	["SUMMER 2"] = { "surfista", "surfista garota", "nadador", "bonecosurfista", "bonecosurfistamulher", "boneconadador" },
}

local OTHER_LENCOS = {
	{ id = "BonecoLencoBranco", name = "LENCO BRANCA", keys = { "lenco branco", "bonecolencobranco" } },
	{ id = "BonecoLencoPreto",  name = "LENCO PRETO",  keys = { "lenco preto",  "bonecolencopreto"  } },
	{ id = "BonecoLencoFina",   name = "LENCO FINA",   keys = { "lenco fina",   "bonecolencofina", "fina" } },
}

local function matchOtherLenco(item)
	if not item or isForbiddenRedLenco(item) then return nil end
	local c = normalizeText(item.name) .. " " .. normalizeText(item.id)
	for idx, def in ipairs(OTHER_LENCOS) do
		for _, k in ipairs(def.keys) do
			if string.find(c, k, 1, true) then return idx end
		end
	end
	return nil
end

local function getRarityForSkin(item)
	if not item or isForbiddenRedLenco(item) then return nil end
	if matchOtherLenco(item) then return "EPICO" end
	local combined = normalizeText(item.name) .. " " .. normalizeText(item.id)
	if string.find(combined, "molet", 1, true) or string.find(combined, "hood", 1, true) then return "COMUM" end
	if string.find(combined, "ninja", 1, true) and string.find(combined, "vermelho", 1, true) then return "RARO" end
	for rarityName, keys in pairs(RARITY_MATCHERS) do
		for _, k in ipairs(keys) do
			if string.find(combined, k, 1, true) then return rarityName end
		end
	end
	return "EPICO"
end

local TRAIL_THUMBS = {
	Fumaca       = "",
	Agua         = "rbxassetid://94743147904396",
	AreiaDourada = "rbxassetid://125909782299675",
}
local PUNCH_THUMBS = {
	Padrao = "rbxassetid://117364043582315",
	Agua   = "rbxassetid://104106399301450",
}

local COLOR_MAP_BY_NAME = {
	laranja = Color3.fromRGB(249, 115, 22), verde = Color3.fromRGB(34, 197, 94),
	preto = Color3.fromRGB(24, 24, 27), azul = Color3.fromRGB(59, 130, 246),
	rosa = Color3.fromRGB(236, 72, 153), vermelho = Color3.fromRGB(239, 68, 68),
	roxo = Color3.fromRGB(168, 85, 247), branco = Color3.fromRGB(244, 244, 245),
	amarelo = Color3.fromRGB(250, 204, 21), marrom = Color3.fromRGB(122, 62, 24),
	escuro = Color3.fromRGB(122, 62, 24), claro = Color3.fromRGB(210, 174, 128),
	bege = Color3.fromRGB(210, 174, 128), padrao = Color3.fromRGB(178, 114, 68),
}

local function formatColorDisplayName(item)
	if not item then return "" end
	local raw = tostring(item.name or item.id or "")
	return (normalizeText(raw) == "escuro") and "Marrom" or raw
end

local function resolveColorValue(item)
	if not item then return Color3.fromRGB(178, 114, 68) end
	if typeof(item.value) == "Color3" then return item.value end
	local rawName = normalizeText(item.name or item.id)
	for key, col in pairs(COLOR_MAP_BY_NAME) do
		if string.find(rawName, key, 1, true) then return col end
	end
	return Color3.fromRGB(178, 114, 68)
end

local function deduplicateById(list)
	local out, seen = {}, {}
	for _, item in ipairs(list or {}) do
		local id = tostring(item.id or "")
		if id ~= "" and not seen[id] and not isForbiddenRedLenco(item) then
			seen[id] = true
			out[#out + 1] = item
		end
	end
	return out
end

local function buildSkinsByRarityOrder(rawSkins)
	local deduped = deduplicateById(rawSkins or { { id = "BonecoNoob", name = "NOOB" } })
	local buckets = {}
	for _, rName in ipairs(RARITIES) do buckets[rName] = {} end

	local foundOtherLencos = {}
	for _, item in ipairs(deduped) do
		local lIdx = matchOtherLenco(item)
		if lIdx then
			if not foundOtherLencos[lIdx] then
				foundOtherLencos[lIdx] = { id = tostring(item.id), name = OTHER_LENCOS[lIdx].name }
			end
		else
			local rName = getRarityForSkin(item) or "EPICO"
			if not buckets[rName] then buckets[rName] = {} end
			table.insert(buckets[rName], item)
		end
	end

	if not buckets.EPICO then buckets.EPICO = {} end
	table.insert(buckets.EPICO, foundOtherLencos[1] or { id = "BonecoLencoBranco", name = "LENCO BRANCA" })
	table.insert(buckets.EPICO, foundOtherLencos[2] or { id = "BonecoLencoPreto",  name = "LENCO PRETO"  })
	table.insert(buckets.EPICO, foundOtherLencos[3] or { id = "BonecoLencoFina",   name = "LENCO FINA"   })

	local orderedOut, seenIds, seenNormNames = {}, {}, {}
	local function tryPush(item)
		if not item or not item.id or isForbiddenRedLenco(item) then return end
		local normN = normalizeText(item.name or item.id)
		if not seenIds[item.id] and (normN == "" or not seenNormNames[normN]) then
			seenIds[item.id] = true
			if normN ~= "" then seenNormNames[normN] = true end
			table.insert(orderedOut, item)
		end
	end

	for _, rName in ipairs(RARITIES) do
		for _, item in ipairs(buckets[rName] or {}) do tryPush(item) end
	end
	for rName, list in pairs(buckets) do
		local inStd = false
		for _, stdR in ipairs(RARITIES) do if stdR == rName then inStd = true break end end
		if not inStd then
			for _, item in ipairs(list) do tryPush(item) end
		end
	end
	return orderedOut
end

local skinList  = buildSkinsByRarityOrder(catalog.skins)
local colorList = deduplicateById(catalog.colors or { { id = "COLOR12", name = "Amarelo", value = Color3.fromRGB(250, 204, 21) } })
local trailList = deduplicateById(buildListFromItems(trailCatalog, {
	{ id = "Fumaca", name = "FUMACA", fx = "Fumaca" },
	{ id = "Agua", name = "PEGADAS D'AGUA", fx = "Agua" },
	{ id = "AreiaDourada", name = "AREIA DOURADA", fx = "AreiaDourada" },
}))
local punchList = deduplicateById(buildListFromItems(punchCatalog, {
	{ id = "Padrao", name = "SOCO PADRAO", fx = "Padrao" },
	{ id = "Agua", name = "SOCO D'AGUA", fx = "Agua" },
}))

local rgbSkinPool = {}
do
	local seen = {}
	for _, item in ipairs(skinList) do
		if item and item.id and not seen[item.id] and not isForbiddenRedLenco(item) then
			seen[item.id] = true
			rgbSkinPool[#rgbSkinPool + 1] = item
		end
	end
end

local PALETTE = {
	Color3.fromRGB(244, 244, 245), Color3.fromRGB(239, 68, 68),
	Color3.fromRGB(249, 115, 22), Color3.fromRGB(250, 204, 21),
	Color3.fromRGB(34, 197, 94),  Color3.fromRGB(59, 130, 246),
	Color3.fromRGB(168, 85, 247), Color3.fromRGB(236, 72, 153),
}

local state = {
	skinId = skinList[1] and skinList[1].id or "BonecoNoob",
	colorId = colorList[1] and colorList[1].id or "COLOR12",
	trailId = trailList[1] and trailList[1].id or "Fumaca",
	punchId = punchList[1] and punchList[1].id or "Padrao",
	rarityIdx = 1, tab = "skin", hideNames = false, autoExec = false, skinsRgb = false, minimized = false,
	fpsCounterOn = false,
	posX = 4, posYScale = 0, posYOffset = 100,
	customNickOn = false, customNickText = "", nickRgbOn = false, nickColorOn = false,
	nickColor = Color3.fromRGB(239, 68, 68),
	tagText = "", tagRgbOn = false, tagColorOn = false,
	tagColor = Color3.fromRGB(250, 204, 21),
	syncRgbOn = false,
	playerEspOn = false, espNameOn = false,
}

local originalTexts = setmetatable({}, { __mode = "k" })
local nickHue, tagHue = 0, 0.42

local function colorToStr(col)
	local c = col or Color3.fromRGB(255, 255, 255)
	return string.format("%.3f,%.3f,%.3f", c.R, c.G, c.B)
end

local function strToColor(str, fallback)
	if type(str) ~= "string" then return fallback end
	local r, g, b = str:match("^([%d%.]+),([%d%.]+),([%d%.]+)$")
	r, g, b = tonumber(r), tonumber(g), tonumber(b)
	if r and g and b then return Color3.new(math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1)) end
	return fallback
end

local function escapeLuaStr(val)
	local s = tostring(val or "")
	s = s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "")
	return '"' .. s .. '"'
end

local cachedSessionCfg = nil

local function saveConfigToFile()
	local cfg = {
		skinId = tostring(state.skinId ~= "" and state.skinId or "BonecoNoob"),
		colorId = tostring(state.colorId ~= "" and state.colorId or "COLOR12"),
		trailId = tostring(state.trailId ~= "" and state.trailId or "Fumaca"),
		punchId = tostring(state.punchId ~= "" and state.punchId or "Padrao"),
		hideNames = state.hideNames and true or false, autoExec = state.autoExec and true or false,
		minimized = state.minimized and true or false, fpsCounterOn = state.fpsCounterOn and true or false,
		posX = tonumber(state.posX) or 4, posYScale = tonumber(state.posYScale) or 0, posYOffset = tonumber(state.posYOffset) or 100,
		customNickOn = state.customNickOn and true or false, customNickText = tostring(state.customNickText or ""):gsub("|", "/"),
		nickRgbOn = state.nickRgbOn and true or false, nickColorOn = state.nickColorOn and true or false, nickColor = state.nickColor,
		tagText = tostring(state.tagText or ""):gsub("|", "/"),
		tagRgbOn = state.tagRgbOn and true or false, tagColorOn = state.tagColorOn and true or false, tagColor = state.tagColor,
		syncRgbOn = state.syncRgbOn and true or false,
		playerEspOn = state.playerEspOn and true or false, espNameOn = state.espNameOn and true or false,
	}
	cachedSessionCfg = cfg
	if type(writefile) == "function" then
		pcall(writefile, CONFIG_FILE, table.concat({
			cfg.skinId, cfg.colorId, cfg.trailId, cfg.punchId,
			cfg.hideNames and "1" or "0", cfg.autoExec and "1" or "0", cfg.minimized and "1" or "0",
			tostring(cfg.posX), tostring(cfg.posYScale), tostring(cfg.posYOffset),
			cfg.customNickOn and "1" or "0", cfg.customNickText,
			cfg.nickRgbOn and "1" or "0", cfg.nickColorOn and "1" or "0", colorToStr(cfg.nickColor),
			cfg.tagText, cfg.tagRgbOn and "1" or "0", cfg.tagColorOn and "1" or "0", colorToStr(cfg.tagColor),
			cfg.playerEspOn and "1" or "0", cfg.espNameOn and "1" or "0", cfg.fpsCounterOn and "1" or "0",
			cfg.syncRgbOn and "1" or "0",
		}, "|"))
	end
	return cfg
end

local function loadSavedConfig()
	if type(isfile) == "function" and type(readfile) == "function" then
		local okE, exists = pcall(isfile, CONFIG_FILE)
		if okE and exists then
			local okR, raw = pcall(readfile, CONFIG_FILE)
			if okR and type(raw) == "string" and raw ~= "" then
				local p = raw:split("|")
				if #p >= 4 and p[1] ~= "" and p[2] ~= "" and p[3] ~= "" and p[4] ~= "" then
					return {
						skinId = p[1], colorId = p[2], trailId = p[3], punchId = p[4],
						hideNames = (p[5] == "1"), autoExec = (p[6] == "1"), minimized = (p[7] == "1"),
						posX = tonumber(p[8]) or 4, posYScale = tonumber(p[9]) or 0, posYOffset = tonumber(p[10]) or 100,
						customNickOn = (p[11] == "1"), customNickText = tostring(p[12] or ""),
						nickRgbOn = (p[13] == "1"), nickColorOn = (p[14] == "1"),
						nickColor = strToColor(p[15], Color3.fromRGB(239, 68, 68)),
						tagText = tostring(p[16] or ""), tagRgbOn = (p[17] == "1"), tagColorOn = (p[18] == "1"),
						tagColor = strToColor(p[19], Color3.fromRGB(250, 204, 21)),
						playerEspOn = (p[20] == "1"), espNameOn = (p[21] == "1"), fpsCounterOn = (p[22] == "1"),
						syncRgbOn = (p[23] == "1"),
					}
				end
			end
		end
	end
	return cachedSessionCfg
end

local function getQueueTeleportFn()
	local envTables = { _G }
	if type(getgenv) == "function" then local ok, g = pcall(getgenv); if ok and type(g) == "table" then table.insert(envTables, g) end end
	for _, name in ipairs({ "queue_on_teleport", "queueteleport", "queueonteleport" }) do
		if type(_G[name]) == "function" then return _G[name] end
		for _, tbl in ipairs(envTables) do if type(tbl[name]) == "function" then return tbl[name] end end
	end
	return nil
end

local lastQueuedSignature = nil
local function queueTeleportActions(force)
	local qFn = getQueueTeleportFn()
	if type(qFn) ~= "function" then return false end
	local savedCfg = loadSavedConfig()
	local sig = tostring(state.autoExec) .. "::" .. tostring(savedCfg and savedCfg.skinId or "")
	if not force and sig == lastQueuedSignature then return true end
	if state.autoExec then
		pcall(qFn, "if not game:IsLoaded() then game.Loaded:Wait() end task.wait(2.2) pcall(function() loadstring(game:HttpGet(" .. escapeLuaStr(AUTO_EXEC_URL) .. ", true))() end)")
	end
	if type(savedCfg) == "table" then
		pcall(qFn, "if not game:IsLoaded() then game.Loaded:Wait() end local lp=game:GetService('Players').LocalPlayer task.wait(1.1) pcall(function() lp:SetAttribute('SGCharacterVisual'," .. escapeLuaStr(savedCfg.skinId) .. ") lp:SetAttribute('SGCharacterColor'," .. escapeLuaStr(savedCfg.colorId) .. ") lp:SetAttribute('SGTrail'," .. escapeLuaStr(savedCfg.trailId) .. ") lp:SetAttribute('SGPunch'," .. escapeLuaStr(savedCfg.punchId) .. ") lp:SetAttribute('SGHideAllNames'," .. (savedCfg.hideNames and "true" or "false") .. ") end)")
	end
	lastQueuedSignature = sig
	return true
end

lp.OnTeleport:Connect(function()
	if state.autoExec or type(loadSavedConfig()) == "table" then queueTeleportActions(true) end
end)

local function findItemById(list, id)
	for _, item in ipairs(list) do if item.id == id then return item end end
	return list[1]
end

local isApplyingCosmetics = false
local function applyCosmetics(charOverride)
	if isApplyingCosmetics then return end
	isApplyingCosmetics = true
	pcall(function()
		local skin = findItemById(skinList, state.skinId)
		local color = findItemById(colorList, state.colorId)
		local trail = findItemById(trailList, state.trailId)
		local punch = findItemById(punchList, state.punchId)
		local skinId = (skin and not isForbiddenRedLenco(skin) and skin.id) or "BonecoNoob"
		local colorId = color and color.id or "COLOR12"
		local trailId = trail and trail.id or "Fumaca"
		local punchId = punch and punch.id or "Padrao"
		local punchFx = punch and punch.fx or punchId

		lp:SetAttribute("SGCharacterVisual", skinId)
		lp:SetAttribute("SGCharacterColor", colorId)
		lp:SetAttribute("SGTrail", trailId)
		lp:SetAttribute("SGPunch", punchId)
		lp:SetAttribute("SGPunchFx", punchFx)
		lp:SetAttribute("SGHideAllNames", state.hideNames)

		local char = charOverride or lp.Character
		if char and char.Parent then
			char:SetAttribute("CharacterVisual", skinId)
			char:SetAttribute("CharacterColor", colorId)
			char:SetAttribute("SGTrail", trailId)
			char:SetAttribute("SGPunch", punchId)
			char:SetAttribute("SGPunchFx", punchFx)
			if type(appearance.Build) == "function" then
				pcall(appearance.Build, char, { skin = skinId, color = colorId })
			end
		end
	end)
	isApplyingCosmetics = false
end

local lastRgbBuildClock = 0
local function applyRgbSkinFast(skinId, char)
	if type(skinId) ~= "string" or skinId == "" then return end
	local itemObj = findItemById(skinList, skinId)
	if isForbiddenRedLenco(itemObj) then return end
	state.skinId = skinId
	pcall(function() if lp then lp:SetAttribute("SGCharacterVisual", skinId) end end)
	if char and char.Parent then
		pcall(function() char:SetAttribute("CharacterVisual", skinId) end)
		local now = os.clock()
		if (now - lastRgbBuildClock) >= 0.9 and type(appearance.Build) == "function" then
			lastRgbBuildClock = now
			pcall(appearance.Build, char, { skin = skinId, color = state.colorId or "COLOR12" })
		end
	end
end

-- ══ NICK / TAG / ESP / ESP NAME ══
local function paintLabel(lbl, col)
	if not lbl or not lbl.Parent or not col then return end
	for _, g in ipairs(lbl:GetChildren()) do
		if g:IsA("UIGradient") then g.Enabled = false end
	end
	if lbl.TextColor3 ~= col then
		lbl.TextColor3 = col
	end
end

local function collectCharacterBillboards(char, out)
	if not char or not char.Parent then return end
	for _, c in ipairs(char:GetChildren()) do
		if c:IsA("BillboardGui") and c.Name ~= "MysticEspNameGui" then
			out[#out + 1] = c
		elseif c:IsA("BasePart") or c:IsA("Model") then
			for _, sub in ipairs(c:GetChildren()) do
				if sub:IsA("BillboardGui") and sub.Name ~= "MysticEspNameGui" then
					out[#out + 1] = sub
				elseif sub:IsA("BasePart") then
					for _, sub2 in ipairs(sub:GetChildren()) do
						if sub2:IsA("BillboardGui") and sub2.Name ~= "MysticEspNameGui" then
							out[#out + 1] = sub2
						end
					end
				end
			end
		end
	end
end

local function applyNickAndSmallTag(char, activeNickCol, activeTagCol)
	if not char or not char.Parent then return end
	local nickToSet = (state.customNickOn and state.customNickText ~= "") and state.customNickText or nil
	local restoreNick = (not state.customNickOn) or (state.customNickText == "")
	local hasTag = (state.tagText ~= "")

	local bbs = {}
	collectCharacterBillboards(char, bbs)

	for _, bb in ipairs(bbs) do
		local labels = {}
		for _, ch in ipairs(bb:GetChildren()) do
			if ch:IsA("TextLabel") and ch.Name ~= "EspNickLabel" then
				labels[#labels + 1] = ch
			elseif ch:IsA("Frame") then
				for _, fch in ipairs(ch:GetChildren()) do
					if fch:IsA("TextLabel") and fch.Name ~= "EspNickLabel" then
						labels[#labels + 1] = fch
					end
				end
			end
		end

		table.sort(labels, function(a, b)
			local areaA = a.AbsoluteSize.X * a.AbsoluteSize.Y
			local areaB = b.AbsoluteSize.X * b.AbsoluteSize.Y
			if areaA ~= areaB then return areaA > areaB end
			return a.TextSize > b.TextSize
		end)

		local mainLbl = labels[1]
		for idx, lbl in ipairs(labels) do
			local lowN = string.lower(lbl.Name)
			local isTagSlot = (mainLbl and lbl ~= mainLbl)
				and (
					idx == 2
					or string.find(lowN, "tag", 1, true)
					or string.find(lowN, "badge", 1, true)
					or string.find(lowN, "clan", 1, true)
					or string.find(lowN, "sub", 1, true)
					or (mainLbl.AbsoluteSize.X > 0 and lbl.AbsoluteSize.X > 0 and lbl.AbsoluteSize.X < mainLbl.AbsoluteSize.X * 0.72)
					or (lbl.TextSize < mainLbl.TextSize * 0.88)
				)

			if isTagSlot then
				if hasTag then
					if originalTexts[lbl] == nil then
						local ok, cur = pcall(function() return lbl.Text end)
						if ok and type(cur) == "string" then originalTexts[lbl] = cur end
					end
					if lbl.Text ~= state.tagText then lbl.Text = state.tagText end
					if activeTagCol then paintLabel(lbl, activeTagCol) end
				elseif originalTexts[lbl] ~= nil then
					lbl.Text = originalTexts[lbl]
					originalTexts[lbl] = nil
				elseif activeTagCol then
					paintLabel(lbl, activeTagCol)
				end
			else
				if restoreNick and originalTexts[lbl] ~= nil then
					lbl.Text = originalTexts[lbl]
					originalTexts[lbl] = nil
				elseif nickToSet then
					if originalTexts[lbl] == nil then
						local ok, cur = pcall(function() return lbl.Text end)
						if ok and type(cur) == "string" then originalTexts[lbl] = cur end
					end
					if lbl.Text ~= nickToSet then lbl.Text = nickToSet end
				end
				if activeNickCol then paintLabel(lbl, activeNickCol) end
			end
		end
	end
end

local function clearPlayerEsp()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			local hl = plr.Character:FindFirstChild("MysticPlayerESP")
			if hl then hl:Destroy() end
		end
	end
end

local function updatePlayerEsp()
	if not state.playerEspOn then clearPlayerEsp(); return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character and plr.Character.Parent then
			if not plr.Character:FindFirstChild("MysticPlayerESP") then
				local hl = Instance.new("Highlight")
				hl.Name = "MysticPlayerESP"
				hl.Adornee = plr.Character
				hl.FillColor = Color3.fromRGB(250, 204, 21)
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.FillTransparency = 0.45
				hl.OutlineTransparency = 0
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = plr.Character
			end
		end
	end
end

local function getInGameNick(plr, char)
	if char then
		for _, attr in ipairs({ "GameNick", "Nick", "DisplayNick", "PlayerName", "CustomName", "InGameName", "TagName" }) do
			local v = char:GetAttribute(attr)
			if type(v) == "string" and v ~= "" and string.lower(v) ~= string.lower(plr.Name) then return v end
		end
		local bbs = {}
		collectCharacterBillboards(char, bbs)
		for _, bb in ipairs(bbs) do
			for _, ch in ipairs(bb:GetChildren()) do
				if ch:IsA("TextLabel") and ch.Name ~= "EspNickLabel" and type(ch.Text) == "string" and ch.Text ~= "" then
					local clean = ch.Text:gsub("^%s+", ""):gsub("%s+$", "")
					if clean ~= "" and string.lower(clean) ~= string.lower(plr.Name) then return clean end
				end
			end
		end
	end
	if plr then
		for _, attr in ipairs({ "GameNick", "Nick", "DisplayNick", "PlayerName", "CustomName", "InGameName" }) do
			local v = plr:GetAttribute(attr)
			if type(v) == "string" and v ~= "" and string.lower(v) ~= string.lower(plr.Name) then return v end
		end
		if type(plr.DisplayName) == "string" and plr.DisplayName ~= "" then return plr.DisplayName end
		return plr.Name
	end
	return "Jogador"
end

local function clearEspNames()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			local g = plr.Character:FindFirstChild("MysticEspNameGui")
			if g then g:Destroy() end
		end
	end
end

local function updateEspNames()
	if not state.espNameOn then clearEspNames(); return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character and plr.Character.Parent then
			local char = plr.Character
			local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
			if head then
				local bb = char:FindFirstChild("MysticEspNameGui")
				if not bb then
					bb = Instance.new("BillboardGui")
					bb.Name = "MysticEspNameGui"
					bb.Adornee = head
					bb.Size = UDim2.new(0, 140, 0, 22)
					bb.StudsOffset = Vector3.new(0, 2.8, 0)
					bb.AlwaysOnTop = true
					bb.MaxDistance = 450
					bb.Parent = char

					local lbl = Instance.new("TextLabel")
					lbl.Name = "EspNickLabel"
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundTransparency = 1
					lbl.TextColor3 = Color3.fromRGB(240, 243, 255)
					lbl.TextStrokeColor3 = Color3.fromRGB(10, 12, 20)
					lbl.TextStrokeTransparency = 0.2
					lbl.Font = Enum.Font.GothamBlack
					lbl.TextSize = 11
					lbl.Parent = bb
				end
				local lbl = bb:FindFirstChild("EspNickLabel")
				if lbl and lbl:IsA("TextLabel") then
					local nickGame = getInGameNick(plr, char)
					if lbl.Text ~= nickGame then lbl.Text = nickGame end
				end
			end
		end
	end
end

-- ══ UI ══
pcall(function() local g = CG:FindFirstChild("MysticStorePanelV3"); if g then g:Destroy() end end)

local gui = Instance.new("ScreenGui")
gui.Name = "MysticStorePanelV3"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() gui.Parent = CG end) then
	pcall(function() gui.Parent = lp:WaitForChild("PlayerGui") end)
end

local fpsBadge = Instance.new("Frame")
fpsBadge.Name = "FpsBadge"
fpsBadge.AnchorPoint = Vector2.new(1, 1)
fpsBadge.Size = UDim2.new(0, 68, 0, 22)
fpsBadge.Position = UDim2.new(1, -10, 1, -10)
fpsBadge.BackgroundColor3 = Color3.fromRGB(12, 20, 16)
fpsBadge.BackgroundTransparency = 0.15
fpsBadge.BorderSizePixel = 0
fpsBadge.Visible = false
fpsBadge.Parent = gui

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 6)
fpsCorner.Parent = fpsBadge

local fpsStroke = Instance.new("UIStroke")
fpsStroke.Color = Color3.fromRGB(34, 197, 94)
fpsStroke.Thickness = 1
fpsStroke.Parent = fpsBadge

local fpsLbl = Instance.new("TextLabel")
fpsLbl.Size = UDim2.new(1, 0, 1, 0)
fpsLbl.BackgroundTransparency = 1
fpsLbl.Text = "FPS: --"
fpsLbl.TextColor3 = Color3.fromRGB(34, 197, 94)
fpsLbl.Font = Enum.Font.GothamBlack
fpsLbl.TextSize = 9
fpsLbl.TextXAlignment = Enum.TextXAlignment.Center
fpsLbl.Parent = fpsBadge

local fpsFrames, fpsAccum = 0, 0
RunService.RenderStepped:Connect(function(dt)
	if state.fpsCounterOn then
		fpsFrames += 1
		fpsAccum += dt
		if fpsAccum >= 0.45 then
			local realFps = math.floor(fpsFrames / fpsAccum + 0.5)
			fpsFrames = 0
			fpsAccum = 0
			if fpsLbl and fpsLbl.Parent then
				fpsLbl.Text = "FPS: " .. tostring(realFps)
			end
		end
	end

	local char = lp and lp.Character
	local needVisual = state.nickRgbOn or state.nickColorOn or state.customNickOn or state.tagRgbOn or state.tagColorOn or (state.tagText ~= "")
	if needVisual and char and char.Parent then
		if state.nickRgbOn then nickHue = (nickHue + dt * 0.9) % 1 end
		if state.syncRgbOn and state.nickRgbOn then
			tagHue = nickHue
		elseif state.tagRgbOn then
			tagHue = (tagHue + dt * 1.1) % 1
		end
		local activeNickCol = state.nickRgbOn and Color3.fromHSV(nickHue, 0.95, 1) or (state.nickColorOn and state.nickColor or nil)
		local activeTagCol = state.tagRgbOn and Color3.fromHSV(tagHue, 1, 1) or (state.tagColorOn and state.tagColor or nil)
		applyNickAndSmallTag(char, activeNickCol, activeTagCol)
	end
end)

task.spawn(function()
	while true do
		task.wait(0.75)
		if state.playerEspOn then updatePlayerEsp() end
		if state.espNameOn then updateEspNames() end
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if plr and plr.Character then
		local hl = plr.Character:FindFirstChild("MysticPlayerESP"); if hl then hl:Destroy() end
		local g = plr.Character:FindFirstChild("MysticEspNameGui"); if g then g:Destroy() end
	end
end)

local T = {
	bg = Color3.fromRGB(13, 14, 22), header = Color3.fromRGB(20, 22, 35),
	card = Color3.fromRGB(26, 29, 46), cardSel = Color3.fromRGB(38, 44, 72),
	btn = Color3.fromRGB(38, 44, 68), accent = Color3.fromRGB(99, 102, 241),
	accentD = Color3.fromRGB(55, 58, 160), text = Color3.fromRGB(240, 243, 255),
	muted = Color3.fromRGB(140, 148, 180), danger = Color3.fromRGB(180, 40, 55),
	tabBg = Color3.fromRGB(18, 20, 32), tabSel = Color3.fromRGB(99, 102, 241),
	preview = Color3.fromRGB(18, 20, 34), imgBg = Color3.fromRGB(20, 23, 40),
}

local function corner(inst, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = inst end
local function stroke(inst, color, thickness) local s = Instance.new("UIStroke"); s.Color = color or T.accent; s.Thickness = thickness or 1.5; s.Parent = inst end

local PANEL_W, PANEL_H = 304, 286
local main = Instance.new("Frame")
main.Name = "Main"; main.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
main.Position = UDim2.new(0, state.posX, state.posYScale, state.posYOffset)
main.BackgroundColor3 = T.bg; main.BorderSizePixel = 0; main.Active = true; main.Parent = gui
corner(main, 11); stroke(main, Color3.fromRGB(50, 55, 90), 1)

local header = Instance.new("Frame")
header.Name = "Header"; header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = T.header; header.BorderSizePixel = 0; header.Parent = main; corner(header, 11)

local abar = Instance.new("Frame")
abar.Size = UDim2.new(0, 4, 0, 16); abar.Position = UDim2.new(0, 9, 0.5, -8)
abar.BackgroundColor3 = T.accent; abar.BorderSizePixel = 0; abar.Parent = header; corner(abar, 2)

local function textLabel(parent, size, pos, text, font, textSize, color, xAlign)
	local l = Instance.new("TextLabel")
	l.Size = size; l.Position = pos; l.BackgroundTransparency = 1; l.Text = text
	l.Font = font or Enum.Font.GothamBold; l.TextSize = textSize or 11; l.TextColor3 = color or T.text
	l.TextXAlignment = xAlign or Enum.TextXAlignment.Left; l.Parent = parent
	return l
end

textLabel(header, UDim2.new(0, 150, 1, 0), UDim2.new(0, 17, 0, 0), "MYSTIC STORE", Enum.Font.GothamBlack, 11, T.text)

local function headerBtn(xOff, txt, bg)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 22, 0, 22); b.Position = UDim2.new(1, xOff, 0.5, -11)
	b.BackgroundColor3 = bg or T.btn; b.BorderSizePixel = 0; b.Text = txt; b.TextColor3 = T.text
	b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.Parent = header; corner(b, 6)
	return b
end

local minBtn = headerBtn(-52, "-")
local closeBtn = headerBtn(-26, "X", T.danger)

local body = Instance.new("Frame")
body.Name = "Body"; body.Size = UDim2.new(1, -10, 1, -36); body.Position = UDim2.new(0, 5, 0, 33)
body.BackgroundTransparency = 1; body.Parent = main

local function safeSetProp(inst, propName, value)
	pcall(function() if inst then inst[propName] = value end end)
end

local updatePreview

local function applyMinimizeState(minimized, persist)
	state.minimized = minimized and true or false
	safeSetProp(body, "Visible", not state.minimized)
	safeSetProp(main, "Size", state.minimized and UDim2.new(0, PANEL_W, 0, 30) or UDim2.new(0, PANEL_W, 0, PANEL_H))
	safeSetProp(minBtn, "Text", state.minimized and "+" or "-")
	if persist then saveConfigToFile() end
	if not state.minimized and type(updatePreview) == "function" then updatePreview() end
end

local dragging, dragInput = false, nil
local dragStartPos, startMainPos = Vector2.zero, main.Position

local function clampMainPosition(targetPos)
	local vpSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	local curH = state.minimized and 30 or PANEL_H
	local absX = math.clamp(targetPos.X.Scale * vpSize.X + targetPos.X.Offset, 0, math.max(0, vpSize.X - PANEL_W))
	local absY = math.clamp(targetPos.Y.Scale * vpSize.Y + targetPos.Y.Offset, 0, math.max(0, vpSize.Y - curH))
	return UDim2.new(0, math.floor(absX + 0.5), 0, math.floor(absY + 0.5))
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local pos2 = input.Position
		local function hitBtn(btn)
			local ok, hit = pcall(function()
				local p, s = btn.AbsolutePosition, btn.AbsoluteSize
				return pos2.X >= p.X and pos2.X <= p.X + s.X and pos2.Y >= p.Y and pos2.Y <= p.Y + s.Y
			end)
			return ok and hit
		end
		if hitBtn(minBtn) or hitBtn(closeBtn) then return end
		dragging = true; dragInput = input; dragStartPos = input.Position; startMainPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End and dragInput == input then
				dragging = false; dragInput = nil
				state.posX = main.Position.X.Offset; state.posYScale = 0; state.posYOffset = main.Position.Y.Offset
				saveConfigToFile()
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		if dragging and not dragInput then dragInput = input end
	end
end)

UIS.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		if dragging and input == dragInput then
			local delta = input.Position - dragStartPos
			local nextPos = UDim2.new(startMainPos.X.Scale, startMainPos.X.Offset + delta.X, startMainPos.Y.Scale, startMainPos.Y.Offset + delta.Y)
			local clamped = clampMainPosition(nextPos)
			safeSetProp(main, "Position", clamped)
			state.posX = clamped.X.Offset; state.posYScale = 0; state.posYOffset = clamped.Y.Offset
		end
	end
end)

local tabBar = Instance.new("ScrollingFrame")
tabBar.Size = UDim2.new(1, 0, 0, 24); tabBar.BackgroundColor3 = T.tabBg; tabBar.BorderSizePixel = 0
tabBar.ScrollBarThickness = 2; tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X; tabBar.ScrollingDirection = Enum.ScrollingDirection.X; tabBar.Parent = body
corner(tabBar, 7)
local tabLayout = Instance.new("UIListLayout"); tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.Padding = UDim.new(0, 3); tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center; tabLayout.Parent = tabBar
local tabPad = Instance.new("UIPadding"); tabPad.PaddingLeft = UDim.new(0, 3); tabPad.PaddingRight = UDim.new(0, 3); tabPad.Parent = tabBar

local rarityBar = Instance.new("ScrollingFrame")
rarityBar.Size = UDim2.new(1, -92, 0, 22); rarityBar.Position = UDim2.new(0, 0, 0, 27)
rarityBar.BackgroundColor3 = T.tabBg; rarityBar.BorderSizePixel = 0; rarityBar.ScrollBarThickness = 2
rarityBar.CanvasSize = UDim2.new(0, 0, 0, 0); rarityBar.AutomaticCanvasSize = Enum.AutomaticSize.X
rarityBar.ScrollingDirection = Enum.ScrollingDirection.X; rarityBar.Parent = body; corner(rarityBar, 6)
local rarityLayout = Instance.new("UIListLayout"); rarityLayout.FillDirection = Enum.FillDirection.Horizontal; rarityLayout.Padding = UDim.new(0, 3); rarityLayout.VerticalAlignment = Enum.VerticalAlignment.Center; rarityLayout.Parent = rarityBar
local rarityPad = Instance.new("UIPadding"); rarityPad.PaddingLeft = UDim.new(0, 3); rarityPad.PaddingRight = UDim.new(0, 3); rarityPad.Parent = rarityBar

local previewFrame = Instance.new("Frame")
previewFrame.Size = UDim2.new(0, 88, 1, -27); previewFrame.Position = UDim2.new(1, -88, 0, 27)
previewFrame.BackgroundColor3 = T.preview; previewFrame.BorderSizePixel = 0; previewFrame.Parent = body
corner(previewFrame, 9); stroke(previewFrame, Color3.fromRGB(60, 65, 100), 1)
textLabel(previewFrame, UDim2.new(1, -6, 0, 14), UDim2.new(0, 3, 0, 3), "PREVIEW", Enum.Font.GothamBold, 8, T.muted, Enum.TextXAlignment.Center)

local previewImg = Instance.new("ImageLabel")
previewImg.Size = UDim2.new(1, -12, 0, 56); previewImg.Position = UDim2.new(0, 6, 0, 18)
previewImg.BackgroundColor3 = T.imgBg; previewImg.BorderSizePixel = 0; previewImg.Image = ""
previewImg.ScaleType = Enum.ScaleType.Fit; previewImg.Parent = previewFrame; corner(previewImg, 6)

local previewSwatch = Instance.new("Frame")
previewSwatch.Size = UDim2.new(1, -12, 0, 56); previewSwatch.Position = UDim2.new(0, 6, 0, 18)
previewSwatch.BackgroundColor3 = Color3.fromRGB(178, 114, 68); previewSwatch.BorderSizePixel = 0
previewSwatch.Visible = false; previewSwatch.Parent = previewFrame; corner(previewSwatch, 6)

local previewName = Instance.new("TextLabel")
previewName.Size = UDim2.new(1, -6, 0, 24); previewName.Position = UDim2.new(0, 3, 0, 76)
previewName.BackgroundTransparency = 1; previewName.Text = ""; previewName.TextColor3 = T.text
previewName.Font = Enum.Font.GothamBold; previewName.TextSize = 8
previewName.TextXAlignment = Enum.TextXAlignment.Center; previewName.TextWrapped = true; previewName.Parent = previewFrame

local previewRarityLbl = Instance.new("TextLabel")
previewRarityLbl.Size = UDim2.new(1, -6, 0, 14); previewRarityLbl.Position = UDim2.new(0, 3, 0, 100)
previewRarityLbl.BackgroundTransparency = 1; previewRarityLbl.Text = ""; previewRarityLbl.TextColor3 = T.accent
previewRarityLbl.Font = Enum.Font.GothamBlack; previewRarityLbl.TextSize = 8
previewRarityLbl.TextXAlignment = Enum.TextXAlignment.Center; previewRarityLbl.Parent = previewFrame

local gridClip = Instance.new("Frame")
gridClip.Size = UDim2.new(1, -92, 1, -52); gridClip.Position = UDim2.new(0, 0, 0, 52)
gridClip.BackgroundTransparency = 1; gridClip.ClipsDescendants = true; gridClip.Parent = body

local grid = Instance.new("ScrollingFrame")
grid.Size = UDim2.new(1, 0, 1, 0); grid.BackgroundTransparency = 1; grid.BorderSizePixel = 0
grid.ScrollBarThickness = 2; grid.ScrollBarImageColor3 = T.accent
grid.CanvasSize = UDim2.new(0, 0, 0, 0); grid.AutomaticCanvasSize = Enum.AutomaticSize.Y; grid.Parent = gridClip

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 62, 0, 74); gridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder; gridLayout.Parent = grid
local gridPad = Instance.new("UIPadding"); gridPad.PaddingTop = UDim.new(0, 2); gridPad.PaddingLeft = UDim.new(0, 2); gridPad.Parent = grid

local miscFrame = Instance.new("ScrollingFrame")
miscFrame.Size = UDim2.new(1, 0, 1, -28); miscFrame.Position = UDim2.new(0, 0, 0, 28)
miscFrame.BackgroundTransparency = 1; miscFrame.BorderSizePixel = 0; miscFrame.ScrollBarThickness = 2
miscFrame.ScrollBarImageColor3 = T.accent; miscFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
miscFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y; miscFrame.Visible = false; miscFrame.Parent = body

local miscLayout = Instance.new("UIListLayout"); miscLayout.FillDirection = Enum.FillDirection.Vertical; miscLayout.Padding = UDim.new(0, 5); miscLayout.SortOrder = Enum.SortOrder.LayoutOrder; miscLayout.Parent = miscFrame
local miscPad = Instance.new("UIPadding"); miscPad.PaddingTop = UDim.new(0, 3); miscPad.PaddingLeft = UDim.new(0, 2); miscPad.PaddingRight = UDim.new(0, 4); miscPad.PaddingBottom = UDim.new(0, 4); miscPad.Parent = miscFrame

local function makeMiscToggleRow(order, labelText)
	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, 38); box.LayoutOrder = order
	box.BackgroundColor3 = T.card; box.BorderSizePixel = 0; box.Parent = miscFrame
	corner(box, 8); stroke(box, Color3.fromRGB(60, 65, 100), 1)
	textLabel(box, UDim2.new(1, -54, 1, 0), UDim2.new(0, 10, 0, 0), labelText, Enum.Font.GothamBlack, 9, T.text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 36, 0, 22); btn.Position = UDim2.new(1, -44, 0.5, -11)
	btn.BackgroundColor3 = T.btn; btn.BorderSizePixel = 0; btn.Text = "OFF"
	btn.TextColor3 = T.muted; btn.Font = Enum.Font.GothamBlack; btn.TextSize = 9; btn.Parent = box; corner(btn, 6)
	return btn
end

local autoExecToggle = makeMiscToggleRow(1, "AUTO EXECUTE")
local skinsRgbToggle = makeMiscToggleRow(2, "SKINS RGB")

local saveCfgBox = Instance.new("Frame")
saveCfgBox.Size = UDim2.new(1, 0, 0, 38); saveCfgBox.LayoutOrder = 3
saveCfgBox.BackgroundColor3 = T.card; saveCfgBox.BorderSizePixel = 0; saveCfgBox.Parent = miscFrame
corner(saveCfgBox, 8); stroke(saveCfgBox, Color3.fromRGB(60, 65, 100), 1)
textLabel(saveCfgBox, UDim2.new(1, -86, 1, 0), UDim2.new(0, 10, 0, 0), "SALVAR CONFIGURACAO", Enum.Font.GothamBlack, 9, T.text)
local saveCfgBtn = Instance.new("TextButton")
saveCfgBtn.Size = UDim2.new(0, 64, 0, 22); saveCfgBtn.Position = UDim2.new(1, -72, 0.5, -11)
saveCfgBtn.BackgroundColor3 = T.accent; saveCfgBtn.BorderSizePixel = 0; saveCfgBtn.Text = "SALVAR"
saveCfgBtn.TextColor3 = T.text; saveCfgBtn.Font = Enum.Font.GothamBlack; saveCfgBtn.TextSize = 8; saveCfgBtn.Parent = saveCfgBox; corner(saveCfgBtn, 6)

local hideToggle = makeMiscToggleRow(4, "NOMES")
local fpsToggle = makeMiscToggleRow(5, "FPS")

-- Pagina NICK / TAG
local nickTagPage = Instance.new("Frame")
nickTagPage.Size = UDim2.new(1, 0, 1, -28); nickTagPage.Position = UDim2.new(0, 0, 0, 28)
nickTagPage.BackgroundTransparency = 1; nickTagPage.Visible = false; nickTagPage.Parent = body

local nickRgbBtn = Instance.new("TextButton")
nickRgbBtn.Size = UDim2.new(0.5, -2, 0, 20); nickRgbBtn.Position = UDim2.new(0, 0, 0, 1)
nickRgbBtn.BackgroundColor3 = T.btn; nickRgbBtn.BorderSizePixel = 0
nickRgbBtn.Text = "NICK RGB: OFF"; nickRgbBtn.TextColor3 = T.text
nickRgbBtn.Font = Enum.Font.GothamBlack; nickRgbBtn.TextSize = 8; nickRgbBtn.Parent = nickTagPage; corner(nickRgbBtn, 5)

local syncRgbBtn = Instance.new("TextButton")
syncRgbBtn.Size = UDim2.new(0.5, -2, 0, 20); syncRgbBtn.Position = UDim2.new(0.5, 2, 0, 1)
syncRgbBtn.BackgroundColor3 = T.btn; syncRgbBtn.BorderSizePixel = 0
syncRgbBtn.Text = "SINCRONIZAR RGB: OFF"; syncRgbBtn.TextColor3 = T.text
syncRgbBtn.Font = Enum.Font.GothamBlack; syncRgbBtn.TextSize = 7; syncRgbBtn.Parent = nickTagPage; corner(syncRgbBtn, 5)

local nickPaletteGrid = Instance.new("Frame")
nickPaletteGrid.Size = UDim2.new(1, 0, 0, 38); nickPaletteGrid.Position = UDim2.new(0, 0, 0, 24)
nickPaletteGrid.BackgroundTransparency = 1; nickPaletteGrid.Parent = nickTagPage
local nickPalLayout = Instance.new("UIGridLayout"); nickPalLayout.CellSize = UDim2.new(0.25, -3, 0, 17); nickPalLayout.CellPadding = UDim2.new(0, 4, 0, 3); nickPalLayout.Parent = nickPaletteGrid

local nickColorBtns, tagColorBtns = {}, {}

local function refreshNickTagPalettes()
	for _, entry in ipairs(nickColorBtns) do
		local st = entry.btn:FindFirstChildOfClass("UIStroke")
		if st then
			local sel = (not state.nickRgbOn) and state.nickColorOn and (entry.col == state.nickColor)
			st.Color = sel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(15, 17, 26)
			st.Thickness = sel and 2 or 1.2
		end
	end
	for _, entry in ipairs(tagColorBtns) do
		local st = entry.btn:FindFirstChildOfClass("UIStroke")
		if st then
			local sel = (not state.tagRgbOn) and state.tagColorOn and (entry.col == state.tagColor)
			st.Color = sel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(15, 17, 26)
			st.Thickness = sel and 2 or 1.2
		end
	end
end

local smallTagRgbBtn

local function syncNickTagRgbButtons()
	nickRgbBtn.Text = "NICK RGB: " .. (state.nickRgbOn and "ON" or "OFF")
	nickRgbBtn.BackgroundColor3 = state.nickRgbOn and T.accent or T.btn
	if smallTagRgbBtn then
		smallTagRgbBtn.Text = state.tagRgbOn and "TAG RGB: ON" or "TAG RGB"
		smallTagRgbBtn.BackgroundColor3 = state.tagRgbOn and T.accent or T.btn
	end
	syncRgbBtn.Text = "SINCRONIZAR RGB: " .. (state.syncRgbOn and "ON" or "OFF")
	syncRgbBtn.BackgroundColor3 = state.syncRgbOn and Color3.fromRGB(22, 163, 74) or T.btn
	refreshNickTagPalettes()
end

for _, colVal in ipairs(PALETTE) do
	local cBtn = Instance.new("TextButton")
	cBtn.BackgroundColor3 = colVal; cBtn.Text = ""; cBtn.BorderSizePixel = 0; cBtn.Parent = nickPaletteGrid; corner(cBtn, 4)
	local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(15, 17, 26); st.Thickness = 1.2; st.Parent = cBtn
	nickColorBtns[#nickColorBtns + 1] = { btn = cBtn, col = colVal }
	cBtn.MouseButton1Click:Connect(function()
		state.nickRgbOn = false; state.nickColorOn = true; state.nickColor = colVal
		syncNickTagRgbButtons()
	end)
end

nickRgbBtn.MouseButton1Click:Connect(function()
	state.nickRgbOn = not state.nickRgbOn
	if state.nickRgbOn then
		state.nickColorOn = false
		if state.syncRgbOn then
			state.tagRgbOn = true
			state.tagColorOn = false
			tagHue = nickHue
		end
	elseif state.syncRgbOn then
		state.tagRgbOn = false
	end
	syncNickTagRgbButtons()
end)

syncRgbBtn.MouseButton1Click:Connect(function()
	state.syncRgbOn = not state.syncRgbOn
	if state.syncRgbOn then
		state.nickRgbOn = true
		state.tagRgbOn = true
		state.nickColorOn = false
		state.tagColorOn = false
		tagHue = nickHue
	end
	syncNickTagRgbButtons()
end)

local nickEditRow = Instance.new("Frame")
nickEditRow.Size = UDim2.new(1, 0, 0, 26); nickEditRow.Position = UDim2.new(0, 0, 0, 66)
nickEditRow.BackgroundColor3 = T.card; nickEditRow.BorderSizePixel = 0; nickEditRow.Parent = nickTagPage; corner(nickEditRow, 6)

local nickBox = Instance.new("TextBox")
nickBox.Size = UDim2.new(0.56, -6, 0, 20); nickBox.Position = UDim2.new(0, 4, 0.5, -10)
nickBox.BackgroundColor3 = T.bg; nickBox.BorderSizePixel = 0
nickBox.PlaceholderText = "Nick..."; nickBox.PlaceholderColor3 = T.muted
nickBox.Text = ""; nickBox.TextColor3 = T.text; nickBox.Font = Enum.Font.GothamBold; nickBox.TextSize = 8
nickBox.ClearTextOnFocus = false; nickBox.Parent = nickEditRow; corner(nickBox, 4)

local applyNickBtn = Instance.new("TextButton")
applyNickBtn.Size = UDim2.new(0.22, -3, 0, 20); applyNickBtn.Position = UDim2.new(0.56, 0, 0.5, -10)
applyNickBtn.BackgroundColor3 = T.accent; applyNickBtn.BorderSizePixel = 0
applyNickBtn.Text = "OK"; applyNickBtn.TextColor3 = T.text; applyNickBtn.Font = Enum.Font.GothamBlack; applyNickBtn.TextSize = 8
applyNickBtn.Parent = nickEditRow; corner(applyNickBtn, 4)

local resetNickBtn = Instance.new("TextButton")
resetNickBtn.Size = UDim2.new(0.22, -5, 0, 20); resetNickBtn.Position = UDim2.new(0.78, 2, 0.5, -10)
resetNickBtn.BackgroundColor3 = T.btn; resetNickBtn.BorderSizePixel = 0
resetNickBtn.Text = "X"; resetNickBtn.TextColor3 = T.text; resetNickBtn.Font = Enum.Font.GothamBlack; resetNickBtn.TextSize = 8
resetNickBtn.Parent = nickEditRow; corner(resetNickBtn, 4)

applyNickBtn.MouseButton1Click:Connect(function()
	local typed = tostring(nickBox.Text or "")
	if typed ~= "" then
		state.customNickText = typed; state.customNickOn = true
		applyNickBtn.BackgroundColor3 = Color3.fromRGB(22, 163, 74)
	end
end)

resetNickBtn.MouseButton1Click:Connect(function()
	state.customNickOn = false; state.customNickText = ""; nickBox.Text = ""
	applyNickBtn.BackgroundColor3 = T.accent
end)

local smallTagRow = Instance.new("Frame")
smallTagRow.Size = UDim2.new(1, 0, 0, 26); smallTagRow.Position = UDim2.new(0, 0, 0, 96)
smallTagRow.BackgroundColor3 = T.card; smallTagRow.BorderSizePixel = 0; smallTagRow.Parent = nickTagPage; corner(smallTagRow, 6)

local smallTagBox = Instance.new("TextBox")
smallTagBox.Size = UDim2.new(0.68, -6, 0, 20); smallTagBox.Position = UDim2.new(0, 4, 0.5, -10)
smallTagBox.BackgroundColor3 = T.bg; smallTagBox.BorderSizePixel = 0
smallTagBox.PlaceholderText = "Tag pequena..."; smallTagBox.PlaceholderColor3 = T.muted
smallTagBox.Text = ""; smallTagBox.TextColor3 = Color3.fromRGB(250, 204, 21)
smallTagBox.Font = Enum.Font.GothamBlack; smallTagBox.TextSize = 8; smallTagBox.ClearTextOnFocus = false; smallTagBox.Parent = smallTagRow; corner(smallTagBox, 4)

smallTagRgbBtn = Instance.new("TextButton")
smallTagRgbBtn.Size = UDim2.new(0.32, -4, 0, 20); smallTagRgbBtn.Position = UDim2.new(0.68, 0, 0.5, -10)
smallTagRgbBtn.BackgroundColor3 = T.btn; smallTagRgbBtn.BorderSizePixel = 0
smallTagRgbBtn.Text = "TAG RGB"; smallTagRgbBtn.TextColor3 = T.text; smallTagRgbBtn.Font = Enum.Font.GothamBlack; smallTagRgbBtn.TextSize = 8
smallTagRgbBtn.Parent = smallTagRow; corner(smallTagRgbBtn, 4)

local tagPaletteGrid = Instance.new("Frame")
tagPaletteGrid.Size = UDim2.new(1, 0, 0, 24); tagPaletteGrid.Position = UDim2.new(0, 0, 0, 126)
tagPaletteGrid.BackgroundTransparency = 1; tagPaletteGrid.Parent = nickTagPage
local tagPalLayout = Instance.new("UIGridLayout"); tagPalLayout.CellSize = UDim2.new(0.125, -3, 0, 20); tagPalLayout.CellPadding = UDim2.new(0, 3, 0, 2); tagPalLayout.Parent = tagPaletteGrid

for _, colVal in ipairs(PALETTE) do
	local tBtn = Instance.new("TextButton")
	tBtn.BackgroundColor3 = colVal; tBtn.Text = ""; tBtn.BorderSizePixel = 0; tBtn.Parent = tagPaletteGrid; corner(tBtn, 4)
	local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(15, 17, 26); st.Thickness = 1.2; st.Parent = tBtn
	tagColorBtns[#tagColorBtns + 1] = { btn = tBtn, col = colVal }
	tBtn.MouseButton1Click:Connect(function()
		state.tagText = tostring(smallTagBox.Text or "")
		state.tagRgbOn = false; state.tagColorOn = true; state.tagColor = colVal
		smallTagBox.TextColor3 = colVal
		syncNickTagRgbButtons()
	end)
end

smallTagBox:GetPropertyChangedSignal("Text"):Connect(function()
	state.tagText = tostring(smallTagBox.Text or "")
	if state.tagText ~= "" and not state.tagColorOn and not state.tagRgbOn then
		state.tagColorOn = true
		refreshNickTagPalettes()
	end
end)

smallTagBox.FocusLost:Connect(function()
	state.tagText = tostring(smallTagBox.Text or "")
	if state.tagText ~= "" and not state.tagColorOn and not state.tagRgbOn then
		state.tagColorOn = true; refreshNickTagPalettes()
	end
end)

smallTagRgbBtn.MouseButton1Click:Connect(function()
	state.tagText = tostring(smallTagBox.Text or "")
	state.tagRgbOn = not state.tagRgbOn
	if state.tagRgbOn then
		state.tagColorOn = false
		if state.syncRgbOn then
			state.nickRgbOn = true
			state.nickColorOn = false
			tagHue = nickHue
		end
	elseif state.syncRgbOn then
		state.nickRgbOn = false
	end
	syncNickTagRgbButtons()
end)

-- Pagina ESP
local espPage = Instance.new("Frame")
espPage.Size = UDim2.new(1, 0, 1, -28); espPage.Position = UDim2.new(0, 0, 0, 28)
espPage.BackgroundTransparency = 1; espPage.Visible = false; espPage.Parent = body

local espToggleBtn = Instance.new("TextButton")
espToggleBtn.Size = UDim2.new(1, 0, 0, 32); espToggleBtn.Position = UDim2.new(0, 0, 0, 4)
espToggleBtn.BackgroundColor3 = T.btn; espToggleBtn.BorderSizePixel = 0
espToggleBtn.Text = "PLAYER ESP: OFF"; espToggleBtn.TextColor3 = T.text
espToggleBtn.Font = Enum.Font.GothamBlack; espToggleBtn.TextSize = 9; espToggleBtn.Parent = espPage; corner(espToggleBtn, 6)

local espNameToggleBtn = Instance.new("TextButton")
espNameToggleBtn.Size = UDim2.new(1, 0, 0, 32); espNameToggleBtn.Position = UDim2.new(0, 0, 0, 42)
espNameToggleBtn.BackgroundColor3 = T.btn; espNameToggleBtn.BorderSizePixel = 0
espNameToggleBtn.Text = "ESP NAME: OFF"; espNameToggleBtn.TextColor3 = T.text
espNameToggleBtn.Font = Enum.Font.GothamBlack; espNameToggleBtn.TextSize = 9; espNameToggleBtn.Parent = espPage; corner(espNameToggleBtn, 6)

local clearEspBtn = Instance.new("TextButton")
clearEspBtn.Size = UDim2.new(1, 0, 0, 28); clearEspBtn.Position = UDim2.new(0, 0, 0, 80)
clearEspBtn.BackgroundColor3 = T.card; clearEspBtn.BorderSizePixel = 0
clearEspBtn.Text = "LIMPAR ESP"; clearEspBtn.TextColor3 = T.text
clearEspBtn.Font = Enum.Font.GothamBold; clearEspBtn.TextSize = 8; clearEspBtn.Parent = espPage; corner(clearEspBtn, 6)

local function syncPlayerEspVisual()
	espToggleBtn.Text = "PLAYER ESP: " .. (state.playerEspOn and "ON" or "OFF")
	espToggleBtn.BackgroundColor3 = state.playerEspOn and Color3.fromRGB(22, 163, 74) or T.btn
end

local function syncEspNameVisual()
	espNameToggleBtn.Text = "ESP NAME: " .. (state.espNameOn and "ON" or "OFF")
	espNameToggleBtn.BackgroundColor3 = state.espNameOn and Color3.fromRGB(22, 163, 74) or T.btn
end

espToggleBtn.MouseButton1Click:Connect(function()
	state.playerEspOn = not state.playerEspOn
	syncPlayerEspVisual()
	if state.playerEspOn then updatePlayerEsp() else clearPlayerEsp() end
end)

espNameToggleBtn.MouseButton1Click:Connect(function()
	state.espNameOn = not state.espNameOn
	syncEspNameVisual()
	if state.espNameOn then updateEspNames() else clearEspNames() end
end)

clearEspBtn.MouseButton1Click:Connect(function()
	clearPlayerEsp()
	clearEspNames()
end)

local gridCards, rarityBtns = {}, {}

local function getSelectedIdKey(tabId)
	return ({ skin = "skinId", color = "colorId", trail = "trailId", punch = "punchId" })[tabId]
end
local function getListForTab(tabId)
	return ({ skin = skinList, color = colorList, trail = trailList, punch = punchList })[tabId] or {}
end
local function getThumbData(tabId, item)
	local id = item.id
	if tabId == "skin" then return resolveThumbAsset(findSkinThumbRaw(item)), false, nil end
	if tabId == "trail" then return TRAIL_THUMBS[id] or "", false, nil end
	if tabId == "punch" then return PUNCH_THUMBS[id] or "", false, nil end
	if tabId == "color" then return "", true, resolveColorValue(item) end
	return "", false, nil
end

local function canTouchUi()
	if state.minimized or state.tab == "misc" or state.tab == "nicktag" or state.tab == "esp" then return false end
	return gui and gui.Parent ~= nil and main and main.Parent ~= nil and body and body.Parent ~= nil
end

updatePreview = function()
	if not canTouchUi() then return end
	local list = getListForTab(state.tab)
	local idKey = getSelectedIdKey(state.tab)
	local item = findItemById(list, state[idKey])
	if not item then return end

	local img, isSwatch, swatchColor = getThumbData(state.tab, item)
	if isSwatch then
		safeSetProp(previewImg, "Visible", false)
		safeSetProp(previewSwatch, "Visible", true)
		safeSetProp(previewSwatch, "BackgroundColor3", swatchColor or Color3.fromRGB(178, 114, 68))
	else
		safeSetProp(previewSwatch, "Visible", false)
		safeSetProp(previewImg, "Visible", true)
		safeSetProp(previewImg, "Image", img)
		safeSetProp(previewImg, "ScaleType", Enum.ScaleType.Fit)
	end

	safeSetProp(previewName, "Text", (state.tab == "color") and formatColorDisplayName(item) or tostring(item.name or item.id or ""))
	safeSetProp(previewRarityLbl, "Text", (state.tab == "skin") and tostring(getRarityForSkin(item) or "") or string.upper(tostring(state.tab or "")))

	for _, entry in ipairs(gridCards) do
		if entry and entry.card then
			local sel = (entry.itemId == item.id)
			safeSetProp(entry.card, "BackgroundColor3", sel and T.cardSel or T.card)
			local s = entry.card:FindFirstChildOfClass("UIStroke")
			if s then s.Enabled = sel end
		end
	end
end

local function refreshRarityButtons()
	local selectedRarity = RARITIES[state.rarityIdx] or RARITIES[1]
	for _, rb in ipairs(rarityBtns) do
		if rb.btn then
			local isSel = (rb.rarity == selectedRarity)
			safeSetProp(rb.btn, "BackgroundColor3", isSel and T.accent or T.card)
			safeSetProp(rb.btn, "TextColor3", isSel and T.text or T.muted)
		end
	end
end

local function setSkinsRgbVisual(enabled)
	safeSetProp(skinsRgbToggle, "Text", enabled and "ON" or "OFF")
	safeSetProp(skinsRgbToggle, "TextColor3", enabled and T.text or T.muted)
	safeSetProp(skinsRgbToggle, "BackgroundColor3", enabled and T.accentD or T.btn)
end

local rgbLoopGen = 0
local function startSkinsRgbLoop()
	rgbLoopGen += 1
	local currentGen = rgbLoopGen
	task.spawn(function()
		local idx = 1
		while state.skinsRgb and currentGen == rgbLoopGen do
			local count = #rgbSkinPool
			if count > 0 then
				if idx > count then idx = 1 end
				local item = rgbSkinPool[idx]
				local char = lp and lp.Character
				if item and item.id and not isForbiddenRedLenco(item) then
					applyRgbSkinFast(tostring(item.id), char)
					if not state.minimized and state.tab == "skin" then updatePreview() end
				end
				idx += 1
			end
			task.wait(1.35)
		end
	end)
end

local function setSkinsRgbEnabled(enabled)
	local nextVal = enabled and true or false
	state.skinsRgb = nextVal
	rgbLoopGen += 1
	setSkinsRgbVisual(nextVal)
	if nextVal then startSkinsRgbLoop() end
end

local function buildGrid(tabId)
	for _, entry in ipairs(gridCards) do
		if entry.card then pcall(function() entry.card:Destroy() end) end
	end
	gridCards = {}

	local isSkinTab = (tabId == "skin")
	local isMiscTab = (tabId == "misc")
	local isNickTagTab = (tabId == "nicktag")
	local isEspTab = (tabId == "esp")
	local isCustomPage = isMiscTab or isNickTagTab or isEspTab

	safeSetProp(rarityBar, "Visible", isSkinTab)
	safeSetProp(miscFrame, "Visible", isMiscTab)
	safeSetProp(nickTagPage, "Visible", isNickTagTab)
	safeSetProp(espPage, "Visible", isEspTab)
	safeSetProp(previewFrame, "Visible", not isCustomPage)
	safeSetProp(gridClip, "Visible", not isCustomPage)
	if isCustomPage then return end

	safeSetProp(gridClip, "Position", isSkinTab and UDim2.new(0, 0, 0, 52) or UDim2.new(0, 0, 0, 28))
	safeSetProp(gridClip, "Size", isSkinTab and UDim2.new(1, -92, 1, -52) or UDim2.new(1, -92, 1, -28))

	local list = getListForTab(tabId)
	local idKey = getSelectedIdKey(tabId)
	local selectedRarity = RARITIES[state.rarityIdx] or RARITIES[1]

	for i, item in ipairs(list) do
		if not isForbiddenRedLenco(item) and ((not isSkinTab) or (getRarityForSkin(item) == selectedRarity)) then
			local img, isSwatch, swatchColor = getThumbData(tabId, item)
			local card = Instance.new("TextButton")
			card.Size = UDim2.new(0, 62, 0, 74); card.BackgroundColor3 = T.card; card.BorderSizePixel = 0
			card.Text = ""; card.LayoutOrder = i; card.Parent = grid; corner(card, 7)

			local sel = Instance.new("UIStroke")
			sel.Color = T.accent; sel.Thickness = 2; sel.Enabled = false; sel.Parent = card

			local imgArea = Instance.new("Frame")
			imgArea.Size = UDim2.new(1, -6, 0, 44); imgArea.Position = UDim2.new(0, 3, 0, 3)
			imgArea.BackgroundColor3 = isSwatch and (swatchColor or Color3.fromRGB(178, 114, 68)) or T.imgBg
			imgArea.BorderSizePixel = 0; imgArea.Parent = card; corner(imgArea, 5)

			if not isSwatch and img ~= "" then
				local icoImg = Instance.new("ImageLabel")
				icoImg.Size = UDim2.new(1, 0, 1, 0); icoImg.BackgroundTransparency = 1
				icoImg.Image = img; icoImg.ScaleType = Enum.ScaleType.Fit; icoImg.Parent = imgArea
			end

			local nameLbl = Instance.new("TextLabel")
			nameLbl.Size = UDim2.new(1, -4, 0, 22); nameLbl.Position = UDim2.new(0, 2, 0, 49)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = (tabId == "color") and formatColorDisplayName(item) or tostring(item.name or item.id or "")
			nameLbl.TextColor3 = T.text; nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 7; nameLbl.TextWrapped = true
			nameLbl.TextXAlignment = Enum.TextXAlignment.Center; nameLbl.Parent = card

			gridCards[#gridCards + 1] = { card = card, itemId = item.id }
			local capturedId = item.id
			card.MouseButton1Click:Connect(function()
				if idKey == "skinId" and state.skinsRgb then setSkinsRgbEnabled(false) end
				state[idKey] = capturedId; updatePreview(); applyCosmetics()
			end)
		end
	end
	updatePreview()
end

for idx, rName in ipairs(RARITIES) do
	local rb = Instance.new("TextButton")
	rb.Size = UDim2.new(0, 56, 0, 18); rb.BackgroundColor3 = T.card; rb.BorderSizePixel = 0
	rb.Text = rName; rb.TextColor3 = T.muted; rb.Font = Enum.Font.GothamBold; rb.TextSize = 7
	rb.Parent = rarityBar; corner(rb, 5)
	rarityBtns[#rarityBtns + 1] = { rarity = rName, btn = rb }
	local capturedRarityIdx = idx
	rb.MouseButton1Click:Connect(function()
		state.rarityIdx = capturedRarityIdx; refreshRarityButtons()
		if state.tab == "skin" then buildGrid("skin") end
	end)
end

local tabBtns = {}
local TABS = {
	{ id = "skin", label = "SKIN" }, { id = "color", label = "COR" },
	{ id = "trail", label = "TRAIL" }, { id = "punch", label = "PUNCH" },
	{ id = "nicktag", label = "NICK/TAG" }, { id = "esp", label = "ESP" },
	{ id = "misc", label = "MISC" },
}

local function switchTab(tabId)
	state.tab = tabId
	for _, tb in ipairs(tabBtns) do
		if tb.btn then
			safeSetProp(tb.btn, "BackgroundColor3", (tb.id == tabId) and T.tabSel or T.tabBg)
			safeSetProp(tb.btn, "TextColor3", (tb.id == tabId) and T.text or T.muted)
		end
	end
	buildGrid(tabId)
end

for _, def in ipairs(TABS) do
	local tb = Instance.new("TextButton")
	tb.Size = UDim2.new(0, 52, 0, 18); tb.BackgroundColor3 = T.tabBg; tb.BorderSizePixel = 0
	tb.Text = def.label; tb.TextColor3 = T.muted; tb.Font = Enum.Font.GothamBold; tb.TextSize = 8
	tb.Parent = tabBar; corner(tb, 6)
	tabBtns[#tabBtns + 1] = { id = def.id, btn = tb }
	tb.MouseButton1Click:Connect(function() switchTab(def.id) end)
end

local function syncAutoExecVisual()
	safeSetProp(autoExecToggle, "Text", state.autoExec and "ON" or "OFF")
	safeSetProp(autoExecToggle, "TextColor3", state.autoExec and T.text or T.muted)
	safeSetProp(autoExecToggle, "BackgroundColor3", state.autoExec and T.accentD or T.btn)
end

local function syncFpsVisual()
	local on = state.fpsCounterOn and true or false
	safeSetProp(fpsToggle, "Text", on and "ON" or "OFF")
	safeSetProp(fpsToggle, "TextColor3", on and T.text or T.muted)
	safeSetProp(fpsToggle, "BackgroundColor3", on and Color3.fromRGB(22, 163, 74) or T.btn)
	safeSetProp(fpsBadge, "Visible", on)
	if not on then
		fpsFrames = 0
		fpsAccum = 0
		safeSetProp(fpsLbl, "Text", "FPS: --")
	end
end

autoExecToggle.MouseButton1Click:Connect(function()
	state.autoExec = not state.autoExec
	syncAutoExecVisual(); saveConfigToFile()
	if state.autoExec then queueTeleportActions(true) else lastQueuedSignature = nil end
end)

skinsRgbToggle.MouseButton1Click:Connect(function()
	setSkinsRgbEnabled(not state.skinsRgb)
end)

fpsToggle.MouseButton1Click:Connect(function()
	state.fpsCounterOn = not state.fpsCounterOn
	syncFpsVisual()
end)

saveCfgBtn.MouseButton1Click:Connect(function()
	state.tagText = tostring(smallTagBox.Text or "")
	if tostring(nickBox.Text or "") ~= "" then
		state.customNickText = tostring(nickBox.Text or "")
		state.customNickOn = true
	end
	saveConfigToFile(); queueTeleportActions(true)
	safeSetProp(saveCfgBtn, "Text", "SALVO")
	safeSetProp(saveCfgBtn, "BackgroundColor3", T.accentD)
	task.delay(1.2, function()
		safeSetProp(saveCfgBtn, "Text", "SALVAR")
		safeSetProp(saveCfgBtn, "BackgroundColor3", T.accent)
	end)
end)

hideToggle.MouseButton1Click:Connect(function()
	state.hideNames = not state.hideNames
	safeSetProp(hideToggle, "Text", state.hideNames and "ON" or "OFF")
	safeSetProp(hideToggle, "TextColor3", state.hideNames and T.text or T.muted)
	safeSetProp(hideToggle, "BackgroundColor3", state.hideNames and T.accentD or T.btn)
	pcall(lp.SetAttribute, lp, "SGHideAllNames", state.hideNames)
end)

minBtn.MouseButton1Click:Connect(function()
	applyMinimizeState(not state.minimized, true)
end)

closeBtn.MouseButton1Click:Connect(function()
	setSkinsRgbEnabled(false)
	clearPlayerEsp()
	clearEspNames()
	pcall(function() gui:Destroy() end)
end)

lp.CharacterAdded:Connect(function(char)
	task.wait(0.8)
	applyCosmetics(char)
end)

task.spawn(function()
	pcall(function()
		syncNickTagRgbButtons()
		refreshRarityButtons()
		switchTab("skin")
		syncFpsVisual()

		local savedCfg = loadSavedConfig()
		if type(savedCfg) == "table" then
			if type(savedCfg.skinId) == "string" and savedCfg.skinId ~= "" then
				local sObj = findItemById(skinList, savedCfg.skinId)
				state.skinId = (sObj and not isForbiddenRedLenco(sObj) and sObj.id) or "BonecoNoob"
			end
			if type(savedCfg.colorId) == "string" and savedCfg.colorId ~= "" then state.colorId = savedCfg.colorId end
			if type(savedCfg.trailId) == "string" and savedCfg.trailId ~= "" then state.trailId = savedCfg.trailId end
			if type(savedCfg.punchId) == "string" and savedCfg.punchId ~= "" then state.punchId = savedCfg.punchId end
			if type(savedCfg.hideNames) == "boolean" then state.hideNames = savedCfg.hideNames end
			if type(savedCfg.autoExec) == "boolean" then state.autoExec = savedCfg.autoExec end
			if type(savedCfg.minimized) == "boolean" then state.minimized = savedCfg.minimized end
			if type(savedCfg.fpsCounterOn) == "boolean" then state.fpsCounterOn = savedCfg.fpsCounterOn end
			if type(savedCfg.syncRgbOn) == "boolean" then state.syncRgbOn = savedCfg.syncRgbOn end
			state.posX = tonumber(savedCfg.posX) or 4; state.posYScale = tonumber(savedCfg.posYScale) or 0; state.posYOffset = tonumber(savedCfg.posYOffset) or 100
			state.customNickOn = savedCfg.customNickOn and true or false; state.customNickText = tostring(savedCfg.customNickText or "")
			state.nickRgbOn = savedCfg.nickRgbOn and true or false; state.nickColorOn = savedCfg.nickColorOn and true or false
			state.nickColor = savedCfg.nickColor or Color3.fromRGB(239, 68, 68)
			state.tagText = tostring(savedCfg.tagText or "")
			state.tagRgbOn = savedCfg.tagRgbOn and true or false; state.tagColorOn = savedCfg.tagColorOn and true or false
			state.tagColor = savedCfg.tagColor or Color3.fromRGB(250, 204, 21)
			state.playerEspOn = savedCfg.playerEspOn and true or false
			state.espNameOn = savedCfg.espNameOn and true or false

			nickBox.Text = state.customNickText; smallTagBox.Text = state.tagText
			if state.customNickOn and state.customNickText ~= "" then applyNickBtn.BackgroundColor3 = Color3.fromRGB(22, 163, 74) end
			if state.tagColorOn then smallTagBox.TextColor3 = state.tagColor end
			syncNickTagRgbButtons()

			syncPlayerEspVisual(); syncEspNameVisual(); syncFpsVisual()
			if state.playerEspOn then updatePlayerEsp() end
			if state.espNameOn then updateEspNames() end

			safeSetProp(main, "Position", clampMainPosition(UDim2.new(0, state.posX, state.posYScale, state.posYOffset)))
			applyMinimizeState(state.minimized, false)

			safeSetProp(hideToggle, "Text", state.hideNames and "ON" or "OFF")
			safeSetProp(hideToggle, "TextColor3", state.hideNames and T.text or T.muted)
			safeSetProp(hideToggle, "BackgroundColor3", state.hideNames and T.accentD or T.btn)
			syncAutoExecVisual(); applyCosmetics(lp.Character); updatePreview()
		end
	end)
end)
