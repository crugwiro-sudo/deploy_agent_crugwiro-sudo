#!/bin/bash

# setup_project.sh
# Automated Project Bootstrapping & Process Management
# Author: crugwiro-sudo

echo "Student Attendance Tracker - Setup Script"
echo ""

# Ask the user for a project name
read -rp "Enter a project name (example: spring2026): " PROJECT_INPUT

if [ -z "$PROJECT_INPUT" ]; then
    echo "You didn't enter a project name. Exiting."
    exit 1
fi

PROJECT_DIR="attendance_tracker_${PROJECT_INPUT}"

# Create the folder structure
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

if [ $? -ne 0 ]; then
    echo "Error: Could not create folders. You might not have permission."
    exit 1
fi

echo "Folders created: $PROJECT_DIR"
