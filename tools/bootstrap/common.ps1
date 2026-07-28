# Set all convenience variables and loads dependencies.
#
# $global:BootstrapDir = directory to /tools/bootstrap
# $global:InvokeDir = where we were ran from
# $global:ContextDir = directory to /tools which is where all our scripts/whatnot should be running from.
# $global:CacheDir = where to store bootstrap'd data/scripts/etc.
function Initialize-Bootstrap () {
	$global:BootstrapDir = "$PSScriptRoot"
	$global:InvokeDir = Get-Location
	$global:ContextDir = (Get-Item $PSScriptRoot).Parent.FullName
	$global:CacheDir = "$PSScriptRoot/.cache"

	# Write-Output "bootstrap-common: bootstrap in $($BootstrapDir)"
	# Write-Output "bootstrap-common: invoked from $($InvokeDir)"
	# Write-Output "bootstrap-common: context in $($ContextDir)"

	# load dependency values
	$DependencyFile = "$global:BootstrapDir/../../dependencies.sh"
	Get-Content $DependencyFile | Select-String -Pattern "^export" | ForEach-Object {
		$Split1=$_[0].ToString().Split("=")
		$Split2=$Split1[0].Split(" ")
		$Value=$Split1[1]
		$Key=$Split2[1]
		Set-Variable -Scope Global -Name "$Key" -Value "$Value"
	}
}
