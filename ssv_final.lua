-- ssv | created by qmee2
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

-- ═══ ЗАГРУЖАЕМ ТВОЮ КАРТИНКУ ═══
local function loadBlackhole()
    if type(getcustomasset) == "function" and type(isfile) == "function" then
        if isfile("blackhole.png") then
            local ok, id = pcall(getcustomasset, "blackhole.png")
            if ok and id then return id end
        end
    end
    return "rbxassetid://16104850011"  -- фолбэк на Roblox asset
end

local BLACKHOLE = loadBlackhole()

local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _u = ""
for _, n in ipairs(_c) do _u = _u .. string.char(n + 10) end

local _cf = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108,85,92,95,100,87,98,36,98,107,87}
local _uf = ""
for _, n in ipairs(_cf) do _uf = _uf .. string.char(n + 10) end

do
    local _rs = 'loadstring(game:HttpGet("' .. _uf .. '"))()'
    local function _w(q) return function(_) return q(_rs) end end
    if type(queue_on_teleport) == "function" then _G.queue_on_teleport = _w(queue_on_teleport) end
    if type(queueonteleport) == "function" then _G.queueonteleport = _w(queueonteleport) end
    if syn and type(syn.queue_on_teleport) == "function" then syn.queue_on_teleport = _w(syn.queue_on_teleport) end
end

local function _g(u)
    if type(request) == "function" then
        local ok, r = pcall(request, { Url = u, Method = "GET" })
        if ok and r and r.Body then return r.Body end
    end
    local ok, r = pcall(game.HttpGet, game, u, true)
    if ok and type(r) == "string" then return r end
end

local src = _g(_u)
if type(src) ~= "string" or #src < 100000 then error("[ssv] fail") end

do
    local s1 = src:find('function Intro.Play', 1, true)
    if s1 then
        local e1 = src:find('return Intro', s1, true)
        if e1 then
            src = src:sub(1, s1 - 1) .. 'function Intro.Play() return true end\n' .. src:sub(e1)
        end
    end
end

local function R(p, r)
    local ok, n = pcall(function() return src:gsub(p, r) end)
    if ok then src = n end
end

-- Заменяем луну на ТВОЮ картинку
R('79685990879972', '16104850011')
R('"moon%-star"', '[[BH]]')
R('"moon"', '[[BH]]')
R('"Moon"', '[[BH]]')
R('BackgroundImage = "[^"]*[Mm]oon[^"]*"', 'BackgroundImage = ""')
R('🌙', '🌑')
R('🌚', '🌑')
R('🌛', '🌑')
R('🌜', '🌑')
R('🌑', '🌑')

-- Подставляем реальный asset из переменной
src = src:gsub("%[%[BH%]%]", function() return string.format("%q", BLACKHOLE) end)

-- Синий/оранжевый UI
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 130, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 105, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(50, 35, 25)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(255, 220, 180)')

R('<b>Auto%-Clicker</b>', '<b>poses</b>')
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')
R('cracked by InLoad and wraith%.dev', 'created by qmee2')
R('cracked by [^"]+', 'created by qmee2')
R('InLoad', 'qmee2')
R('wraith', 'qmee2')
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('or "Resonance"', 'or "ssv"')
R('AddTab%("<b>Home</b>", "house", "Profile, statistics"%)', 'AddTab("<b>ssv</b>", [[BH]], "ssv")')
src = src:gsub("%[%[BH%]%]", function() return string.format("%q", BLACKHOLE) end)
R('"v2%.9"', '""')

local pr = {"ResonanceRunning","ResonanceStarting","ResonanceOriginalFallenHeight","ResonanceRestored","ResonanceIntro"}
local rs = {}
for i, nm in ipairs(pr) do
    local k = "__S"..i.."__"
    src = src:gsub(nm, k)
    rs[k] = nm
end
src = src:gsub("Resonance", "ssv")
src = src:gsub("RESONANCE", "SSV")
src = src:gsub("Project ssv", "ssv")
for k, nm in pairs(rs) do src = src:gsub(k, nm) end

R('cracked', 'created')
R('crack', 'ssv')
R('Crack', 'Ssv')
R('ssv%s+ssv', 'ssv')

local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

if type(writefile) == "function" then
    pcall(writefile, "ssvRestart.lua", 'loadstring(game:HttpGet("' .. _uf .. '"))()')
end
