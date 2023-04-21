# DHCP reservation filter with monitor function 
This repository can be used to filter down active ip addresses for Microsoft DHCP using a small ping monitor

## How to use:

Download: ms_dhcp_filter_active_ports_and_monitor.ps1 and change the following variables:

### Name / part scope name:
```
$sername = "*scope_name*"
```

### Save file for the file with all the reservation of the filtered scopes:
```
$csvPath = "D:\DHCP_Reservations.csv"
```

### Save file for the filtered DHCP_Reservations.csv and unreachable.tx (removes unactive ip's):
```
$csvPathupdate = "D:\DHCP_Reservations_output.csv"
```

### Save file for the not active ip's:
```
$txtPath = "D:\unreachable.txt"
```

### Start counter (leave default):
```
$counter = 0
```

### Set interval in seconds:
```
$seconds = 900
```

### Set max run in seconds:
```
$max_seconds_run = 3600
```
