-- ssv | created by qmee2
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

-- ═══ URL (закодирован) ═══
local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _u = ""
for _, n in ipairs(_c) do _u = _u .. string.char(n + 10) end

local function _g(u)
    if type(request) == "function" then
        local ok, r = pcall(request, { Url = u, Method = "GET" })
        if ok and r and r.Body then return r.Body end
    end
    if type(http_request) == "function" then
        local ok, r = pcall(http_request, { Url = u })
        if ok and r and r.Body then return r.Body end
    end
    local ok, r = pcall(game.HttpGet, game, u, true)
    if ok and type(r) == "string" then return r end
end

local src = _g(_u)
if type(src) ~= "string" or #src < 100000 then error("[ssv] fail") end

-- ═══════════════════════════════════════════════════════════════
--  1. БЕЗОПАСНО УБИРАЕМ ИНТРО
--  Находим "function Intro.Play" и до "return Intro", заменяем тело
-- ═══════════════════════════════════════════════════════════════
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
--  2. AUTO-CLICKER → poses
-- ═══════════════════════════════════════════════════════════════
R('<b>Auto%-Clicker</b>', '<b>poses</b>')
R('"Auto%-Clicker"', '"poses"')

-- ═══════════════════════════════════════════════════════════════
--  3. НОВЫЙ ЗВУК + NAME = "resonance"
-- ═══════════════════════════════════════════════════════════════
R('n34 = 97643101798871', 'n34 = 18317665126')
R('97643101798871', '18317665126')
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')
R('"Player Kicked"', '"resonance"')

-- ═══════════════════════════════════════════════════════════════
--  4. АВТОРЫ И НАЗВАНИЯ
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
R('"Resonance", 79685990879972', '"ssv", 79685990879972')
R('or "Resonance"', 'or "ssv"')
R('AddTab%("<b>Home</b>", "house", "Profile, statistics"%)',
  'AddTab("<b><font color=\\"#64AAFF\\">ssv</font></b>", "moon-star", "ssv")')
R('Welcome to <b><font color=\\"#fffb00\\">ssv crack</font></b>', 'Welcome to <b>ssv</b>')
R('Welcome to <b>[^<]*</b>[^<]*', 'Welcome to <b>ssv</b>')
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
src = src:gsub("Project ssv", "ssv")
for k, nm in pairs(rs) do src = src:gsub(k, nm) end

-- ═══════════════════════════════════════════════════════════════
--  5. ТЁМНО-СИНЯЯ ТЕМА + УБИРАЕМ ВСЕ ИКОНКИ ЛУНЫ
-- ═══════════════════════════════════════════════════════════════
-- Убираем луну (заменим кастомной после запуска)
R('"moon%-star"', '""')
R("'moon%-star'", "''")
R('"moon"', '""')
R("'moon'", "''")

-- Тема
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(200, 220, 250)')
R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(220, 80, 100)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(200, 60, 90)')

-- Чистка crack
R('cracked', 'created')
R('crack', 'ssv')
R('Crack', 'Ssv')
R('CRACK', 'SSV')
R('ssv%s+ssv', 'ssv')
R('ssvssv', 'ssv')

-- ═══════════════════════════════════════════════════════════════
--  6. ЗАПУСК
-- ═══════════════════════════════════════════════════════════════
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

