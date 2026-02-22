#!/bin/bash
# =============================================================================
# memorial-elephant.sh - Поминки слона игрока Feykomet
# =============================================================================
# Торжественная траурная церемония с колоколами, дождём и моментом молчания.
# Usage: ./deploy/memorial-elephant.sh
# Remote: ssh server './deploy/memorial-elephant.sh'
# Requires: mcrcon, server.properties with rcon.password

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="${SCRIPT_DIR}/.."

if [ -f "${SERVER_DIR}/server.properties" ]; then
    PROPS="${SERVER_DIR}/server.properties"
elif [ -f "/opt/minecraft/server.properties" ]; then
    PROPS="/opt/minecraft/server.properties"
else
    echo "Error: server.properties not found"
    exit 1
fi

RCON_PASS=$(grep -E '^rcon\.password=' "$PROPS" | cut -d= -f2)
RCON_HOST="127.0.0.1"
RCON_PORT="25575"

if [ -z "$RCON_PASS" ]; then
    echo "Error: Could not read rcon.password from server.properties"
    exit 1
fi

rcon() {
    mcrcon -H "$RCON_HOST" -P "$RCON_PORT" -p "$RCON_PASS" "$@"
}

sound() {
    rcon "execute at @a run playsound $1 master @a ~ ~ ~ ${2:-1}"
}

bell() {
    rcon "execute at @a run playsound minecraft:block.bell.use master @a ~ ~ ~ 1"
}

echo "=== Начинаем поминки слона Feykomet ==="

# ─── Подготовка атмосферы ────────────────────────────────────────────────────
rcon "time set 17500"
rcon "weather rain"
sleep 3

# ─── Колокол зовёт на церемонию ─────────────────────────────────────────────
bell
sleep 2
bell
sleep 2
bell
sleep 3

# ─── Объявление ──────────────────────────────────────────────────────────────
rcon 'title @a times 20 100 40'
rcon 'title @a title {"text":"🪦","color":"gray"}'
rcon 'title @a subtitle {"text":"Поминки слона Feykomet","color":"dark_aqua","italic":true}'
sound "minecraft:ambient.soul_sand_valley.mood" 0.5
sleep 6

rcon 'tellraw @a {"text":"","extra":[{"text":"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━","color":"dark_gray"}]}'
rcon 'tellraw @a {"text":"","extra":[{"text":"  🪦 ПОМИНКИ СЛОНА 🪦","color":"dark_aqua","bold":true}]}'
rcon 'tellraw @a {"text":"","extra":[{"text":"  Верного спутника игрока ","color":"gray"},{"text":"Feykomet","color":"gold","bold":true}]}'
rcon 'tellraw @a {"text":"","extra":[{"text":"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━","color":"dark_gray"}]}'
sleep 5

# ─── Вступительное слово ─────────────────────────────────────────────────────
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Сегодня мы собрались здесь, чтобы вспомнить","color":"white","italic":true}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"того, кто был больше, чем просто моб...","color":"white","italic":true}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Он был другом. Он был семьёй.","color":"aqua","italic":true}]}'
sound "minecraft:entity.wolf.whine" 0.4
sleep 4

# ─── История слона ───────────────────────────────────────────────────────────
bell
sleep 2

rcon 'tellraw @a {"text":"","extra":[{"text":"  📖 ","color":"gold"},{"text":"Глава I — Встреча","color":"gold","bold":true}]}'
sleep 2
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Feykomet нашёл его в далёких саваннах...","color":"gray"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Маленький, неуклюжий слонёнок, который не боялся игрока.","color":"gray"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Так началась великая дружба.","color":"yellow","italic":true}]}'
sound "minecraft:block.note_block.harp" 0.6
sleep 4

rcon 'tellraw @a {"text":"","extra":[{"text":"  📖 ","color":"gold"},{"text":"Глава II — Приключения","color":"gold","bold":true}]}'
sleep 2
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Вместе они прошли через джунгли и пустыни,","color":"gray"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"сражались с мобами и исследовали пещеры.","color":"gray"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Слон нёс на себе весь лут и ни разу не жаловался.","color":"gray"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Он был тем, на кого всегда можно было положиться.","color":"yellow","italic":true}]}'
sound "minecraft:block.note_block.chime" 0.6
sleep 4

rcon 'tellraw @a {"text":"","extra":[{"text":"  📖 ","color":"gold"},{"text":"Глава III — Прощание","color":"gold","bold":true}]}'
sleep 2
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Но этот мир бывает жесток...","color":"dark_gray"}]}'
sound "minecraft:entity.ghast.ambient" 0.3
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"И однажды его не стало.","color":"dark_gray"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Тишина. Только дождь.","color":"dark_gray","italic":true}]}'
sound "minecraft:ambient.cave" 0.5
sleep 5

# ─── Момент молчания ─────────────────────────────────────────────────────────
bell
sleep 1
bell
sleep 1
bell
sleep 2

rcon 'title @a times 20 80 20'
rcon 'title @a title {"text":"Минута молчания","color":"gray","italic":true}'
rcon 'title @a subtitle {"text":"🕯","color":"gold"}'
rcon 'tellraw @a {"text":"","extra":[{"text":"  ","color":"white"},{"text":"🕯 Минута молчания... 🕯","color":"gold","bold":true}]}'

# Замедление игроков
rcon "effect give @a minecraft:slowness 30 2 true"
sleep 5

# Тихие колокола во время молчания
bell
sleep 5
bell
sleep 5
bell
sleep 5
bell
sleep 5
bell
sleep 5

# Снять замедление
rcon "effect clear @a minecraft:slowness"
sleep 2

