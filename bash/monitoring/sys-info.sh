#!/bin/bash


CPU_USAGE=$(top -bn1 | awk '/Cpu/ {print 100 - $8}')
RAM_INFO=$(free -m | awk '/^Mem:/ {printf "%s MB / %s MB (%.1f%%)", $3, $2, $3/$2 * 100}')
DISK_INFO=$(df -h | awk '/^\/dev\// {printf "%-15s | %-6s / %-6s | %s\n", $1, $3, $2, $5}')
GPU_NAME=$(lspci | grep "VGA" | awk -F '[][]' '{print $2}')

echo "- SYSTEM INFO ----------"
printf "%-15s | %s%%\n" "CPU Zużycie" "$CPU_USAGE"
printf "%-15s | %s\n" "RAM Zajęte" "$RAM_INFO"
echo "- DYSKI ----------------"
echo "Partycja        | Zajęte / Całość | %):"
echo "$DISK_INFO"
echo "- GPU ------------------"
echo "$GPU_NAME"
