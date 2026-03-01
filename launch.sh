#!/bin/sh
# KIBERmine Server Launch Script
# Optimized JVM settings for Mohist 1.20.1 with G1GC

cd "$(dirname "$(readlink -fn "$0")")"

# Use Java 17 (required by Mohist 1.20.1)
if [ -x "/opt/homebrew/opt/openjdk@17/bin/java" ]; then
    JAVA="/opt/homebrew/opt/openjdk@17/bin/java"
elif command -v java >/dev/null 2>&1; then
    JAVA="java"
else
    echo "ERROR: Java not found!"
    exit 1
fi

# Find the server JAR (supports version updates)
JAR_FILE=$(ls mohist-1.20.1-*.jar 2>/dev/null | head -1)
if [ -z "$JAR_FILE" ]; then
    echo "ERROR: Server JAR not found!"
    exit 1
fi

# Memory settings
MIN_RAM="4G"
MAX_RAM="6G"

# Launch with optimized G1GC settings
exec "$JAVA" \
    -Xms${MIN_RAM} \
    -Xmx${MAX_RAM} \
    -Dfile.encoding=UTF-8 \
    -Dsun.jnu.encoding=UTF-8 \
    -Dlog4j.configurationFile=log4j2.xml \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=200 \
    -XX:+ParallelRefProcEnabled \
    -XX:G1HeapRegionSize=16M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:+DisableExplicitGC \
    -XX:+UseStringDeduplication \
    -XX:+AlwaysPreTouch \
    -Xss512k \
    -jar "$JAR_FILE" nogui