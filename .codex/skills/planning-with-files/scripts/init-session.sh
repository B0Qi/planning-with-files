#!/bin/bash
# Initialize .codex-plans and one task directory.
# Usage: ./init-session.sh [task-slug] [task-title]

set -e

DATE=$(date +%Y-%m-%d)
TASK_SLUG="${1:-task-$(date +%Y%m%d-%H%M%S)}"
TASK_TITLE="${2:-$TASK_SLUG}"
BASE_DIR=".codex-plans"
TASK_DIR="$BASE_DIR/$TASK_SLUG"
INDEX_FILE="$BASE_DIR/index.md"

mkdir -p "$TASK_DIR"

if [ ! -f "$INDEX_FILE" ]; then
    cat > "$INDEX_FILE" <<EOF_INDEX
# Task Index

## Active Tasks

| Task | Directory | Status | Started |
|------|-----------|--------|---------|
| $TASK_TITLE | \`$TASK_SLUG/\` | Phase 1/5 | $DATE |

## Current Focus
\`$TASK_SLUG/\` - $TASK_TITLE

## Completed Tasks

| Task | Directory | Completed |
|------|-----------|-----------|
EOF_INDEX
    echo "Created $INDEX_FILE"
else
    if ! grep -q "\`$TASK_SLUG/\`" "$INDEX_FILE"; then
        row="| $TASK_TITLE | \`$TASK_SLUG/\` | Phase 1/5 | $DATE |"
        awk -v row="$row" '
            BEGIN { inserted = 0 }
            {
                print
                if (!inserted && $0 == "|------|-----------|--------|---------|") {
                    print row
                    inserted = 1
                }
            }
            END {
                if (!inserted) {
                    print ""
                    print "## Active Tasks"
                    print ""
                    print "| Task | Directory | Status | Started |"
                    print "|------|-----------|--------|---------|"
                    print row
                }
            }
        ' "$INDEX_FILE" > "$INDEX_FILE.tmp" && mv "$INDEX_FILE.tmp" "$INDEX_FILE"
        echo "Added task row to $INDEX_FILE"
    fi

    focus="\`$TASK_SLUG/\` - $TASK_TITLE"
    awk -v focus="$focus" '
        BEGIN { set_focus = 0 }
        {
            if ($0 == "## Current Focus") {
                print
                if (getline > 0) {
                    print focus
                } else {
                    print focus
                }
                set_focus = 1
                next
            }
            print
        }
        END {
            if (!set_focus) {
                print ""
                print "## Current Focus"
                print focus
            }
        }
    ' "$INDEX_FILE" > "$INDEX_FILE.tmp" && mv "$INDEX_FILE.tmp" "$INDEX_FILE"
    echo "Updated Current Focus in $INDEX_FILE"
fi

if [ ! -f "$TASK_DIR/plan.md" ]; then
    cat > "$TASK_DIR/plan.md" <<'EOF_PLAN'
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
EOF_PLAN
    echo "Created $TASK_DIR/plan.md"
else
    echo "$TASK_DIR/plan.md already exists, skipping"
fi

if [ ! -f "$TASK_DIR/findings.md" ]; then
    cat > "$TASK_DIR/findings.md" <<'EOF_FINDINGS'
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
EOF_FINDINGS
    echo "Created $TASK_DIR/findings.md"
else
    echo "$TASK_DIR/findings.md already exists, skipping"
fi

if [ ! -f "$TASK_DIR/progress.md" ]; then
    cat > "$TASK_DIR/progress.md" <<EOF_PROGRESS
# Progress Log

## Session: $DATE

### Current Status
- **Phase:** 1 - Requirements and Discovery
- **Started:** $DATE

### Actions Taken
-

### Test Results
| Test | Expected | Actual | Status |
|------|----------|--------|--------|

### Errors
| Error | Resolution |
|-------|------------|
EOF_PROGRESS
    echo "Created $TASK_DIR/progress.md"
else
    echo "$TASK_DIR/progress.md already exists, skipping"
fi

echo ""
echo "Planning files initialized in $TASK_DIR"
echo "Files: $INDEX_FILE, $TASK_DIR/plan.md, $TASK_DIR/findings.md, $TASK_DIR/progress.md"
