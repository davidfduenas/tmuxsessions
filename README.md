# tmuxsessions

tmux startup scripts for the CAEN HV supply and the DT5730S digitizer.

- `start_hvcaen.sh`: three panes running the HV shell from [caen-dt5471p-monitor](https://github.com/davidfduenas/caen-dt5471p-monitor) (monitor, voltage, current).
- `start_digcaen.sh`: temperature monitor on top, two panes for DAQ runs from [DAQ_Caen](https://github.com/davidfduenas/DAQ_Caen).

Full installation and operating instructions: [SETUP.md in DAQ_Caen](https://github.com/davidfduenas/DAQ_Caen/blob/lab-setup/SETUP.md).

## Settings

Set as environment variables; the defaults are the lab values.

| Variable | Used by | Default |
|---|---|---|
| `HV_DIR` | HV | `$HOME/caen-dt5471p-monitor` |
| `HV_SERIAL_PORT` | HV | `/dev/ttyDT5471P0` |
| `HV_BAUDRATE`, `HV_CHANNEL`, `HV_PERIOD` | HV | `9600`, `0`, `1.0` |
| `HV_MEASUREMENT`, `HV_DEVICE_TAG` | HV | `DT5471P`, `DT5471P_0` |
| `DAQ_DIR` | digitizer | `$HOME/DAQ_Caen` |
| `ROOT_SETUP` | digitizer | `$HOME/root/bin/thisroot.sh` |
| `TEMP_MEASUREMENT`, `TEMP_INTERVAL` | digitizer | `DT5730S`, `5` |
| `INFLUX_HOST`, `INFLUX_PORT`, `INFLUX_DB` | both | `127.0.0.1`, `8086`, `NOvA_DTG_CAEN` |
| `SESSION` | both | `HVCAEN` / `DIGCAEN` |

Example:
```bash
INFLUX_DB=mydb HV_SERIAL_PORT=/dev/ttyACM0 ./start_hvcaen.sh
```
