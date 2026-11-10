#!/usr/bin/env bash
# Digitizer CAEN tmux session startup
#
# Override any of these from the environment, e.g.:
#   DAQ_DIR=$HOME/mydaq INFLUX_DB=mydb ./start_digcaen.sh

SESSION="${SESSION:-DIGCAEN}"
DAQ_DIR="${DAQ_DIR:-$HOME/DAQ_Caen}"                         # folder with daq_threshold_v1.0.0 and utils/
ROOT_SETUP="${ROOT_SETUP:-$HOME/root/bin/thisroot.sh}"       # ROOT environment script
INFLUX_HOST="${INFLUX_HOST:-127.0.0.1}"
INFLUX_PORT="${INFLUX_PORT:-8086}"
INFLUX_DB="${INFLUX_DB:-NOvA_DTG_CAEN}"
TEMP_MEASUREMENT="${TEMP_MEASUREMENT:-DT5730S}"
TEMP_INTERVAL="${TEMP_INTERVAL:-5}"

TEMP_CMD="\"$DAQ_DIR/utils/read_temp_influx\" \
  --influx-host ${INFLUX_HOST} \
  --influx-port ${INFLUX_PORT} \
  --influx-db ${INFLUX_DB} \
  --measurement ${TEMP_MEASUREMENT} \
  --interval ${TEMP_INTERVAL} \
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
tmux send-keys -t $SESSION "cd \"$DAQ_DIR\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "source \"$ROOT_SETUP\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear && $TEMP_CMD" Enter

# Split bottom 65%
tmux split-window -t $SESSION -v -p 65

# Bottom left — orchestrator
tmux send-keys -t $SESSION "cd \"$DAQ_DIR\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "source \"$ROOT_SETUP\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear" Enter

# Split bottom right — manual DAQ
tmux split-window -t $SESSION -h

# Bottom right — manual threshold runs
tmux send-keys -t $SESSION "cd \"$DAQ_DIR\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "source \"$ROOT_SETUP\"" Enter
sleep 0.3
tmux send-keys -t $SESSION "clear" Enter

# Attach to session
tmux attach-session -t $SESSION
