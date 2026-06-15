# deploy_agent_crugwiro-sudo

Automated Project Bootstrapping & Process Management for the Student Attendance Tracker.

---

## What This Script Does

`setup_project.sh` is a shell script that automates the full setup of the Student Attendance Tracker workspace. In one execution it:

1. Creates the required directory structure (`attendance_tracker_{input}/`)
2. Populates all source files (Python app, CSV data, JSON config, log file)
3. Optionally updates attendance thresholds via `sed` (in-place config editing)
4. Validates the environment (checks for `python3` and verifies file structure)
5. Handles interrupts gracefully with a SIGINT trap

---

## How to Run the Script

### 1. Clone the repository

```bash
git clone https://github.com/crugwiro-sudo/deploy_agent_crugwiro-sudo.git
cd deploy_agent_crugwiro-sudo
```

### 2. Make the script executable

```bash
chmod +x setup_project.sh
```

### 3. Run the script

You can pass the project identifier as an argument:

```bash
./setup_project.sh spring2026
```

Or run it without arguments and you will be prompted:

```bash
./setup_project.sh
# > Enter a project identifier: spring2026
```

This creates the directory `attendance_tracker_spring2026/` with the full structure:

```
attendance_tracker_spring2026/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log
```

### 4. Run the Python application (after setup)

```bash
cd attendance_tracker_spring2026
python3 attendance_checker.py
```

---

## How to Trigger the Archive Feature (SIGINT Trap)

The script handles `Ctrl+C` (SIGINT) at any point during execution.

**To trigger it:**

1. Start the script normally:
   ```bash
   ./setup_project.sh myproject
   ```

2. Press **`Ctrl+C`** at any point during execution (e.g., while it prompts you for threshold values).

**What happens:**

- The script catches the interrupt signal
- It bundles the current (incomplete) project directory into a `.tar.gz` archive:
  ```
  attendance_tracker_myproject_archive.tar.gz
  ```
- It then **deletes** the incomplete `attendance_tracker_myproject/` directory to keep the workspace clean
- The script exits with a status of `1`

This ensures no partial/broken workspaces are left behind.

---

## Threshold Configuration

When prompted during setup, you can update the attendance thresholds:

- **Warning threshold** (default: `75%`) — students below this receive a warning
- **Failure threshold** (default: `50%`) — students below this receive an urgent fail notice

The script validates that your input is a numeric value between 0 and 100 before applying changes via `sed`.

---

## Requirements

- **Bash** (v4+)
- **Python 3** (for running the attendance checker application)
- **bc** (for numeric validation — pre-installed on most Linux/WSL systems)
- **tar** (for archive creation — pre-installed on Linux/WSL)
