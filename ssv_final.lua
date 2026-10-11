-- ═══════════════════════════════════════════════════════════════
--  ПАТЧЕР (запустить ОДИН РАЗ)
--  Скачивает оригинал, патчит, сохраняет ssv_final.lua
--  Дальше заливаешь ssv_final.lua на GitHub и всё
-- ═══════════════════════════════════════════════════════════════

local URL = "https://raw.githubusercontent.com/kvantumpopa-art/ssv/refs/heads/master/ssv"

print("[patcher] Скачиваю оригинал...")
local source = game:HttpGet(URL)
print("[patcher] Получено " .. #source .. " байт")

-- ═══════════════════════════════════════════════════════════════
--  ПАТЧИ
-- ═══════════════════════════════════════════════════════════════
local applied, failed = {}, {}

local function patch(name, pat, rep)
    local ok, new, n = pcall(function() return source:gsub(pat, rep) end)
    if ok and n and n > 0 then
        source = new
        applied[#applied+1] = name
        print("[patcher] ✓ " .. name .. " (" .. n .. ")")
    else
        failed[#failed+1] = name
        print("[patcher] ✗ " .. name)
    end
end

-- 1. ИНТРО
patch("intro_text",  'cracked by InLoad and wraith%.dev', 'ssv')
patch("intro_text2", 'cracked by [^"]+',                   'ssv')

-- 2. ЗАГОЛОВОК + WATERMARK
patch("title",     '<b>Resonance</b>', '<b>ssv</b>')
patch("watermark", '"Resonance %%s', '"ssv %%s')
patch("wm_create", '"Resonance", 79685990879972', '"ssv", 79685990879972')
patch("notify",    'or "Resonance"', 'or "ssv"')

-- 3. HOME — название "ssv" синим
patch("home_tab",
    'AddTab%("<b>Home</b>", "house", "Profile, statistics"%)',
    'AddTab("<b><font color=\\"#64AAFF\\">ssv</font></b>", "moon-star", "ssv")')

-- 4. GREETINGS
patch("greet_welcome",  'Welcome to <b><font color=\\"#fffb00\\">ssv crack</font></b>', 'Welcome to <b>ssv</b> 💙')
patch("greet_welcome2", 'Welcome to <b>[^<]*</b>[^<]*', 'Welcome to <b>ssv</b> 💙')
patch("greet_cracked",  'cracked by: InLoad and <font color=\\"#baa4ff\\">wraith%.dev</font>', 'created by qmee2 💙')
patch("greet_cracked2", 'cracked by [^"<]+', 'created by qmee2 💙')
patch("greet_dont",     'dont stop using cracks! ts crack is so cool', '💙')
patch("crack_word",     'ssv crack', 'ssv')

-- 5. УБИРАЕМ ВЕРСИЮ
patch("version_label",
    'Text = %("Current script version: <b>%%*</b>"%)%:format%("v2%.9"%)',
    'Text = "ssv"')
patch("version_banner", '%]%], "ver", "v2%.9"%)', '%]%], "ver", "")')
patch("version_footer",
    'Footer = %("<b>ssv [^"]*</b>"%)%:format%("v2%.9"%)',
    'Footer = "<b>ssv | created by qmee2</b>"')
patch("version_any", '"v2%.9"', '""')

-- 6. RESONANCE → ssv
local PROTECT = {
    "ResonanceRunning", "ResonanceStarting",
    "ResonanceOriginalFallenHeight", "ResonanceRestored", "ResonanceIntro",
}
local restore = {}
for i, name in ipairs(PROTECT) do
    local key = "__SSVP" .. i .. "__"
    source = source:gsub(name, key)
    restore[key] = name
end
source = source:gsub("Resonance", "ssv")
source = source:gsub("RESONANCE", "SSV")
source = source:gsub("Project ssv", "ssv")
for key, name in pairs(restore) do
    source = source:gsub(key, name)
end
print("[patcher] Глобальная замена Resonance → ssv")

-- 7. ЛУНА — ТЁМНАЯ ВЕЗДЕ
patch("moon_star_to_moon", '"moon%-star"', '"moon"')
patch("moon_star_to_moon2", "'moon%-star'", "'moon'")

patch("moon_color1",
    'ImageColor3 = Icon%.Custom and "WhiteColor" or "AccentColor"',
    'ImageColor3 = Color3.fromRGB(30, 60, 130)')
patch("moon_color2",
    'ImageColor3 = BoxIcon%.Custom and "WhiteColor" or "AccentColor"',
    'ImageColor3 = Color3.fromRGB(30, 60, 130)')
patch("moon_color3",
    'ImageColor3 = "WhiteColor"',
    'ImageColor3 = Color3.fromRGB(30, 60, 130)')
patch("moon_color4",
    'ImageColor3 = "FontColor"',
    'ImageColor3 = Color3.fromRGB(30, 60, 130)')
patch("moon_color5",
    'IconColor = Color3%.new%(1, 1, 1%)',
    'IconColor = Color3.fromRGB(30, 60, 130)')
patch("moon_color6",
    'IconColor = Color3%.fromRGB%(255, 170, 70%)',
    'IconColor = Color3.fromRGB(30, 60, 130)')

patch("yellow1", 'Color3%.fromRGB%(255, 200, 60%)',  'Color3.fromRGB(30, 60, 130)')
patch("yellow2", 'Color3%.fromRGB%(255, 220, 100%)', 'Color3.fromRGB(30, 60, 130)')
patch("yellow3", 'Color3%.fromRGB%(255, 255, 0%)',   'Color3.fromRGB(100, 170, 255)')
patch("yellow4", 'Color3%.fromRGB%(255, 170, 70%)',  'Color3.fromRGB(30, 60, 130)')

-- 8. ТЁМНО-СИНЯЯ И ЧЁРНАЯ ТЕМА
patch("bg",   'BackgroundColor = Color3%.fromRGB%(15, 15, 15%)',   'BackgroundColor = Color3.fromRGB(4, 6, 12)')
patch("main", 'MainColor = Color3%.fromRGB%(25, 25, 25%)',         'MainColor = Color3.fromRGB(12, 16, 28)')
patch("acc",  'AccentColor = Color3%.fromRGB%(125, 85, 255%)',     'AccentColor = Color3.fromRGB(100, 170, 255)')
patch("out",  'OutlineColor = Color3%.fromRGB%(40, 40, 40%)',      'OutlineColor = Color3.fromRGB(25, 38, 65)')
patch("fontc",'FontColor = Color3%.new%(1, 1, 1%)',                'FontColor = Color3.fromRGB(200, 220, 250)')
patch("red",  'RedColor = Color3%.fromRGB%(255, 50, 50%)',         'RedColor = Color3.fromRGB(220, 80, 100)')
patch("dest", 'DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(200, 60, 90)')
patch("dark", 'DarkColor = Color3%.new%(0, 0, 0%)',                'DarkColor = Color3.fromRGB(0, 0, 0)')

patch("lib2_acc",  'AccentColor = Color3%.fromRGB%(255, 255, 0%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
patch("lib2_out",  'OutlineColor = Color3%.fromRGB%(70, 70, 70%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
patch("lib2_font", 'FontColor = Color3%.fromRGB%(255, 255, 255%)', 'FontColor = Color3.fromRGB(200, 220, 250)')

-- 9. ФИНАЛЬНАЯ ЗАЧИСТКА
patch("clean_dup1", "created by qmee2 created by qmee2", "created by qmee2")
patch("clean_dup2", "created by qmee2 💙 💙",             "created by qmee2 💙")
patch("clean_dup3", "💙 💙",                              "💙")
patch("clean_res",  "Resonance", "ssv")
patch("clean_wr",   "wraith",    "qmee2")
patch("clean_il",   "InLoad",    "qmee2")

-- ОТЧЁТ
print("")
print("[patcher] ✓ Применено: " .. #applied .. " / " .. (#applied + #failed))
if #failed > 0 then print("[patcher] ✗ Не найдено: " .. table.concat(failed, ", ")) end
print("")

local function count(pat) return select(2, source:gsub(pat, "")) end
print("[patcher] Осталось 'Resonance':      " .. count("Resonance"))
print("[patcher] Осталось 'v2.9':           " .. count("v2%.9"))
print("[patcher] Луны 'moon':               " .. count("moon") + count("Moon"))
print("[patcher] 'moon-star' осталось:      " .. count("moon%-star"))
print("[patcher] 'created by qmee2' найдено: " .. count("created by qmee2"))
print("")

-- ═══════════════════════════════════════════════════════════════
--  СОХРАНЕНИЕ
-- ═══════════════════════════════════════════════════════════════
if type(writefile) ~= "function" then
    error("[patcher] Нужна поддержка writefile")
end

local ok_w = pcall(writefile, "ssv_final.lua", source)
if not ok_w then
    error("[patcher] Не удалось сохранить ssv_final.lua")
end

print("[patcher] ✓ Сохранён ssv_final.lua (" .. #source .. " байт)")
print("[patcher]")
print("[patcher] Дальше:")
print("[patcher] 1. Найди файл ssv_final.lua в workspace экзекутора")
print("[patcher] 2. Заливай его на GitHub (замени свой ssv)")
print("[patcher] 3. В скрипте загрузки оставь:")
print("[patcher]    loadstring(game:HttpGet(URL))()")
print("[patcher]")
print("[patcher] ✓ Готово 💙 created by qmee2")
