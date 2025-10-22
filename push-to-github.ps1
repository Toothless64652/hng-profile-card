# push-to-github.ps1
# Usage: right-click and Run with PowerShell, or run in PowerShell:
#   powershell -ExecutionPolicy Bypass -File .\push-to-github.ps1

$repoPath = 'C:\Users\HP\Desktop\HNG113'

function Find-Git {
    # Try Get-Command first
    $cmd = Get-Command git -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    # Search common install locations
    $possible = @(
        'C:\Program Files\Git\cmd\git.exe',
        'C:\Program Files\Git\bin\git.exe',
        'C:\Program Files (x86)\Git\cmd\git.exe',
        'C:\Program Files (x86)\Git\bin\git.exe'
    )
    foreach ($p in $possible) {
        if (Test-Path $p) { return (Get-Item $p).FullName }
    }

    # Last resort: quick recursive search (may be slow)
    try {
        $found = Get-ChildItem -Path 'C:\' -Filter git.exe -Recurse -ErrorAction SilentlyContinue -Force | Select-Object -First 1
        if ($found) { return $found.FullName }
    } catch {
        # ignore
    }
    return $null
}

Write-Host "Finding git.exe..."
$gitExe = Find-Git
if (-not $gitExe) {
    Write-Host "git.exe not found on this machine. Please install Git for Windows from https://git-scm.com/download/win or open Git Bash (installed with Git)."
    exit 1
}
Write-Host "Found git at: $gitExe"
$gitFolder = Split-Path $gitExe -Parent

# Add to current session PATH if necessary
if (-not ($env:PATH -split ';' | Where-Object { $_ -eq $gitFolder })) {
    Write-Host "Adding $gitFolder to PATH for this session..."
    $env:PATH = $env:PATH + ";" + $gitFolder
}

Write-Host "\n== git version =="
try {
    git --version
} catch {
    Write-Host "git still not available in this session. Try closing and reopening PowerShell, or open Git Bash and run the push commands there."
    exit 1
}

# Verify repo path
if (-not (Test-Path $repoPath)) {
    Write-Host "Repo path $repoPath not found. Update the script variable and try again."
    exit 1
}

Set-Location $repoPath

Write-Host "\n== Remote config =="
git remote -v

Write-Host "\n== Local status =="
git status --porcelain=2 -b

# Ensure there is a commit
$hasHead = $false
try {
    git rev-parse --verify HEAD > $null 2>&1
    if ($LASTEXITCODE -eq 0) { $hasHead = $true }
} catch {}

if (-not $hasHead) {
    Write-Host "No commits found. Creating initial commit..."
    git add .
    git commit -m "Initial commit - add project files"
}

Write-Host "\nAttempting to push 'main' to 'origin' (you may be prompted for credentials)..."
# Run push and capture output
$pushOutput = git push -u origin main 2>&1 | Tee-Object -Variable out
if ($LASTEXITCODE -eq 0) {
    Write-Host "\nPush succeeded. Your files should now be on GitHub: https://github.com/Toothless64652/hng-profile-card"
    exit 0
} else {
    Write-Host "\nPush failed with the following output:\n"
    $out | ForEach-Object { Write-Host $_ }
    Write-Host "\nCommon fixes:\n- If you see authentication errors, create a GitHub Personal Access Token (PAT) at https://github.com/settings/tokens (select 'repo' scope) and use it as the password for HTTPS.
- Or create an SSH key and add it to GitHub, then switch your remote to the SSH URL and push again:
    git remote set-url origin git@github.com:Toothless64652/hng-profile-card.git
    git push -u origin main
"
    exit 1
}
