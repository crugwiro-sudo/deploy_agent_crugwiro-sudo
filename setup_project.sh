#!/bin/bash

# setup_project.sh
# Automated Project Bootstrapping & Process Management
# Author: crugwiro-sudo

echo "Student Attendance Tracker - Setup Script"
echo ""

read -rp "Enter a project name (example: spring2026): " PROJECT_INPUT

if [ -z "$PROJECT_INPUT" ]; then
    echo "You didn't enter a project name. Exiting."
    exit 1
fi

PROJECT_DIR="attendance_tracker_${PROJECT_INPUT}"

if [ -d "$PROJECT_DIR" ]; then
    echo "Warning: A folder called '$PROJECT_DIR' already exists."
    read -rp "Do you want to delete it and start fresh? (y/N): " OVERWRITE
    if [[ "$OVERWRITE" =~ ^[Yy]$ ]]; then
        rm -rf "$PROJECT_DIR"
    else
        echo "Setup cancelled. Nothing was changed."
        exit 0
    fi
fi

mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

if [ $? -ne 0 ]; then
    echo "Error: Could not create folders. You might not have permission."
    exit 1
fi

echo "Folders created successfully."

# Write source files
echo "Writing project files..."

cat > "$PROJECT_DIR/attendance_checker.py" << 'PYEOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])
            attendance_pct = (attended / total_sessions) * 100
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
PYEOF

cat > "$PROJECT_DIR/Helpers/assets.csv" << 'CSVEOF'
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
CSVEOF

cat > "$PROJECT_DIR/Helpers/config.json" << 'JSONEOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
JSONEOF

cat > "$PROJECT_DIR/reports/reports.log" << 'LOGEOF'
--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.
LOGEOF

echo "All files written."
