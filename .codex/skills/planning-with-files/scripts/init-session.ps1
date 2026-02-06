# Initialize .codex-plans and one task directory.
# Usage: .\init-session.ps1 [task-slug] [task-title]

param(
    [string]$TaskSlug = "",
    [string]$TaskTitle = ""
)

$Date = Get-Date -Format "yyyy-MM-dd"
if ([string]::IsNullOrWhiteSpace($TaskSlug)) {
    $TaskSlug = "task-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
}
if ([string]::IsNullOrWhiteSpace($TaskTitle)) {
    $TaskTitle = $TaskSlug
}

$BaseDir = ".codex-plans"
$TaskDir = Join-Path $BaseDir $TaskSlug
$IndexFile = Join-Path $BaseDir "index.md"

New-Item -ItemType Directory -Force -Path $TaskDir | Out-Null

if (-not (Test-Path $IndexFile)) {
@"
# Task Index

## Active Tasks

| Task | Directory | Status | Started |
|------|-----------|--------|---------|
| $TaskTitle | ``$TaskSlug/`` | Phase 1/5 | $Date |

## Current Focus
``$TaskSlug/`` - $TaskTitle

## Completed Tasks

| Task | Directory | Completed |
|------|-----------|-----------|
"@ | Out-File -FilePath $IndexFile -Encoding UTF8
    Write-Host "Created $IndexFile"
}
else {
    $content = Get-Content $IndexFile -Raw
    $taskRef = "``$TaskSlug/``"

    if ($content -notmatch [regex]::Escape($taskRef)) {
        $row = "| $TaskTitle | $taskRef | Phase 1/5 | $Date |"
        $content = $content -replace "\|------\|-----------\|--------\|---------\|", "|------|-----------|--------|---------|`n$row"
    }

    $focusLine = "$taskRef - $TaskTitle"
    if ($content -match "## Current Focus\r?\n") {
        $content = [regex]::Replace($content, "## Current Focus\r?\n.*", "## Current Focus`n$focusLine")
    }
    else {
        $content += "`n`n## Current Focus`n$focusLine`n"
    }

    $content | Out-File -FilePath $IndexFile -Encoding UTF8
    Write-Host "Updated $IndexFile"
}

$planFile = Join-Path $TaskDir "plan.md"
if (-not (Test-Path $planFile)) {
@"
# Task: [Brief Description]

## Goal
[One sentence describing the end state]

## Current Phase
Phase 1

## Phases

### Phase 1: Requirements and Discovery
- [ ] Understand user intent
- [ ] Identify constraints
- [ ] Document findings in findings.md
- **Status:** in_progress

### Phase 2: Planning and Structure
- [ ] Define approach
- [ ] Create structure
- **Status:** pending

### Phase 3: Implementation
- [ ] Execute plan
- [ ] Validate incrementally
- **Status:** pending

### Phase 4: Testing and Verification
- [ ] Verify requirements met
- [ ] Document test results in progress.md
- **Status:** pending

### Phase 5: Delivery
- [ ] Review outputs
- [ ] Deliver to user
- **Status:** pending

## Decisions Made
| Decision | Rationale |
|----------|-----------|
|          |           |

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
|       | 1       |            |
"@ | Out-File -FilePath $planFile -Encoding UTF8
    Write-Host "Created $planFile"
}

$findingsFile = Join-Path $TaskDir "findings.md"
if (-not (Test-Path $findingsFile)) {
@"
# Findings and Decisions

## Requirements
-

## Research Findings
-

## Technical Decisions
| Decision | Rationale |
|----------|-----------|
|          |           |

## Issues Encountered
| Issue | Resolution |
|-------|------------|
|       |            |

## Resources
-
"@ | Out-File -FilePath $findingsFile -Encoding UTF8
    Write-Host "Created $findingsFile"
}

$progressFile = Join-Path $TaskDir "progress.md"
if (-not (Test-Path $progressFile)) {
@"
# Progress Log

## Session: $Date

### Current Status
- **Phase:** 1 - Requirements and Discovery
- **Started:** $Date

### Actions Taken
-

### Test Results
| Test | Expected | Actual | Status |
|------|----------|--------|--------|

### Errors
| Error | Resolution |
|-------|------------|
"@ | Out-File -FilePath $progressFile -Encoding UTF8
    Write-Host "Created $progressFile"
}

Write-Host ""
Write-Host "Planning files initialized in $TaskDir"
Write-Host "Files: $IndexFile, $planFile, $findingsFile, $progressFile"
