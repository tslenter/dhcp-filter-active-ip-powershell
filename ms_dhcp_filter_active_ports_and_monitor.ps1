# Edit filter variable
$sername = "*scope_name*"
$csvPath = "D:\DHCP_Reservations.csv"
$csvPathupdate = "D:\DHCP_Reservations_output.csv"
$txtPath = "D:\unreachable.txt"
$counter = 0
$seconds = 900
$max_seconds_run = 3600

# Generate file: 
Get-DhcpServerV4Scope | Where-Object -FilterScript { $_.Name -like $sername } | Select-Object ScopeID | % ($_) {Get-DhcpServerv4Lease -ScopeId $_.ScopeID} | Where-Object {$_.AddressState -like "*Reservation"} | Export-Csv -Path $csvPath -NoTypeInformation

# First init (don't forget to edit the filter!)
$devices = Get-DhcpServerV4Scope | Where-Object -FilterScript { $_.Name -like $sername } | Select-Object ScopeID | % ($_) {Get-DhcpServerv4Lease -ScopeId $_.ScopeID} | Where-Object {$_.AddressState -like "*Reservation"} | Select-Object IPAddress
$outputFile = $txtPath
New-Item -Path $outputFile -Force

# Memory File:
foreach ($device in $devices) {
    $ping = Test-Connection $device.IPAddress -Count 1 -ErrorAction SilentlyContinue # Send a ping request to the device
    if (!$ping) {
        # Device is not reachable, so add the IP to the output file
        Add-Content -Path $outputFile -Value $device.IPAddress
    }
}

# Update data
while ($counter -le $max_seconds_run) {
	echo "Run for $counter seconds"
     	foreach ($device in $devices) {
    		$ping = Test-Connection $device.IPAddress -Count 1 -ErrorAction SilentlyContinue # Send a ping request to the device
    		if ($ping) {
        		# Device is reachable, so remove the IP from the output file if it exists
        		(Get-Content $outputFile) | Where-Object {$_ -ne $device.IPAddress} | Set-Content $outputFile
    		}
	}
	$counter += $seconds
	Start-Sleep -Seconds $seconds
}

# Import the CSV file
$data = Import-Csv $csvPath

Get-Content $txtPath | ForEach-Object {
	$searchString = echo $_

	# Filter the data to remove the entry with the search string
	$data = $data | Where-Object { $_.IPAddress -notlike "*$searchString*" }

	# Export the updated data back to the CSV file
	$data | Export-Csv $csvPathupdate -NoTypeInformation
}