# deploy_agent_crugwiro-sudo

A shell script that automatically sets up the Student Attendance Tracker project on any Linux machine.

---

## How to run the script

**1. Clone the repo**
```bash
cd ~
git clone https://github.com/crugwiro-sudo/deploy_agent_crugwiro-sudo
cd deploy_agent_crugwiro-sudo
```

**2. Make the script executable**
```bash
chmod +x setup_project.sh
```

**3. Run it**
```bash
./setup_project.sh
```

The script will ask you for a project name, then build the full folder structure automatically.

---

## What the script does, step by step

1. Asks you for a project name (e.g. `spring2026`)
2. Creates this folder structure:
```
attendance_tracker_spring2026/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log
```
3. Asks if you want to change the attendance thresholds (Warning and Failure %)
4. If yes, updates `config.json` automatically using `sed`
5. Checks that Python3 is installed on your system
6. Confirms all files were created correctly

---

## How to trigger the archive feature

The archive feature activates when you press **Ctrl+C** during the setup.

**To test it:**
1. Run the script: `./setup_project.sh`
2. Press `Ctrl+C` at any point (for example, when it asks about thresholds)

**What happens:**
- The script catches the interrupt
- It zips up whatever was created so far into a file called `attendance_tracker_{name}_archive.tar.gz`
- It then deletes the incomplete project folder to keep your workspace clean
- The script exits

This means you never end up with a half-built broken folder left behind.

---

## Requirements

- Linux or WSL (Windows Subsystem for Linux)
- Python 3 (to run the attendance checker after setup)
- `bc` and `tar` (come pre-installed on most Linux systems)
