# Check if all phases in the active plan are complete.
# Usage: .\check-complete.ps1 [plan-file]

param(
    [string]$PlanFile = ""
)

function Resolve-PlanFromIndex {
    $indexFile = ".codex-plans/index.md"
    if (-not (Test-Path $indexFile)) {
        return ""
    }

    $lines = Get-Content $indexFile
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -eq "## Current Focus" -and $i + 1 -lt $lines.Count) {
            $focusLine = $lines[$i + 1]
            $match = [regex]::Match($focusLine, '`([^`]+)/`')
            if ($match.Success) {
                return ".codex-plans/$($match.Groups[1].Value)/plan.md"
            }
        }
    }

    return ""
}

if ([string]::IsNullOrWhiteSpace($PlanFile)) {
    $PlanFile = Resolve-PlanFromIndex
}

if ([string]::IsNullOrWhiteSpace($PlanFile) -and (Test-Path "task_plan.md")) {
    $PlanFile = "task_plan.md"
}

if ([string]::IsNullOrWhiteSpace($PlanFile) -or -not (Test-Path $PlanFile)) {
    Write-Host "ERROR: Plan file not found"
    Write-Host "Provide a path: .\check-complete.ps1 .codex-plans\<task>\plan.md"
    exit 1
}

Write-Host "=== Task Completion Check ==="
Write-Host "Plan file: $PlanFile"
Write-Host ""

$content = Get-Content $PlanFile -Raw
$TOTAL = ([regex]::Matches($content, "### Phase")).Count
$COMPLETE = ([regex]::Matches($content, "\*\*Status:\*\* complete")).Count
$IN_PROGRESS = ([regex]::Matches($content, "\*\*Status:\*\* in_progress")).Count
$PENDING = ([regex]::Matches($content, "\*\*Status:\*\* pending")).Count

Write-Host "Total phases:   $TOTAL"
Write-Host "Complete:       $COMPLETE"
Write-Host "In progress:    $IN_PROGRESS"
Write-Host "Pending:        $PENDING"
Write-Host ""

if ($TOTAL -gt 0 -and $COMPLETE -eq $TOTAL) {
    Write-Host "ALL PHASES COMPLETE"
    exit 0
}

Write-Host "TASK NOT COMPLETE"
Write-Host "Do not stop until all phases are complete."
exit 1
