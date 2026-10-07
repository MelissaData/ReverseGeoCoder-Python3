<#
.SYNOPSIS
    Runs the Melissa Reverse GeoCoder Cloud API Python 3 sample.

.DESCRIPTION
    This script runs ReverseGeoCoderPython3.py with python3, passing along the license
    and (if supplied) the lookup fields.

    Overall flow:
      1. Resolve the license (parameter, prompt, or MD_LICENSE environment variable).
      2. Run ReverseGeoCoderPython3.py: with the lookup fields if any was supplied,
         otherwise with only the license (the Python program prompts for each field).

.PARAMETER lat
    Latitude to test.

.PARAMETER long
    Longitude to test.

.PARAMETER max
    Maximum number of records to return (up to 100).

.PARAMETER license
    License string. Resolved in this order:
      1. This parameter.
      2. An interactive prompt, if the parameter was not supplied.
      3. The MD_LICENSE environment variable, if the prompt was left blank.
    Note that the environment variable is the last resort, not the first: running
    without -license always prompts, even when MD_LICENSE is set.

.PARAMETER quiet
    Accepted for parity with other sample scripts; not currently used to suppress output.

.EXAMPLE
    .\ReverseGeoCoderPython3.ps1 -license "your-license"

.EXAMPLE
    .\ReverseGeoCoderPython3.ps1 -lat "33.637520" -long "-117.606920" -max "3" -license "your-license"
#>

######################### Parameters ##########################
param(
    $lat = '',
    $long = '',
    $max = '',
    $license = '',
    [switch]$quiet = $false
    )

########################## Main ############################
Write-Host "`n====================== Melissa Reverse GeoCoder Cloud API ======================`n"

# Get license (either from parameters or user input)
if ([string]::IsNullOrEmpty($license) ) {
  $license = Read-Host "Please enter your license string"
}

# Check for License from Environment Variables 
if ([string]::IsNullOrEmpty($license) ) {
  $license = $env:MD_LICENSE 
}

if ([string]::IsNullOrEmpty($license)) {
  Write-Host "`nLicense String is invalid!"
  Exit
}

# Run project
# No lookup fields (including -max) supplied -> run with only the license (the program prompts); otherwise pass the supplied ones through.
if ([string]::IsNullOrEmpty($lat) -and [string]::IsNullOrEmpty($long) -and [string]::IsNullOrEmpty($max)) {
  python3 ReverseGeoCoderPython3.py --license $license
}
else {
  # Only pass flags that have a value. Windows PowerShell drops empty-string arguments to
  # native programs, which would shift the next flag name into this flag's value.
  # Any field left out here is prompted for by the program.
  $runArgs = @('--license', $license)
  if (-not [string]::IsNullOrEmpty($lat))  { $runArgs += '--lat', $lat }
  if (-not [string]::IsNullOrEmpty($long)) { $runArgs += '--long', $long }
  if (-not [string]::IsNullOrEmpty($max))  { $runArgs += '--max', $max }
  python3 ReverseGeoCoderPython3.py @runArgs
}
