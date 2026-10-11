-- ssv | created by qmee2
-- ВЕРНУЛ ВСЕ ПАТЧИ + защита от краша
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

-- ═══ ВАЛИДАЦИЯ ═══
if type(src) ~= "string" then error("[ssv] не строка") end
if #src < 100000 then error("[ssv] слишком мало: " .. #src) end
if src:find("_c = {94", 1, true) then error("[ssv] URL ведёт на патчер!") end

-- ═══ УБИРАЕМ ИНТРО ═══
do
    local s1 = src:find('function Intro.Play', 1, true)
    if s1 then
        local e1 = src:find('return Intro', s1, true)
        if e1 then
            local new = src:sub(1, s1 - 1) .. 'function Intro.Play() return true end\n' .. src:sub(e1)
            if type(new) == "string" then src = new end
        end
    end
end

-- ═══ ЗАЩИЩЁННЫЙ ПАТЧ ═══
local function R(p, r)
    local ok, new = pcall(function() return src:gsub(p, r) end)
    if ok and type(new) == "string" then src = new end
end

-- ═══════════════════════════════════════════════════════════════
--  1. ЛУНА ВЕЗДЕ
-- ═══════════════════════════════════════════════════════════════
R('"moon%-star"', '""')
R("'moon%-star'", "''")
R('"moon"', '""')
R("'moon'", "''")
R('"Moon"', '""')
R('BackgroundImage = "[^"]*[Mm]oon[^"]*"', 'BackgroundImage = ""')

-- Эмодзи луны (через unicode escapes, безопасно)
R('\240\159\140\153', '')  -- 🌙
R('\240\159\140\154', '')  -- 🌚
R('\240\159\140\155', '')  -- 🌛
R('\240\159\140\156', '')  -- 🌜
R('\240\159\140\146', '')  -- 🌒
R('\240\159\140\147', '')  -- 🌓
R('\240\159\140\148', '')  -- 🌔
R('\240\159\140\149', '')  -- 🌕
R('\240\159\140\150', '')  -- 🌖
R('\240\159\140\151', '')  -- 🌗
R('\240\159\140\152', '')  -- 🌘

-- ═══════════════════════════════════════════════════════════════
--  2. ЧЁРНЫЙ ФОН + ОРАНЖЕВЫЙ АКЦЕНТ + БЕЛЫЙ ТЕКСТ
-- ═══════════════════════════════════════════════════════════════
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(10, 10, 10%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(20, 20, 20%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(4, 6, 12%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')

R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
R('MainColor = Color3%.fromRGB%(30, 30, 30%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
R('MainColor = Color3%.fromRGB%(12, 16, 28%)', 'MainColor = Color3.fromRGB(8, 8, 8)')

R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 130, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 105, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(100, 170, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(240, 160, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 255, 0%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')

R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(40, 40, 40)')
R('OutlineColor = Color3%.fromRGB%(70, 70, 70%)', 'OutlineColor = Color3.fromRGB(40, 40, 40)')
R('OutlineColor = Color3%.fromRGB%(25, 38, 65%)', 'OutlineColor = Color3.fromRGB(40, 40, 40)')

R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(120, 40, 90%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(140, 80, 100%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(200, 220, 250%)', 'FontColor = Color3.fromRGB(255, 255, 255)')

R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(255, 100, 60)')
R('RedColor = Color3%.fromRGB%(220, 80, 100%)', 'RedColor = Color3.fromRGB(255, 100, 60)')
R('RedColor = Color3%.fromRGB%(230, 60, 120%)', 'RedColor = Color3.fromRGB(255, 100, 60)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(255, 80, 40)')
R('DestructiveColor = Color3%.fromRGB%(200, 60, 90%)', 'DestructiveColor = Color3.fromRGB(255, 80, 40)')

-- Хексы
R('"0f0f0f"', '"000000"')
R('"191919"', '"080808"')
R('"7d55ff"', '"ff8c1e"')
R('"64aaff"', '"ff8c1e"')
R('"ff69b4"', '"ff8c1e"')
R('"78285a"', '"ffffff"')
R('"dcebff"', '"ffffff"')

-- ═══════════════════════════════════════════════════════════════
--  3. AUTO-CLICKER → poses
-- ═══════════════════════════════════════════════════════════════
R('<b>Auto%-Clicker</b>', '<b>poses</b>')
R('"Auto%-Clicker"', '"poses"')

-- ═══════════════════════════════════════════════════════════════
--  4. ЗВУК + NAME = "resonance"
-- ═══════════════════════════════════════════════════════════════
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')

-- ═══════════════════════════════════════════════════════════════
--  5. АВТОРЫ
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
  'AddTab("<b><font color=\\"#FF8C1E\\">ssv</font></b>", "", "ssv")')
R('"v2%.9"', '""')

-- Resonance → ssv (защита служебных)
local pr = {"ResonanceRunning","ResonanceStarting","ResonanceOriginalFallenHeight","ResonanceRestored","ResonanceIntro"}
local rs = {}
for i, nm in ipairs(pr) do
    local k = "__S"..i.."__"
    src = src:gsub(nm, k)
    rs[k] = nm
end
src = src:gsub("Resonance", "ssv")
src = src:gsub("RESONANCE", "SSV")
for k, nm in pairs(rs) do src = src:gsub(k, nm) end

R('cracked', 'created')
R('crack', 'ssv')
R('Crack', 'Ssv')
R('CRACK', 'SSV')

-- ═══════════════════════════════════════════════════════════════
--  ВАЛИДАЦИЯ РЕЗУЛЬТАТА
-- ═══════════════════════════════════════════════════════════════
if type(src) ~= "string" then error("[ssv] патч сломал строку") end

-- ═══════════════════════════════════════════════════════════════
--  ЗАПУСК (с проверкой компиляции)
-- ═══════════════════════════════════════════════════════════════
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then
    warn("[ssv] compile error: " .. tostring(cerr))
    -- Пробуем запустить без патчей
    local ok2, chunk2 = pcall(function() return loadstring(_g(_u), "@ssv_raw") end)
    if ok2 and chunk2 then
        warn("[ssv] запускаю без патчей")
        chunk = chunk2
    else
        error("[ssv] не компилируется: " .. tostring(cerr), 0)
    end
end

local rok, rerr = pcall(chunk)
if not rok then
    warn("[ssv] run error: " .. tostring(rerr))
    error(tostring(rerr), 0)
end

-- ═══════════════════════════════════════════════════════════════
--  ПОСТ-ОБРАБОТКА: убираем фон с луной
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(6)
    pcall(function()
        local cg = game:GetService("CoreGui")
        local obsidian = cg:FindFirstChild("Obsidian")
        if not obsidian then return end
        for _, d in ipairs(obsidian:GetDescendants()) do
            if d:IsA("ImageLabel") then
                local img = tostring(d.Image or "")
                if img:find("79685", 1, true) then
                    d.Image = ""
                    d.Visible = false
                end
            end
        end
    end)
end)

if type(writefile) == "function" then
    pcall(writefile, "ssvRestart.lua", 'loadstring(game:HttpGet("' .. _uf .. '"))()')
end
