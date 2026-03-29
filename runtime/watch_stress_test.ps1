$ErrorActionPreference = "Stop"

$brainRoot = "C:\Users\BASEMENT_ADMIN\bot1\brain_v4"
$exePath = "C:\Users\BASEMENT_ADMIN\bot1\runtime\neuronfs.exe"
$sandboxPath = Join-Path $brainRoot "brainstem\_sandbox"
$testDuration = 5 # seconds of heavy I/O to simulate long-term stability
$logFile = "watch_stress.log"

Write-Output "Starting --watch stress test..."
# Start neuronfs --watch in background
$watchProc = Start-Process -FilePath $exePath -ArgumentList "`"$brainRoot`" --watch" -PassThru -WindowStyle Hidden -RedirectStandardOutput $logFile

Start-Sleep -Seconds 1 # Wait for it to initialize

Write-Output "Generating heavy I/O events..."
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$counter = 0

while ($stopwatch.Elapsed.TotalSeconds -lt $testDuration) {
    # Create a dummy neuron
    $neuronDir = Join-Path $sandboxPath "stress_test_$counter"
    New-Item -ItemType Directory -Path $neuronDir -Force | Out-Null
    
    # Write a trace
    $traceFile = Join-Path $neuronDir "1.neuron"
    Set-Content -Path $traceFile -Value "Stress test $counter"
    
    Start-Sleep -Milliseconds 50
    
    # Delete it
    Remove-Item -Path $neuronDir -Recurse -Force
    
    $counter++
    Start-Sleep -Milliseconds 50
}

Write-Output "Completed $counter full I/O cycles in $testDuration seconds."

# Check if process is still running
$isAlive = !$watchProc.HasExited
if ($isAlive) {
    Write-Output "SUCCESS: Process survived stress test (PID $($watchProc.Id))."
    Stop-Process -Id $watchProc.Id -Force
} else {
    Write-Output "FAILURE: Process crashed during stress test. Exit code: $($watchProc.ExitCode)"
}

Write-Output "=== LOG TAIL ==="
Get-Content $logFile -Tail 20 | ForEach-Object { Write-Output $_ }
