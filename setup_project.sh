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

# If the folder already exists, ask before overwriting
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
