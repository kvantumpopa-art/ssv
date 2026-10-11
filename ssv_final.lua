-- ═══════════════════════════════════════════════════════════════
--  ssv_final.lua — загрузчик + патчер
--  ЗАЛЕЙ ЭТО НА GITHUB как ssv_final.lua (в ветку master)
-- ═══════════════════════════════════════════════════════════════

local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

-- ═══ URL ОРИГИНАЛА RESONANCE (без .lua, скрыт) ═══
-- Расшифровка: https://raw.githubusercontent.com/kvantumpopa-art/ssv/refs/heads/master/ssv
local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _url = ""
for _, n in ipairs(_c) do _url = _url .. string.char(n + 10) end

-- ═══ ЗАГРУЗКА ═══
local function _get(u)
    if type(request) == "function" then
        local ok, r = pcall(request, { Url = u, Method = "GET" })
        if ok and r and r.Body then return r.Body end
    end
    if type(http_request) == "function" then
        local ok, r = pcall(http_request, { Url = u })
        if ok and r and r.Body then return r.Body end
    end
    if type(http) == "table" and type(http.get) == "function" then
        local ok, r = pcall(http.get, u)
        if ok and r and r.Body then return r.Body end
    end
    if type(game.HttpGet) == "function" then
        local ok, r = pcall(game.HttpGet, game, u, true)
        if ok and type(r) == "string" then return r end
    end
    return nil
end

print("[ssv] Загрузка оригинала...")
local src = _get(_url)

if type(src) ~= "string" then
    error("[ssv] Загрузка не удалась — проверь что файл 'ssv' есть в репозитории (без .lua)")
end

print("[ssv] Получено " .. #src .. " байт")

-- ═══ ЗАЩИТА ОТ ЗАЦИКЛИВАНИЯ ═══
-- Если скачанный файл сам является патчером (а не оригиналом) — ошибка
if src:find("ssv_final", 1, true) and src:find("_c = {94", 1, true) then
    error("[ssv] ОШИБКА: URL ведёт на патчер, а не на оригинал Resonance! " ..
          "Проверь что файл 'ssv' в репозитории — это ОРИГИНАЛ, а 'ssv_final.lua' — это патчер.")
end

if #src < 100000 then
    error("[ssv] Файл слишком маленький (" .. #src .. " байт). " ..
          "Оригинал Resonance ~1.3 МБ. Проверь URL.")
end

-- ═══ ПАТЧИ ═══
local applied, failed = 0, 0

local function R(pat, rep)
    local ok, new, n = pcall(function() return src:gsub(pat, rep) end)
    if ok and n and n > 0 then
        src = new
        applied = applied + 1
    else
        failed = failed + 1
    end
end

-- Авторы (сначала длинные фразы, потом короткие)
R('cracked by InLoad and wraith%.dev', 'created by qmee2 💙')
R('cracked by: InLoad and <font color=\\"#baa4ff\\">wraith%.dev</font>', 'created by qmee2 💙')
R('cracked by [^"]+', 'created by qmee2 💙')
R('cracked by [^"<]+', 'created by qmee2 💙')
R('dont stop using cracks! ts crack is so cool', '💙')
R('InLoad', 'qmee2')
R('wraith%.dev', 'qmee2')
R('wraith', 'qmee2')

-- Заголовки
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('"Resonance", 79685990879972', '"ssv", 79685990879972')
R('or "Resonance"', 'or "ssv"')

-- Home
R('AddTab%("<b>Home</b>", "house", "Profile, statistics"%)',
  'AddTab("<b><font color=\\"#64AAFF\\">ssv</font></b>", "moon", "ssv")')
R('Welcome to <b><font color=\\"#fffb00\\">ssv crack</font></b>', 'Welcome to <b>ssv</b> 💙')
R('Welcome to <b>[^<]*</b>[^<]*', 'Welcome to <b>ssv</b> 💙')

-- Версия
R('"v2%.9"', '""')

-- Resonance → ssv (защита служебных)
local prot = {"ResonanceRunning","ResonanceStarting","ResonanceOriginalFallenHeight","ResonanceRestored","ResonanceIntro"}
local rs = {}
for i, nm in ipairs(prot) do
    local k = "__SSVP" .. i .. "__"
    src = src:gsub(nm, k)
    rs[k] = nm
end
src = src:gsub("Resonance", "ssv")
src = src:gsub("RESONANCE", "SSV")
src = src:gsub("Project ssv", "ssv")
for k, nm in pairs(rs) do
    src = src:gsub(k, nm)
end

-- Луна тёмная
R('"moon%-star"', '"moon"')
R('ImageColor3 = Icon%.Custom and "WhiteColor" or "AccentColor"', 'ImageColor3 = Color3.fromRGB(30, 60, 130)')
R('ImageColor3 = BoxIcon%.Custom and "WhiteColor" or "AccentColor"', 'ImageColor3 = Color3.fromRGB(30, 60, 130)')
R('ImageColor3 = "WhiteColor"', 'ImageColor3 = Color3.fromRGB(30, 60, 130)')
R('ImageColor3 = "FontColor"', 'ImageColor3 = Color3.fromRGB(30, 60, 130)')
R('IconColor = Color3%.new%(1, 1, 1%)', 'IconColor = Color3.fromRGB(30, 60, 130)')
R('Color3%.fromRGB%(255, 255, 0%)', 'Color3.fromRGB(100, 170, 255)')
R('Color3%.fromRGB%(255, 170, 70%)', 'Color3.fromRGB(30, 60, 130)')

-- Тёмно-синяя тема
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(200, 220, 250)')
R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(220, 80, 100)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(200, 60, 90)')
R('DarkColor = Color3%.new%(0, 0, 0%)', 'DarkColor = Color3.fromRGB(0, 0, 0)')
R('OutlineColor = Color3%.fromRGB%(70, 70, 70%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
R('FontColor = Color3%.fromRGB%(255, 255, 255%)', 'FontColor = Color3.fromRGB(200, 220, 250)')

-- crack → ssv (в самом конце)
R('cracked', 'created')
R('crack', 'ssv')
R('Crack', 'Ssv')
R('CRACK', 'SSV')

-- Двойной ssv
R('ssv%s+ssv', 'ssv')
R('ssv•ssv', 'ssv')
R('ssv%.ssv', 'ssv')
R('ssv%-ssv', 'ssv')
R('ssv/ssv', 'ssv')
R('<b>ssv</b>%s*<b>ssv</b>', '<b>ssv</b>')
R('ssvssv', 'ssv')

print("[ssv] Патчи: " .. applied .. " ok, " .. failed .. " miss")

-- ═══ ПРОВЕРКА ═══
local function c(pat) return select(2, src:gsub(pat, "")) end
print("[ssv] Осталось 'Resonance': " .. c("Resonance"))
print("[ssv] Осталось 'crack': " .. c("crack") + c("Crack") + c("CRACK"))

-- ═══ ЗАПУСК ═══
local chunk, err = loadstring(src, "@ssv")
if not chunk then
    error("[ssv] Ошибка компиляции: " .. tostring(err))
end

local ok, rerr = pcall(chunk)
if not ok then
    error("[ssv] Ошибка выполнения: " .. tostring(rerr))
end

print("[ssv] ✓ Готово 💙 created by qmee2")
