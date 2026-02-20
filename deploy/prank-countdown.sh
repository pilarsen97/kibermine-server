#!/bin/bash
# =============================================================================
# prank-countdown.sh - Doomsday countdown prank with lighting & sound effects
# =============================================================================
# Dramatic end-of-world countdown with time/weather changes and player sounds.
# Usage: ./deploy/prank-countdown.sh
# Remote: ssh server './deploy/prank-countdown.sh'
# Requires: mcrcon, server.properties with rcon.password

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="${SCRIPT_DIR}/.."

# Try local server.properties first, fall back to /opt/minecraft
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

# Play sound at every player's position
sound() {
    rcon "execute at @a run playsound $1 master @a ~ ~ ~ ${2:-1}"
}

echo "Starting doomsday prank..."

# --- Intro: sunset ---
rcon "time set 12000"
rcon 'tellraw @a {"text":"[СИСТЕМА] ","color":"dark_red","bold":true,"extra":[{"text":"⚠ ВНИМАНИЕ! Обнаружена критическая аномалия пространства-времени!","color":"red","bold":false}]}'
sleep 2

# 10
rcon "time set 13000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света осталось: ","color":"gold"},{"text":"10","color":"yellow","bold":true}]}'
sound "minecraft:entity.wither.spawn" 0.5
sleep 1.5

# 9
rcon "time set 14000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"9","color":"yellow","bold":true},{"text":" — Боги покидают этот мир...","color":"gray","italic":true}]}'
sleep 1.5

# 8
rcon "time set 15000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"8","color":"yellow","bold":true},{"text":" — Криперы начали молиться...","color":"gray","italic":true}]}'
sound "minecraft:entity.lightning_bolt.thunder" 0.7
sleep 1.5

# 7
rcon "time set 16000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"7","color":"red","bold":true},{"text":" — Нотч отвернулся от нас!","color":"gray","italic":true}]}'
sleep 1.5

# 6
rcon "time set 17000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"6","color":"red","bold":true},{"text":" — Эндер Дракон заплакал...","color":"gray","italic":true}]}'
sound "minecraft:entity.ender_dragon.growl" 0.6
sleep 1.5

# 5
rcon "time set 18000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"5","color":"red","bold":true},{"text":" — Полная тьма наступает!","color":"dark_gray","italic":true}]}'
sound "minecraft:ambient.cave" 1
sleep 1.5

# 4 — thunderstorm
rcon "time set 14000"
rcon "weather thunder"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"4","color":"dark_red","bold":true},{"text":" — ГРОЗА АПОКАЛИПСИСА!","color":"red","italic":true}]}'
sound "minecraft:entity.lightning_bolt.impact" 1
sleep 1.5

# 3
rcon "time set 22000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"3","color":"dark_red","bold":true},{"text":" — Бедрок начал трескаться!!!","color":"red","bold":true}]}'
sound "minecraft:entity.wither.death" 0.8
sleep 1.5

# 2
rcon "time set 6000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"2","color":"dark_red","bold":true},{"text":" — ПРОЩАЙТЕ, ДРУЗЬЯ!","color":"red","bold":true}]}'
sound "minecraft:entity.generic.explode" 1
sleep 1.5

# 1
rcon "time set 18000"
rcon 'tellraw @a {"text":"☠ ","color":"dark_red","extra":[{"text":"До конца света: ","color":"gold"},{"text":"1","color":"dark_red","bold":true},{"text":" — ...","color":"dark_red","obfuscated":true}]}'
sound "minecraft:entity.generic.explode" 2
sleep 2

# 0 — BOOM
rcon "time set 6000"
rcon "weather clear"
rcon 'tellraw @a {"text":"💥 ","extra":[{"text":"0","color":"dark_red","bold":true,"obfuscated":true},{"text":" ... ","color":"dark_red"},{"text":"КОНЕЦ СВЕ—","color":"dark_red","bold":true}]}'
sound "minecraft:entity.generic.explode" 2
sleep 3

# --- Reveal ---
rcon 'tellraw @a {"text":"...","color":"gray"}'
sleep 2
rcon 'tellraw @a {"text":"Подождите...","color":"gray","italic":true}'
sleep 2
rcon 'tellraw @a {"text":"А нет, это просто обновление Java.","color":"green","italic":true}'
sleep 1
rcon 'tellraw @a {"text":"☀ Конец света отменяется! Продолжаем копать! ⛏","color":"gold","bold":true}'
sound "minecraft:entity.player.levelup" 1

echo "Doomsday prank complete!"
