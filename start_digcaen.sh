#!/usr/bin/env bash
# NOvA DTG — Digitizer CAEN tmux session startup

SESSION="DIGCAEN"
TEMP_CMD="~/DAQ_Caen/utils/read_temp_influx \
  --influx-host 127.0.0.1 \
  --influx-port 8086 \
  --influx-db NOvA_DTG_CAEN \
  --measurement DT5730S \
  --interval 5 \
  --verbose"

# If session already exists, just attach to it
if tmux has-session -t $SESSION 2>/dev/null; then
    echo "Session $SESSION already exists, attaching..."
    tmux attach-session -t $SESSION
    exit 0
fi

# Create new session
tmux new-session -d -s $SESSION

# Top pane (35%) — temperature monitoring
tmux send-keys -t $SESSION "cd ~/DAQ_Caen" Enter
sleep 0.3
tmux send-keys -t $SESSION "source ~/root/bin/thisroot.sh" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear && $TEMP_CMD" Enter

# Split bottom 65%
tmux split-window -t $SESSION -v -p 65

# Bottom left — orchestrator
tmux send-keys -t $SESSION "cd ~/DAQ_Caen" Enter
sleep 0.3
tmux send-keys -t $SESSION "source ~/root/bin/thisroot.sh" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear" Enter

# Split bottom right — manual DAQ
tmux split-window -t $SESSION -h

# Bottom right — manual threshold runs
tmux send-keys -t $SESSION "cd ~/DAQ_Caen" Enter
sleep 0.3
tmux send-keys -t $SESSION "source ~/root/bin/thisroot.sh" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear" Enter

# Attach to session
tmux attach-session -t $SESSION