-- ═══════════════════════════════════════════════════════════════
--  7. КАСТОМНАЯ БЕЛАЯ ЛУНА + WATERMARK
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(5)
    local obsidian = game:GetService("CoreGui"):FindFirstChild("Obsidian")
    if not obsidian then return end

    local targets = {}
    for _, v in ipairs(obsidian:GetDescendants()) do
        if v:IsA("ImageLabel") and v.AbsoluteSize.X >= 12 and v.AbsoluteSize.X <= 30 then
            local anc = v
            local is_tab = false
            for _ = 1, 5 do
                if not anc.Parent then break end
                anc = anc.Parent
                if anc:IsA("TextButton") then is_tab = true break end
            end
            if is_tab then table.insert(targets, v) end
        end
    end
    table.sort(targets, function(a,b) return a.AbsolutePosition.Y < b.AbsolutePosition.Y end)

    if targets[1] then
        local old = targets[1]
        local parent = old.Parent
        if parent then
            old.Visible = false
            local h = Instance.new("Frame")
            h.Name = "SSV_Luna"
            h.Size = old.Size
            h.Position = old.Position
            h.AnchorPoint = old.AnchorPoint
            h.BackgroundTransparency = 1
            h.ZIndex = old.ZIndex
            h.Parent = parent

            local glow = Instance.new("ImageLabel")
            glow.Size = UDim2.fromScale(2.4, 2.4)
            glow.Position = UDim2.fromScale(0.5, 0.5)
            glow.AnchorPoint = Vector2.new(0.5, 0.5)
            glow.BackgroundTransparency = 1
            glow.Image = "rbxassetid://5028857472"
            glow.ImageColor3 = Color3.fromRGB(200, 220, 255)
            glow.ImageTransparency = 0.55
            glow.ZIndex = old.ZIndex
            glow.Parent = h

            local moon = Instance.new("Frame")
            moon.Size = UDim2.fromScale(0.9, 0.9)
            moon.Position = UDim2.fromScale(0.5, 0.5)
            moon.AnchorPoint = Vector2.new(0.5, 0.5)
            moon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            moon.BorderSizePixel = 0
            moon.ZIndex = old.ZIndex + 2
            moon.Parent = h
            Instance.new("UICorner", moon).CornerRadius = UDim.new(1, 0)

            local function crater(sz, px, py)
                local c = Instance.new("Frame")
                c.Size = UDim2.fromScale(sz, sz)
                c.Position = UDim2.fromScale(px, py)
                c.BackgroundColor3 = Color3.fromRGB(220, 230, 245)
                c.BorderSizePixel = 0
                c.ZIndex = moon.ZIndex + 1
                c.Parent = moon
                Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
            end
            crater(0.22, 0.25, 0.3)
            crater(0.14, 0.6, 0.5)
            crater(0.1, 0.4, 0.7)

            local cut = Instance.new("Frame")
            cut.Size = UDim2.fromScale(0.85, 0.85)
            cut.Position = UDim2.fromScale(0.62, -0.12)
            cut.AnchorPoint = Vector2.new(0.5, 0.5)
            cut.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
            cut.BorderSizePixel = 0
            cut.ZIndex = moon.ZIndex + 5
            cut.Parent = h
            Instance.new("UICorner", cut).CornerRadius = UDim.new(1, 0)

            task.spawn(function()
                while h.Parent do
                    glow.ImageTransparency = 0.5 + math.sin(tick() * 1.8) * 0.2
                    task.wait(0.05)
                end
            end)
        end
    end
end)

-- Watermark
task.spawn(function()
    task.wait(5.5)
    local wm = Instance.new("ScreenGui")
    wm.Name = "SSVWatermark"
    wm.ResetOnSpawn = false
    wm.DisplayOrder = 999999
    wm.Parent = game:GetService("CoreGui")

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 260, 0, 40)
    f.Position = UDim2.new(0, 20, 0, 20)
    f.BackgroundColor3 = Color3.fromRGB(4, 6, 12)
    f.BackgroundTransparency = 0.15
    f.BorderSizePixel = 0
    f.Parent = wm
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

    local st = Instance.new("UIStroke", f)
    st.Color = Color3.fromRGB(100, 170, 255)
    st.Thickness = 1.5
    st.Transparency = 0.2

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = "ssv | created by qmee2"
    l.TextColor3 = Color3.fromRGB(200, 220, 250)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    task.spawn(function()
        local hue = 0
        while f.Parent do
            hue = (hue + 0.005) % 1
            local col = Color3.fromHSV(hue, 0.7, 1)
            st.Color = col
            l.TextColor3 = Color3.fromRGB(200, 220, 250):Lerp(col, 0.3)
            task.wait(0.03)
        end
    end)
end)
