#!/usr/bin/env bash
# NOvA DTG — HV CAEN tmux session startup

SESSION="HVCAEN"
HV_CMD="python3 caen_shell_v3.py \
  --transport usb --serial-port /dev/ttyDT5471P0 --baudrate 9600 \
  --channel 0 --period 1.0 \
  --influx-host 127.0.0.1 --influx-port 8086 --influx-db NOvA_DTG_CAEN \
  --measurement DT5471P --device-tag DT5471P_0"

# Only create if session doesn't exist
if tmux has-session -t $SESSION 2>/dev/null; then
    echo "Session $SESSION already exists, attaching..."
    tmux attach-session -t $SESSION
    exit 0
fi

# Create new session
tmux new-session -d -s $SESSION

# Top pane (35%) — monitoring
tmux send-keys -t $SESSION "cd ~/caen-dt5471p-monitor" Enter
sleep 0.3
tmux send-keys -t $SESSION "source .venv/bin/activate" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear && $HV_CMD" Enter

# Split bottom 65%
tmux split-window -t $SESSION -v -p 65

# Bottom left — voltage
tmux send-keys -t $SESSION "cd ~/caen-dt5471p-monitor" Enter
sleep 0.3
tmux send-keys -t $SESSION "source .venv/bin/activate" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear && $HV_CMD" Enter

# Split bottom right — current
tmux split-window -t $SESSION -h

# Bottom right — current
tmux send-keys -t $SESSION "cd ~/caen-dt5471p-monitor" Enter
sleep 0.3
tmux send-keys -t $SESSION "source .venv/bin/activate" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear && $HV_CMD" Enter

# Attach to session
tmux attach-session -t $SESSION
