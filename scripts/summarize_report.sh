#!/bin/bash

INPUT="health_report.txt"
OUTPUT="summary_report.txt"

echo "========================================" > "$OUTPUT"
echo "       LINUX HEALTH SUMMARY REPORT" >> "$OUTPUT"
echo "========================================" >> "$OUTPUT"

echo "" >> "$OUTPUT"
echo "Generated at: $(date)" >> "$OUTPUT"

echo "" >> "$OUTPUT"
echo "---------- SYSTEM STATUS ----------" >> "$OUTPUT"

# Check whether the health report exists
if [ ! -f "$INPUT" ]; then
    echo "STATUS: ERROR" >> "$OUTPUT"
    echo "ERROR: Health report not found." >> "$OUTPUT"
    echo "ACTION: Run health_monitor.sh first." >> "$OUTPUT"
    exit 1
fi

# Disk analysis
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "" >> "$OUTPUT"
echo "Disk Usage: ${DISK_USAGE}%" >> "$OUTPUT"

if [ "$DISK_USAGE" -ge 80 ]; then
    echo "Status: WARNING - Disk usage is high." >> "$OUTPUT"
    echo "Action: Consider removing unnecessary files." >> "$OUTPUT"
else
    echo "Status: OK - Disk usage is within acceptable limits." >> "$OUTPUT"
fi

# Memory analysis
MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

echo "" >> "$OUTPUT"
echo "Memory Usage: ${MEMORY_USAGE}%" >> "$OUTPUT"

if [ "$MEMORY_USAGE" -ge 80 ]; then
    echo "Status: WARNING - Memory usage is high." >> "$OUTPUT"
    echo "Action: Check applications consuming large amounts of memory." >> "$OUTPUT"
else
    echo "Status: OK - Memory usage is within acceptable limits." >> "$OUTPUT"
fi

# CPU load
LOAD=$(awk '{print $1}' /proc/loadavg)

echo "" >> "$OUTPUT"
echo "CPU Load (1 minute): $LOAD" >> "$OUTPUT"

echo "Status: CPU load recorded successfully." >> "$OUTPUT"

# Report validation
echo "" >> "$OUTPUT"
echo "---------- REPORT VALIDATION ----------" >> "$OUTPUT"

if grep -q "Health report generated successfully" "$INPUT"; then
    echo "Health report generation: SUCCESS" >> "$OUTPUT"
else
    echo "Health report generation: ERROR" >> "$OUTPUT"
fi

echo "" >> "$OUTPUT"
echo "---------- ACTIONABLE SUMMARY ----------" >> "$OUTPUT"

if [ "$DISK_USAGE" -ge 80 ] || [ "$MEMORY_USAGE" -ge 80 ]; then
    echo "Overall Status: ATTENTION REQUIRED" >> "$OUTPUT"
    echo "Recommended Action: Investigate resource usage." >> "$OUTPUT"
else
    echo "Overall Status: HEALTHY" >> "$OUTPUT"
    echo "Recommended Action: No immediate action required." >> "$OUTPUT"
fi

echo "" >> "$OUTPUT"
echo "========================================" >> "$OUTPUT"
echo "Summary generation completed." >> "$OUTPUT"
echo "========================================" >> "$OUTPUT"

echo "Summary report created: $OUTPUT"
