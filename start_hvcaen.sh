#!/usr/bin/env bash
# HV CAEN tmux session startup
#
# Override any of these from the environment, e.g.:
#   HV_SERIAL_PORT=/dev/ttyACM0 INFLUX_DB=mydb ./start_hvcaen.sh

SESSION="${SESSION:-HVCAEN}"
HV_DIR="${HV_DIR:-$HOME/caen-dt5471p-monitor}"           # folder with caen_shell_v3.py and .venv
HV_SERIAL_PORT="${HV_SERIAL_PORT:-/dev/ttyDT5471P0}"     # see udev rule in the setup instructions
HV_BAUDRATE="${HV_BAUDRATE:-9600}"
HV_CHANNEL="${HV_CHANNEL:-0}"
HV_PERIOD="${HV_PERIOD:-1.0}"
INFLUX_HOST="${INFLUX_HOST:-127.0.0.1}"
INFLUX_PORT="${INFLUX_PORT:-8086}"
INFLUX_DB="${INFLUX_DB:-NOvA_DTG_CAEN}"
HV_MEASUREMENT="${HV_MEASUREMENT:-DT5471P}"
HV_DEVICE_TAG="${HV_DEVICE_TAG:-DT5471P_0}"

HV_CMD="python3 caen_shell_v3.py \
  --transport usb --serial-port ${HV_SERIAL_PORT} --baudrate ${HV_BAUDRATE} \
  --channel ${HV_CHANNEL} --period ${HV_PERIOD} \
  --influx-host ${INFLUX_HOST} --influx-port ${INFLUX_PORT} --influx-db ${INFLUX_DB} \
  --measurement ${HV_MEASUREMENT} --device-tag ${HV_DEVICE_TAG}"

# Split the session's window. Newer tmux (3.1+) uses -l <percent>%; older versions only know -p <percent>.
split_pane() {   # $1 = -v | -h, $2 = size of the new pane in percent
    tmux split-window -t "$SESSION" "$1" -l "$2%" 2>/dev/null || tmux split-window -t "$SESSION" "$1" -p "$2"
}

# Only create if session doesn't exist
if tmux has-session -t $SESSION 2>/dev/null; then
    echo "Session $SESSION already exists, attaching..."
    tmux attach-session -t $SESSION
    exit 0
fi

# Create new session
tmux new-session -d -s $SESSION

# Top pane (35%) — monitoring
tmux send-keys -t $SESSION "cd \"$HV_DIR\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "source .venv/bin/activate" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear && $HV_CMD" Enter

# Split bottom 65%
split_pane -v 65

# Bottom left — voltage
tmux send-keys -t $SESSION "cd \"$HV_DIR\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "source .venv/bin/activate" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear && $HV_CMD" Enter

# Split bottom right — current
tmux split-window -t $SESSION -h

# Bottom right — current
tmux send-keys -t $SESSION "cd \"$HV_DIR\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "source .venv/bin/activate" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear && $HV_CMD" Enter

# Attach to session
tmux attach-session -t $SESSION
