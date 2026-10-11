-- ssv | created by qmee2
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

-- ═══ URL оригинала (закодирован) ═══
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

local function R(p, r) local ok, n = pcall(function() return src:gsub(p, r) end) if ok then src = n end end

-- ═══════════════════════════════════════════════════════════════
--  1. УБИРАЕМ ИНТРО
-- ═══════════════════════════════════════════════════════════════
R([[
local introOk, introError = pcall(function()
        local played, message = requireModule("Intro").Play()
        assert(played, message)
    end)
    if not introOk then warn("ssv intro: " .. tostring(introError)) end]], "-- intro removed")
R([[
local introOk, introError = pcall(function()
        local played, message = requireModule("Intro").Play()
        assert(played, message)
    end)
    if not introOk then warn("Resonance intro: " .. tostring(introError)) end]], "-- intro removed")
R('Intro%.Play%(%)', 'function() return true end')

-- ═══════════════════════════════════════════════════════════════
--  2. AUTO-CLICKER → poses
-- ═══════════════════════════════════════════════════════════════
R('<b>Auto%-Clicker</b>', '<b>poses</b>')
R('"Auto%-Clicker"', '"poses"')
R('AutoClicker = v19:AddTab', 'AutoClicker = v19:AddTab')

-- ═══════════════════════════════════════════════════════════════
--  3. НОВЫЙ ЗВУК + НАЗВАНИЕ "resonance"
-- ═══════════════════════════════════════════════════════════════
-- Меняем звук кика (default SoundId)
R('n34 = 97643101798871', 'n34 = 18317665126')
R('97643101798871', '18317665126')

-- Добавляем Name = "resonance" к Sound уведомлений
R('SoundId = SoundId,\n%s*Volume = tonumber%(Data%.Volume%) or 3,',
  'SoundId = SoundId,\n\t\t\tName = "resonance",\n\t\t\tVolume = tonumber(Data.Volume) or 3,')

-- Меняем название уведомления о кике на "resonance"
R('"Player Kicked"', '"resonance"')
R('"Player Left"', '"resonance"')

-- Меняем заголовок уведомлений по умолчанию
R('Title = arg2 or "ssv"', 'Title = arg2 or "resonance"')

-- ═══════════════════════════════════════════════════════════════
--  4. УБИРАЕМ ИКОНКУ ЛУНЫ (заменим позже на свою)
-- ═══════════════════════════════════════════════════════════════
R('"moon%-star"', '"__SSV_CUSTOM_MOON__"')
R("'moon%-star'", "'__SSV_CUSTOM_MOON__'")
R('"moon"', '"__SSV_CUSTOM_MOON__"')
R("'moon'", "'__SSV_CUSTOM_MOON__'")

-- ═══════════════════════════════════════════════════════════════
--  5. СТАНДАРТНЫЕ ПАТЧИ (авторы, тема)
-- ═══════════════════════════════════════════════════════════════
R('cracked by InLoad and wraith%.dev', 'created by qmee2 💙')
R('cracked by [^"]+', 'created by qmee2 💙')
R('cracked by [^"<]+', 'created by qmee2 💙')
R('dont stop using cracks! ts crack is so cool', '💙')
R('InLoad', 'qmee2')
R('wraith%.dev', 'qmee2')
R('wraith', 'qmee2')
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('"Resonance", 79685990879972', '"ssv", 79685990879972')
R('or "Resonance"', 'or "ssv"')
R('AddTab%("<b>Home</b>", "house", "Profile, statistics"%)',
  'AddTab("<b><font color=\\"#64AAFF\\">ssv</font></b>", "__SSV_CUSTOM_MOON__", "ssv")')
R('Welcome to <b><font color=\\"#fffb00\\">ssv crack</font></b>', 'Welcome to <b>ssv</b> 💙')
R('Welcome to <b>[^<]*</b>[^<]*', 'Welcome to <b>ssv</b> 💙')
R('"v2%.9"', '""')

-- Resonance → ssv (защита служебных)
local pr = {"ResonanceRunning","ResonanceStarting","ResonanceOriginalFallenHeight","ResonanceRestored","ResonanceIntro"}
local rs = {}
for i, nm in ipairs(pr) do local k = "__S"..i.."__" src = src:gsub(nm, k) rs[k] = nm end
src = src:gsub("Resonance", "ssv")
src = src:gsub("RESONANCE", "SSV")
src = src:gsub("Project ssv", "ssv")
for k, nm in pairs(rs) do src = src:gsub(k, nm) end

-- Тема
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(200, 220, 250)')
R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(220, 80, 100)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(200, 60, 90)')

-- crack
R('cracked', 'created')
R('crack', 'ssv')
R('Crack', 'Ssv')
R('CRACK', 'SSV')
R('ssv%s+ssv', 'ssv')
R('ssvssv', 'ssv')

-- ═══ ГЛУШИМ PRINT/WARN ═══
src = src:gsub("print%s*%(", "_ssv_sp(")
src = src:gsub("warn%s*%(", "_ssv_sp(")

local _rp = print
local _rw = warn
local _re = error
local function _silent() end
local function _silent_err(m) return m end

