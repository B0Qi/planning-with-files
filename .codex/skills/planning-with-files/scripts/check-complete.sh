#!/bin/bash
# Check if all phases in the active plan are complete.
# Usage: ./check-complete.sh [plan-file]

resolve_plan_from_index() {
    local index_file=".codex-plans/index.md"
    [ -f "$index_file" ] || return 1
    local focus_line
    local slug
    focus_line="$(sed -n '/^## Current Focus$/{n;p;}' "$index_file" | head -n 1)"
    slug="$(printf '%s\n' "$focus_line" | sed -n 's/.*`\([^`]*\)\/`.*/\1/p')"
    [ -n "$slug" ] || return 1
    printf '.codex-plans/%s/plan.md\n' "$slug"
}

PLAN_FILE="${1:-}"

if [ -z "$PLAN_FILE" ]; then
    PLAN_FILE="$(resolve_plan_from_index 2>/dev/null || true)"
fi

if [ -z "$PLAN_FILE" ] && [ -f "task_plan.md" ]; then
    PLAN_FILE="task_plan.md"
fi

if [ -z "$PLAN_FILE" ]; then
    set -- .codex-plans/*/plan.md
    if [ -e "$1" ]; then
        PLAN_FILE="$1"
    fi
fi

if [ -z "$PLAN_FILE" ] || [ ! -f "$PLAN_FILE" ]; then
    echo "ERROR: Plan file not found"
    echo "Provide a path: ./check-complete.sh .codex-plans/<task>/plan.md"
    exit 1
fi

echo "=== Task Completion Check ==="
echo "Plan file: $PLAN_FILE"
echo ""

TOTAL=$(grep -c "### Phase" "$PLAN_FILE" || true)
COMPLETE=$(grep -cF "**Status:** complete" "$PLAN_FILE" || true)
IN_PROGRESS=$(grep -cF "**Status:** in_progress" "$PLAN_FILE" || true)
PENDING=$(grep -cF "**Status:** pending" "$PLAN_FILE" || true)

# Fallback: support inline phase markers like [complete], [in_progress], [pending]
if [ "$COMPLETE" -eq 0 ] && [ "$IN_PROGRESS" -eq 0 ] && [ "$PENDING" -eq 0 ]; then
    COMPLETE=$(grep -c "\[complete\]" "$PLAN_FILE" || true)
    IN_PROGRESS=$(grep -c "\[in_progress\]" "$PLAN_FILE" || true)
    PENDING=$(grep -c "\[pending\]" "$PLAN_FILE" || true)
fi

: "${TOTAL:=0}"
: "${COMPLETE:=0}"
: "${IN_PROGRESS:=0}"
: "${PENDING:=0}"

echo "Total phases:   $TOTAL"
echo "Complete:       $COMPLETE"
echo "In progress:    $IN_PROGRESS"
echo "Pending:        $PENDING"
echo ""

if [ "$TOTAL" -gt 0 ] && [ "$COMPLETE" -eq "$TOTAL" ]; then
    echo "ALL PHASES COMPLETE"
    exit 0
fi

echo "TASK NOT COMPLETE"
echo "Do not stop until all phases are complete."
exit 1
