#!/bin/bash
# test_quality_gates.sh - Tests for quality_gates.sh

set -e  # Exit on any error

# Get the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
tests_run=0
tests_passed=0

# Test helper functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    tests_run=$((tests_run + 1))
    if [[ "$expected" == "$actual" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        tests_passed=$((tests_passed + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Expected: '$expected'"
        echo "  Actual: '$actual'"
    fi
}

assert_contains() {
    local substring="$1"
    local text="$2"
    local test_name="$3"
    
    tests_run=$((tests_run + 1))
    if [[ "$text" == *"$substring"* ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        tests_passed=$((tests_passed + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Expected '$text' to contain '$substring'"
    fi
}

# Setup test environment
setup_test() {
    # Create temporary directory for tests
    test_dir=$(mktemp -d)
    cd "$test_dir"
    mkdir -p .claude
}

cleanup_test() {
    cd /
    rm -rf "$test_dir"
}

# Source the script to test individual functions
source_quality_gates() {
    # Extract and source just the function definition
    eval "$(sed -n '/^get_quality_gates_path/,/^}/p' "$SCRIPT_DIR/quality_gates.sh")"
}

echo -e "${YELLOW}Running quality_gates.sh tests...${NC}\n"

# Test 1: get_quality_gates_path with no local settings file
setup_test
source_quality_gates
result=$(get_quality_gates_path)
assert_equals "" "$result" "get_quality_gates_path returns empty when no local settings file exists"
cleanup_test

# Test 2: get_quality_gates_path with empty local settings file
setup_test
source_quality_gates
echo '{}' > .claude/settings.claude-constructor.local.json
result=$(get_quality_gates_path)
assert_equals "" "$result" "get_quality_gates_path returns empty when quality-gates-check-path not in local settings"
cleanup_test

# Test 3: get_quality_gates_path with quality-gates-check-path configured
setup_test
source_quality_gates
echo '{"quality-gates-check-path": "./test.sh"}' > .claude/settings.claude-constructor.local.json
result=$(get_quality_gates_path)
assert_equals "./test.sh" "$result" "get_quality_gates_path returns path when configured in local settings"
cleanup_test

# Test 4: get_quality_gates_path with quality-gates-check-path and other settings
setup_test
source_quality_gates
cat > .claude/settings.claude-constructor.local.json << 'EOF'
{
  "other-setting": "value",
  "quality-gates-check-path": "./lint.sh",
  "another-setting": "value2"
}
EOF
result=$(get_quality_gates_path)
assert_equals "./lint.sh" "$result" "get_quality_gates_path works with multiple settings"
cleanup_test

# Test 5: get_quality_gates_path with whitespace in JSON
setup_test
source_quality_gates
echo '{   "quality-gates-check-path"   :   "./validate.py"   }' > .claude/settings.claude-constructor.local.json
result=$(get_quality_gates_path)
assert_equals "./validate.py" "$result" "get_quality_gates_path handles whitespace in JSON"
cleanup_test

# Test 6: Full script execution with no local settings
setup_test
output=$(bash "$SCRIPT_DIR/quality_gates.sh" 2>&1)
assert_contains "Quality gates not configured, skipping" "$output" "Script skips when no local settings"
cleanup_test

# Test 7: Full script execution with configured path but no matching script
setup_test
echo '{"quality-gates-check-path": "./nonexistent.sh"}' > .claude/settings.claude-constructor.local.json
output=$(bash "$SCRIPT_DIR/quality_gates.sh" 2>&1)
assert_contains "Quality gates enabled, searching for './nonexistent.sh'" "$output" "Script searches for configured script"
cleanup_test

# Test 8: Full script execution with working quality gate script
setup_test
echo '{"quality-gates-check-path": "./test.sh"}' > .claude/settings.claude-constructor.local.json
echo '#!/bin/bash' > test.sh
echo 'echo "Quality gate passed"' >> test.sh
chmod +x test.sh
output=$(bash "$SCRIPT_DIR/quality_gates.sh" 2>&1)
assert_contains "Quality gates enabled" "$output" "Script finds and attempts to run quality gate"
assert_contains "Quality gate passed" "$output" "Quality gate script executes successfully"
cleanup_test

# Test results
echo
if [[ $tests_passed -eq $tests_run ]]; then
    echo -e "${GREEN}All tests passed! ($tests_passed/$tests_run)${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed. ($tests_passed/$tests_run passed)${NC}"
    exit 1
fi