_G._ssv_sp = _silent
_G.print = _silent
_G.warn = _silent

-- ═══ ЗАПУСК ═══
local _ok, _err = pcall(function()
    local chunk, cerr = loadstring(src, "@ssv")
    if not chunk then _re("[ssv] " .. tostring(cerr), 0) end
    local rok, rerr = pcall(chunk)
    if not rok then _re("[ssv] " .. tostring(rerr), 0) end
end)

_G.print = _rp
_G.warn = _rw
_G._ssv_sp = nil

if not _ok then _re("[ssv] " .. tostring(_err), 0) end

-- ═══════════════════════════════════════════════════════════════
--  6. КАСТОМНАЯ БЕЛАЯ ЛУНА (замена после загрузки UI)
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(4)
    local coreGui = game:GetService("CoreGui")
    local obsidian = coreGui:FindFirstChild("Obsidian")
    if not obsidian then return end
    
    -- Находим все ImageLabel с иконками вкладок (обычно 16-24 пикселя)
    local icons = {}
    for _, v in ipairs(obsidian:GetDescendants()) do
        if v:IsA("ImageLabel") 
           and v.AbsoluteSize.X >= 12 and v.AbsoluteSize.X <= 28
           and v.AbsoluteSize.Y >= 12 and v.AbsoluteSize.Y <= 28
           and v.Image ~= "" then
            table.insert(icons, v)
        end
    end
    
    -- Сортируем по Y — верхняя это Home/ssv
    table.sort(icons, function(a, b) 
        return a.AbsolutePosition.Y < b.AbsolutePosition.Y 
    end)
    
    -- Первую (Home) заменяем на нашу красивую луну
    if icons[1] then
        local old = icons[1]
        local parent = old.Parent
        if not parent then return end
        
        old.Visible = false
        
        -- Контейнер для луны
        local holder = Instance.new("Frame")
        holder.Name = "SSV_LunaWhite"
        holder.Size = old.Size
        holder.Position = old.Position
        holder.AnchorPoint = old.AnchorPoint
        holder.BackgroundTransparency = 1
        holder.ZIndex = old.ZIndex
        holder.Parent = parent
        
        -- Луна (белый круг)
        local moon = Instance.new("Frame")
        moon.Size = UDim2.fromScale(1, 1)
        moon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        moon.BorderSizePixel = 0
        moon.Parent = holder
        
        local corner1 = Instance.new("UICorner")
        corner1.CornerRadius = UDim.new(1, 0)
        corner1.Parent = moon
        
        -- Мягкое свечение луны
        local glow = Instance.new("ImageLabel")
        glow.Size = UDim2.fromScale(2.5, 2.5)
        glow.Position = UDim2.fromScale(0.5, 0.5)
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://5028857472"
        glow.ImageColor3 = Color3.fromRGB(200, 220, 255)
        glow.ImageTransparency = 0.6
        glow.ZIndex = moon.ZIndex - 1
        glow.Parent = holder
        
        local corner2 = Instance.new("UICorner")
        corner2.CornerRadius = UDim.new(1, 0)
        corner2.Parent = glow
        
        -- Вырезающий круг (создаёт форму полумесяца)
        local cut = Instance.new("Frame")
        cut.Size = UDim2.fromScale(0.85, 0.85)
        cut.Position = UDim2.fromScale(0.4, -0.05)
        cut.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
        cut.BorderSizePixel = 0
        cut.ZIndex = moon.ZIndex + 1
        cut.Parent = holder
        
        local corner3 = Instance.new("UICorner")
        corner3.CornerRadius = UDim.new(1, 0)
        corner3.Parent = cut
        
        -- Лёгкая анимация мерцания
        task.spawn(function()
            while holder.Parent do
                local t = tick()
                local alpha = 0.7 + math.sin(t * 2) * 0.15
                glow.ImageTransparency = alpha
                task.wait(0.03)
            end
        end)
    end
    
    -- Также заменяем все остальные иконки с "SSV_CUSTOM_MOON" если они где-то ещё
    for _, v in ipairs(obsidian:GetDescendants()) do
        if v:IsA("ImageLabel") and v.Visible then
            local p = v.Parent
            if p and p.Name == "SSV_CUSTOM_MOON" then
                v.Visible = false
            end
        end
    end
end)

-- ═══ ЕДИНЫЙ WATERMARK ═══
task.spawn(function()
    task.wait(5)
    local wm = Instance.new("ScreenGui")
    wm.Name = "SSVWatermark"
    wm.ResetOnSpawn = false
    wm.DisplayOrder = 999999
    wm.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 40)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(4, 6, 12)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = wm

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 170, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "ssv 🌙 created by qmee2"
    label.TextColor3 = Color3.fromRGB(200, 220, 250)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    task.spawn(function()
        local hue = 0
        while frame.Parent do
            hue = (hue + 0.005) % 1
            local col = Color3.fromHSV(hue, 0.7, 1)
            stroke.Color = col
            label.TextColor3 = Color3.fromRGB(200, 220, 250):Lerp(col, 0.3)
            task.wait(0.03)
        end
    end)
end)
