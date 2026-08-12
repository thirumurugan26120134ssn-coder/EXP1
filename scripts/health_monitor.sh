#!/bin/bash

REPORT="health_report.txt"

echo "========================================" > "$REPORT"
echo "       LINUX SYSTEM HEALTH REPORT" >> "$REPORT"
echo "========================================" >> "$REPORT"

echo "" >> "$REPORT"
echo "Generated at: $(date)" >> "$REPORT"

echo "" >> "$REPORT"
echo "---------- HOST INFORMATION ----------" >> "$REPORT"
echo "Hostname: $(hostname)" >> "$REPORT"
echo "Operating System:" >> "$REPORT"
cat /etc/os-release | grep PRETTY_NAME >> "$REPORT"

echo "" >> "$REPORT"
echo "---------- DISK USAGE ----------" >> "$REPORT"
df -h >> "$REPORT"

echo "" >> "$REPORT"
echo "---------- MEMORY USAGE ----------" >> "$REPORT"
free -h >> "$REPORT"

echo "" >> "$REPORT"
echo "---------- CPU LOAD ----------" >> "$REPORT"
uptime >> "$REPORT"

echo "" >> "$REPORT"
echo "---------- TOP CPU PROCESSES ----------" >> "$REPORT"
ps aux --sort=-%cpu | head -6 >> "$REPORT"

echo "" >> "$REPORT"
echo "---------- TOP MEMORY PROCESSES ----------" >> "$REPORT"
ps aux --sort=-%mem | head -6 >> "$REPORT"

echo "" >> "$REPORT"
echo "========================================" >> "$REPORT"
echo "Health report generated successfully." >> "$REPORT"
echo "========================================" >> "$REPORT"

echo "Health report created: $REPORT"
