-- ═══════════════════════════════════════════════════════════════
--  ЗАЧИСТКА: удаляем ЛУНУ и ФОН из Obsidian
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    -- Ждём пока окно построится
    task.wait(5)
    
    -- Убираем картинки с asset луны И большой фон
    local function clean()
        pcall(function()
            local cg = game:GetService("CoreGui")
            local obs = cg:FindFirstChild("Obsidian")
            if not obs then return end
            
            local moon_id = "79685990879972"
            
            for _, d in ipairs(obs:GetDescendants()) do
                if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                    local img = tostring(d.Image or "")
                    
                    -- 1. Убираем ЛУНУ (asset 79685990879972)
                    if img:find(moon_id, 1, true) then
                        d.Image = ""
                        d.Visible = false
                        d.ImageTransparency = 1
                    end
                    
                    -- 2. Убираем БОЛЬШОЙ ФОН (1505x719 или любой >1000px)
                    local sz = d.AbsoluteSize
                    if sz.X > 1000 or sz.Y > 500 then
                        d.Image = ""
                        d.Visible = false
                        d.ImageTransparency = 1
                        d.BackgroundTransparency = 1
                    end
                    
                    -- 3. Убираем фон окна (Obsidian.ImageLabel — прямой ребёнок)
                    if d.Parent == obs and d.Name == "ImageLabel" then
                        d.Image = ""
                        d.Visible = false
                        d.ImageTransparency = 1
                        d.BackgroundTransparency = 1
                    end
                end
            end
            
            -- Чистим тексты от повторов qmee2 и ssv
            for _, d in ipairs(obs:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                    local t = tostring(d.Text or "")
                    if t:find("qmee2") or t:find("ssv") then
                        local new = t
                        local i = 0
                        while i < 15 do
                            i = i + 1
                            local nn = new:gsub("qmee2[%s%p]+qmee2", "qmee2")
                                          :gsub("qmee2qmee2", "qmee2")
                                          :gsub("ssv[%s%p]+ssv", "ssv")
                                          :gsub("ssvssv", "ssv")
                            if nn == new then break end
                            new = nn
                        end
                        if new ~= t then d.Text = new end
                    end
                end
            end
        end)
    end
    
    -- Чистим сразу и через 3 секунды повторно (на случай перестройки UI)
    clean()
    task.wait(3)
    clean()
    task.wait(5)
    clean()
end)-- ssv | created by qmee2
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

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
    local ok, new = pcall(function() return src:gsub(p, r) end)
    if ok and type(new) == "string" then src = new end
end

-- ═══════════════════════════════════════════════════════════════
--  УДАЛЯЕМ ЛУНУ АБСОЛЮТНО ВЕЗДЕ
-- ═══════════════════════════════════════════════════════════════

-- 1. Roblox asset ID луны
R('79685990879972', '0')

-- 2. Убираем ЛЮБОЕ слово moon в любом регистре (включая moon-star, MoonStar)
local ok, new = pcall(function()
    return src:gsub('[Mm][Oo][Oo][Nn]', '')
end)
if ok and type(new) == "string" then src = new end

-- 3. Luna
R('[Ll][Uu][Nn][Aa]', '')

-- 4. Все эмодзи луны через сырые байты UTF-8
local EMOJI = {
    "\240\159\140\145", -- 🌑
    "\240\159\140\146", -- 🌒
    "\240\159\140\147", -- 🌓
    "\240\159\140\148", -- 🌔
    "\240\159\140\149", -- 🌕
    "\240\159\140\150", -- 🌖
    "\240\159\140\151", -- 🌗
    "\240\159\140\152", -- 🌘
    "\240\159\140\153", -- 🌙
    "\240\159\140\154", -- 🌚
    "\240\159\140\155", -- 🌛
    "\240\159\140\156", -- 🌜
    "\240\159\140\157", -- 🌝
    "\240\159\140\158", -- 🌞
}
for _, e in ipairs(EMOJI) do
    R(e, '')
end

-- 5. Любой BackgroundImage → пусто (если он содержит moon - уже удалён, но на всякий)
-- Работаем через функцию: убираем ТОЛЬКО если там что-то есть
local ok_bg, new_bg = pcall(function()
    return src:gsub('BackgroundImage%s*=%s*"[^"]+"', 'BackgroundImage = ""')
end)
if ok_bg and type(new_bg) == "string" then src = new_bg end