# ─── Слова памяти ────────────────────────────────────────────────────────────
rcon 'tellraw @a {"text":"","extra":[{"text":"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━","color":"dark_gray"}]}'
rcon 'tellraw @a {"text":"  ","extra":[{"text":"✦ ","color":"gold"},{"text":"Он был лучшим слоном на сервере.","color":"aqua"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"✦ ","color":"gold"},{"text":"Он никогда не застревал в дверях.","color":"aqua"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"✦ ","color":"gold"},{"text":"Ну ладно, застревал. Но мы его за это любили.","color":"aqua"}]}'
sound "minecraft:entity.player.levelup" 0.3
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"✦ ","color":"gold"},{"text":"Он наступил на грядку Pilarsen всего один раз.","color":"aqua"}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"✦ ","color":"gold"},{"text":"Он ел за троих, но мы ему прощали.","color":"aqua"}]}'
sleep 4

# ─── Посвящение от Feykomet ─────────────────────────────────────────────────
rcon 'tellraw @a {"text":"","extra":[{"text":"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━","color":"dark_gray"}]}'
sleep 2
rcon 'tellraw @a {"text":"  ","extra":[{"text":"💬 Feykomet","color":"gold","bold":true},{"text":": ","color":"gray"}]}'
sleep 2
rcon 'tellraw @a {"text":"  ","extra":[{"text":"\"Ты был не просто слон.","color":"white","italic":true}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Ты был мой слон.","color":"white","italic":true}]}'
sleep 3
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Спасибо за каждый блок, что мы прошли вместе.\"","color":"white","italic":true}]}'
sound "minecraft:block.note_block.guitar" 0.5
sleep 5

# ─── Прощальный салют ────────────────────────────────────────────────────────
rcon 'tellraw @a {"text":"","extra":[{"text":"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━","color":"dark_gray"}]}'
rcon 'tellraw @a {"text":"  ","extra":[{"text":"🎆 Прощальный салют 🎆","color":"light_purple","bold":true}]}'
sleep 2

# Фейерверки
rcon 'execute at @a run summon minecraft:firework_rocket ~ ~2 ~ {LifeTime:20,FireworksItem:{id:"minecraft:firework_rocket",Count:1,tag:{Fireworks:{Flight:2,Explosions:[{Type:4,Colors:[I;3887386,6719955],FadeColors:[I;16777215]}]}}}}'
sound "minecraft:entity.firework_rocket.launch" 1
sleep 1
rcon 'execute at @a run summon minecraft:firework_rocket ~3 ~2 ~3 {LifeTime:20,FireworksItem:{id:"minecraft:firework_rocket",Count:1,tag:{Fireworks:{Flight:2,Explosions:[{Type:1,Colors:[I;3887386,11743532],FadeColors:[I;16777215]}]}}}}'
sound "minecraft:entity.firework_rocket.launch" 1
sleep 1
rcon 'execute at @a run summon minecraft:firework_rocket ~-3 ~2 ~-3 {LifeTime:20,FireworksItem:{id:"minecraft:firework_rocket",Count:1,tag:{Fireworks:{Flight:3,Explosions:[{Type:2,Colors:[I;2437522,15790320],FadeColors:[I;16777215]}]}}}}'
sound "minecraft:entity.firework_rocket.launch" 1
sleep 3

# Ещё залп
rcon 'execute at @a run summon minecraft:firework_rocket ~2 ~2 ~-2 {LifeTime:15,FireworksItem:{id:"minecraft:firework_rocket",Count:1,tag:{Fireworks:{Flight:2,Explosions:[{Type:3,Colors:[I;6719955,14602026],FadeColors:[I;16777215]}]}}}}'
rcon 'execute at @a run summon minecraft:firework_rocket ~-2 ~2 ~2 {LifeTime:15,FireworksItem:{id:"minecraft:firework_rocket",Count:1,tag:{Fireworks:{Flight:2,Explosions:[{Type:0,Colors:[I;4312372,14188339],FadeColors:[I;16777215]}]}}}}'
sound "minecraft:entity.firework_rocket.launch" 1
sleep 4

# ─── Заключение ──────────────────────────────────────────────────────────────
rcon "weather clear"
rcon "time set 23500"
sleep 3

rcon 'title @a times 20 100 40'
rcon 'title @a title {"text":"🐘","color":"gray"}'
rcon 'title @a subtitle {"text":"Навсегда в наших сердцах","color":"gold","italic":true}'
sleep 2

rcon 'tellraw @a {"text":"","extra":[{"text":"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━","color":"dark_gray"}]}'
rcon 'tellraw @a {"text":"  ","extra":[{"text":"🐘 ","color":"white"},{"text":"Навсегда в наших сердцах","color":"gold","bold":true}]}'
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Слон Feykomet  •  ???? — 2026","color":"gray","italic":true}]}'
rcon 'tellraw @a {"text":"  ","extra":[{"text":"\"Большой друг, оставивший ещё большую пустоту.\"","color":"dark_aqua","italic":true}]}'
rcon 'tellraw @a {"text":"","extra":[{"text":"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━","color":"dark_gray"}]}'

sound "minecraft:entity.player.levelup" 1
sleep 2

# Рассвет — новый день
rcon "time set 0"
sleep 3

rcon 'tellraw @a {"text":"  ","extra":[{"text":"☀ Солнце встаёт. Жизнь продолжается.","color":"yellow","italic":true}]}'
rcon 'tellraw @a {"text":"  ","extra":[{"text":"Но мы не забудем.","color":"gold"}]}'
sleep 3

rcon 'tellraw @a {"text":"  ","extra":[{"text":"🎁 В честь слона — каждому участнику подарок!","color":"green","bold":true}]}'
rcon "give @a minecraft:golden_apple 3"
rcon "give @a minecraft:cake 1"
sleep 1
sound "minecraft:entity.experience_orb.pickup" 1

echo "=== Поминки завершены ==="
