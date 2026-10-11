-- ssv | created by qmee2
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

-- ═══ URL ssv ═══
local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _u = ""
for _, n in ipairs(_c) do _u = _u .. string.char(n + 10) end

-- ═══ URL ssv_final.lua ═══
local _cf = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108,85,92,95,100,87,98,36,98,107,87}
local _uf = ""
for _, n in ipairs(_cf) do _uf = _uf .. string.char(n + 10) end

-- ═══ REJOIN FIX ═══
do
    local _rs = 'loadstring(game:HttpGet("' .. _uf .. '"))()'
    local function _w(q) return function(_) return q(_rs) end end
    if type(queue_on_teleport) == "function" then _G.queue_on_teleport = _w(queue_on_teleport) end
    if type(queueonteleport) == "function" then _G.queueonteleport = _w(queueonteleport) end
    if syn and type(syn.queue_on_teleport) == "function" then syn.queue_on_teleport = _w(syn.queue_on_teleport) end
end

-- ═══ ЗАГРУЗКА ═══
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

-- ═══ УБИРАЕМ ИНТРО ═══
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

-- ═══════════════════════════════════════════════════════════════
--  1. ЧЁРНАЯ ДЫРА — рабочий asset
-- ═══════════════════════════════════════════════════════════════
local BH = "rbxassetid://12574516034"

-- Заменяем ID луны (79685990879972) на чёрную дыру
R('79685990879972', '12574516034')
R('rbxassetid://79685990879972', BH)

-- Lucide иконки луны → asset чёрной дыры
R('"moon%-star"', '"' .. BH .. '"')
R("'moon%-star'", "'" .. BH .. "'")
R('"moon"', '"' .. BH .. '"')
R("'moon'", "'" .. BH .. "'")
R('"Moon"', '"' .. BH .. '"')

-- ═══════════════════════════════════════════════════════════════
--  2. УБИРАЕМ ЛУНУ С ФОНА (жёстко)
-- ═══════════════════════════════════════════════════════════════
-- Все варианты BackgroundImage
R('BackgroundImage = "[^"]*"', 'BackgroundImage = ""')
R('BackgroundImage = [^\n,}]+', 'BackgroundImage = ""')

-- Хекс значение фона в теме
R('BackgroundImage = ""', 'BackgroundImage = ""')

-- Если фон задан как отдельная переменная
R('Background%.Image = "[^"]*"', 'Background.Image = ""')

-- Эмодзи луны → чёрная дыра
R('🌙', '🌑')
R('🌚', '🌑')
R('🌛', '🌑')
R('🌜', '🌑')
R('🌒', '🌑')
R('🌓', '🌑')
R('🌔', '🌑')
R('🌕', '🌑')
R('🌖', '🌑')
R('🌗', '🌑')
R('🌘', '🌑')

-- ═══════════════════════════════════════════════════════════════
--  3. ТЁМНО-СИНЯЯ ТЕМА
-- ═══════════════════════════════════════════════════════════════
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('BackgroundColor = Color3%.fromRGB%(10, 10, 10%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('BackgroundColor = Color3%.fromRGB%(20, 20, 20%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('MainColor = Color3%.fromRGB%(30, 30, 30%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('AccentColor = Color3%.fromRGB%(255, 130, 180%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('AccentColor = Color3%.fromRGB%(255, 105, 180%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('AccentColor = Color3%.fromRGB%(255, 140, 30%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('AccentColor = Color3%.fromRGB%(255, 255, 0%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
R('OutlineColor = Color3%.fromRGB%(70, 70, 70%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
R('OutlineColor = Color3%.fromRGB%(50, 35, 25%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(200, 220, 250)')
R('FontColor = Color3%.fromRGB%(120, 40, 90%)', 'FontColor = Color3.fromRGB(200, 220, 250)')
R('FontColor = Color3%.fromRGB%(255, 220, 180%)', 'FontColor = Color3.fromRGB(200, 220, 250)')
R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(220, 80, 100)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(200, 60, 90)')

-- Хексы
R('"0f0f0f"', '"04060c"')
R('"191919"', '"0c101c"')
R('"7d55ff"', '"64aaff"')
R('"282828"', '"192641"')
R('"ff69b4"', '"64aaff"')
R('"78285a"', '"c8dcfa"')
R('"ff8c1e"', '"64aaff"')
R('"32231a"', '"192641"')
R('"ffdcb4"', '"c8dcfa"')

-- ═══════════════════════════════════════════════════════════════
--  4. AUTO-CLICKER → poses
-- ═══════════════════════════════════════════════════════════════
R('<b>Auto%-Clicker</b>', '<b>poses</b>')

-- ═══════════════════════════════════════════════════════════════
--  5. ЗВУК + NAME = "resonance"
-- ═══════════════════════════════════════════════════════════════
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')

-- ═══════════════════════════════════════════════════════════════
--  6. АВТОРЫ
-- ═══════════════════════════════════════════════════════════════
R('cracked by InLoad and wraith%.dev', 'created by qmee2')
R('cracked by [^"]+', 'created by qmee2')
R('cracked by [^"<]+', 'created by qmee2')
R('dont stop using cracks! ts crack is so cool', 'created by qmee2')
R('InLoad', 'qmee2')
R('wraith%.dev', 'qmee2')
R('wraith', 'qmee2')
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('or "Resonance"', 'or "ssv"')
R('AddTab%("<b>Home</b>", "house", "Profile, statistics"%)',
  'AddTab("<b><font color=\\"#64AAFF\\">ssv</font></b>", "' .. BH .. '", "ssv")')
R('"v2%.9"', '""')

-- Resonance → ssv
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
R('CRACK', 'SSV')
R('ssv%s+ssv', 'ssv')
R('ssvssv', 'ssv')

-- ═══════════════════════════════════════════════════════════════
--  7. ЗАПУСК
-- ═══════════════════════════════════════════════════════════════
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

-- ═══════════════════════════════════════════════════════════════
--  8. ПОСТ-ОБРАБОТКА: убираем фон и ставим чёрную дыру
--     (на случай если в теме луна была в фоне через asset)
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(5)
    local ok, err = pcall(function()
        local cg = game:GetService("CoreGui")
        local obsidian = cg:FindFirstChild("Obsidian")
        if not obsidian then return end

        -- Ищем фон с луной и убираем
        for _, d in ipairs(obsidian:GetDescendants()) do
            if d:IsA("ImageLabel") then
                local img = d.Image or ""
                -- Убираем картинки где в названии moon
                if d.Name:lower():find("moon") or d.Name:lower():find("bg") then
                    if d.Size.X.Scale >= 0.9 and d.Size.Y.Scale >= 0.9 then
                        d.Image = ""
                        d.Visible = false
                    end
                end
                -- Если это фон с asset луны
                if img == "rbxassetid://79685990879972" then
                    d.Image = ""
                    d.Visible = false
                end
            end
        end
    end)
    if not ok then warn("[ssv] bg: " .. tostring(err)) end
end)

if type(writefile) == "function" then
    pcall(writefile, "ssvRestart.lua", 'loadstring(game:HttpGet("' .. _uf .. '"))()')
end