local ok_bg2, new_bg2 = pcall(function()
    return src:gsub("BackgroundImage%s*=%s*'[^']+'", "BackgroundImage = ''")
end)
if ok_bg2 and type(new_bg2) == "string" then src = new_bg2 end

-- ═══════════════════════════════════════════════════════════════
--  УДАЛЯЕМ ВСЕ ПОВТОРЫ qmee2 и ssv (ЦИКЛОМ, пока не исчезнут)
-- ═══════════════════════════════════════════════════════════════

-- Функция схлопывания повторов через цикл
local function collapse(text, word)
    local max_iter = 20
    local i = 0
    while i < max_iter do
        i = i + 1
        local ok1, new1 = pcall(function()
            -- слово + любые разделители + то же слово → одно слово
            return text:gsub(word .. "[%s%p]+" .. word, word)
        end)
        if ok1 and type(new1) == "string" and new1 ~= text then
            text = new1
        else
            break
        end
    end
    -- Двойное без разделителя (qmee2qmee2 → qmee2)
    local ok2, new2 = pcall(function()
        return text:gsub(word .. word, word)
    end)
    if ok2 and type(new2) == "string" then text = new2 end
    return text
end

src = collapse(src, "qmee2")
src = collapse(src, "ssv")

-- Отдельно: "created by qmee2 and qmee2" → "created by qmee2"
R('created by qmee2 and qmee2', 'created by qmee2')
R('by qmee2 and qmee2', 'by qmee2')

-- "by X qmee2" — убираем хвост
R('by qmee2%s+qmee2', 'by qmee2')

-- ═══════════════════════════════════════════════════════════════
--  ТЕМА: чёрный фон + оранжевый + белый
-- ═══════════════════════════════════════════════════════════════
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(10, 10, 10%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(20, 20, 20%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
R('MainColor = Color3%.fromRGB%(30, 30, 30%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 130, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 105, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(100, 170, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 255, 0%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(120, 40, 90%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(140, 80, 100%)', 'FontColor = Color3.fromRGB(255, 255, 255)')

-- Auto-Clicker → poses
R('<b>Auto%-Clicker</b>', '<b>poses</b>')

-- Звук
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')

-- Авторы
R('cracked by InLoad and wraith%.dev', 'created by qmee2')
R('cracked by [^"]+', 'created by qmee2')
R('cracked by [^"<]+', 'created by qmee2')
R('InLoad', 'qmee2')
R('wraith%.dev', 'qmee2')
R('wraith', 'qmee2')
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('or "Resonance"', 'or "ssv"')
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

-- Финальная зачистка дублей
src = collapse(src, "qmee2")
src = collapse(src, "ssv")

-- ЗАПУСК
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

-- ═══════════════════════════════════════════════════════════════
--  ПОСТ-ОБРАБОТКА — чистим UI от луны и повторов в рантайме
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(5)
    pcall(function()
        local cg = game:GetService("CoreGui")
        local obsidian = cg:FindFirstChild("Obsidian")
        if not obsidian then return end

        for _, d in ipairs(obsidian:GetDescendants()) do
            -- Image с луной
            if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                local img = tostring(d.Image or "")
                if img:find("79685", 1, true) or img:find("moon", 1, true) or img:find("Moon", 1, true) or img:find("luna", 1, true) then
                    d.Image = ""
                    d.Visible = false
                end
            end
            -- Текст с эмодзи луны
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = tostring(d.Text or "")
                for _, e in ipairs({"🌙","🌚","🌛","🌜","🌑","🌒","🌓","🌔","🌕","🌖","🌗","🌘","🌝","🌞"}) do
                    if t:find(e, 1, true) then
                        d.Text = t:gsub(e, "")
                        t = d.Text
                    end
                end
                -- Убираем повторы qmee2 в тексте
                local new = t
                local iter = 0
                while iter < 20 do
                    iter = iter + 1
                    local nn = new:gsub("qmee2[%s%p]+qmee2", "qmee2"):gsub("qmee2qmee2", "qmee2")
                    if nn == new then break end
                    new = nn
                end
                local iter2 = 0
                while iter2 < 20 do
                    iter2 = iter2 + 1
                    local nn = new:gsub("ssv[%s%p]+ssv", "ssv"):gsub("ssvssv", "ssv")
                    if nn == new then break end
                    new = nn
                end
                if new ~= t then d.Text = new end
            end
        end
    end)
end)

if type(writefile) == "function" then
    pcall(writefile, "ssvRestart.lua", 'loadstring(game:HttpGet("' .. _uf .. '"))()')
end
