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

-- Убираем интро
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
--  1. ЧЁРНАЯ ДЫРА (рабочий asset)
-- ═══════════════════════════════════════════════════════════════
local BH = "rbxassetid://131961136048924"  -- Saggitarius A* — рабочая

R('79685990879972', '131961136048924')
R('rbxassetid://79685990879972', BH)
R('"moon%-star"', '"' .. BH .. '"')
R("'moon%-star'", "'" .. BH .. "'")
R('"moon"', '"' .. BH .. '"')
R("'moon'", "'" .. BH .. "'")
R('"Moon"', '"' .. BH .. '"')

-- ═══════════════════════════════════════════════════════════════
--  2. УБИРАЕМ ЛУНУ С ФОНА ЖЁСТКО
-- ═══════════════════════════════════════════════════════════════
R('BackgroundImage = "[^"]*"', 'BackgroundImage = ""')
R('BackgroundImage = [^,}\n]+', 'BackgroundImage = ""')
R('Background%.Image = "[^"]*"', 'Background.Image = ""')

-- Эмодзи луны
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
--  3. ЧЁРНЫЙ ФОН + ОРАНЖЕВО-БЕЛЫЕ ПОЛЗУНКИ
-- ═══════════════════════════════════════════════════════════════
-- Основные цвета — чёрный фон
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(10, 10, 10%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(20, 20, 20%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(4, 6, 12%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
R('MainColor = Color3%.fromRGB%(30, 30, 30%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
R('MainColor = Color3%.fromRGB%(12, 16, 28%)', 'MainColor = Color3.fromRGB(8, 8, 8)')

-- Акцент (ползунки) — оранжевый
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 130, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 105, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(100, 170, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 255, 0%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')

-- Обводка — светло-серый
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(40, 40, 40)')
R('OutlineColor = Color3%.fromRGB%(70, 70, 70%)', 'OutlineColor = Color3.fromRGB(40, 40, 40)')
R('OutlineColor = Color3%.fromRGB%(25, 38, 65%)', 'OutlineColor = Color3.fromRGB(40, 40, 40)')

-- Текст — белый
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(120, 40, 90%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(140, 80, 100%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(200, 220, 250%)', 'FontColor = Color3.fromRGB(255, 255, 255)')

-- Красный — оранжево-красный
R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(255, 100, 60)')
R('RedColor = Color3%.fromRGB%(230, 60, 120%)', 'RedColor = Color3.fromRGB(255, 100, 60)')
R('RedColor = Color3%.fromRGB%(220, 80, 100%)', 'RedColor = Color3.fromRGB(255, 100, 60)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(255, 80, 40)')
R('DestructiveColor = Color3%.fromRGB%(220, 50, 110%)', 'DestructiveColor = Color3.fromRGB(255, 80, 40)')
R('DestructiveColor = Color3%.fromRGB%(200, 60, 90%)', 'DestructiveColor = Color3.fromRGB(255, 80, 40)')

-- Хексы
R('"0f0f0f"', '"000000"')
R('"191919"', '"080808"')
R('"04060c"', '"000000"')
R('"0c101c"', '"080808"')
R('"7d55ff"', '"ff8c1e"')
R('"64aaff"', '"ff8c1e"')
R('"282828"', '"282828"')
R('"192641"', '"282828"')
R('"ff69b4"', '"ff8c1e"')
R('"78285a"', '"ffffff"')
R('"c8dcfa"', '"ffffff"')
R('"dcebff"', '"ffffff"')

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
  'AddTab("<b><font color=\\"#FF8C1E\\">ssv</font></b>", "' .. BH .. '", "ssv")')
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

-- ЗАПУСК
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

-- ═══════════════════════════════════════════════════════════════
--  7. ПОСТ-ОБРАБОТКА — убираем луну с фона реально
--     Сканируем всё что есть и удаляем любой фон с луной
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(6)
    pcall(function()
        local cg = game:GetService("CoreGui")
        local obsidian = cg:FindFirstChild("Obsidian")
        if not obsidian then return end

        -- Ищем фон с луной и удаляем
        local moonAssets = {
            "79685990879972",
            "rbxassetid://79685990879972",
        }

        for _, d in ipairs(obsidian:GetDescendants()) do
            if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                local img = tostring(d.Image or "")
                
                -- Убираем любой фон с asset луны
                for _, mid in ipairs(moonAssets) do
                    if img:find(mid, 1, true) then
                        d.Image = ""
                        d.Visible = false
                        d.BackgroundTransparency = 1
                    end
                end
                
                -- Убираем декоративные фоны (большие, мало прозрачные)
                if d.Name:lower():find("bg") or d.Name:lower():find("background") then
                    if d.Size.X.Scale >= 0.85 and d.Size.Y.Scale >= 0.85 then
                        if d.ImageTransparency < 0.9 then
                            d.Image = ""
                            d.Visible = false
                        end
                    end
                end
            end
        end
    end)
end)

if type(writefile) == "function" then
    pcall(writefile, "ssvRestart.lua", 'loadstring(game:HttpGet("' .. _uf .. '"))()')
end
