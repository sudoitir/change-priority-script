# Process Priority Changer

This Bash script allows you to view and change the CPU priority (niceness) of processes on your system. You can check the top 10 processes sorted by CPU usage, and if needed, adjust the CPU priority for a specific process.

## Prerequisites

- This script is designed to work on a Unix-like system (e.g., Linux).
- You should have `sudo` privileges to change the CPU priority of processes, as changing priorities may require elevated permissions.

## Usage

1. Make the script executable:

   ```bash
   chmod +x process_priority_changer.sh
   ```

2. Run the script:

   ```bash
   ./process_priority_changer.sh
   ```

3. Follow the on-screen instructions:

   - The script will display the top 10 processes sorted by CPU usage.
   - You can enter the PID of the process for which you want to change the CPU priority.
   - Provide the new CPU priority level, where a lower value indicates higher priority (e.g., 10 for low priority, -10 for high priority).

- After changing the CPU priority of a process, the script attempts to run the `renice` command with `sudo` if needed. You may be prompted to enter your password for elevated privileges.

## Example

Here's a sample execution of the script:

1. View the top processes sorted by CPU usage.
2. Enter the PID of the process you want to change the priority for.
3. Enter the new CPU priority level (e.g., 10 for low priority or -10 for high priority).
