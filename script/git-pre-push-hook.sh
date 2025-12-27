#!/run/current-system/sw/bin/zsh

# This script prevents pushing if any commit message
# matches ^\w+!, ie: special commits like fixup!, squash!, etc.

remote="$1"
url="$2"

# Get all commits that would be pushed
local all_commits=()
local ref_count=0

# Read all refs from stdin
while read local_ref local_sha remote_ref remote_sha; do
	((ref_count++))

	if [[ "$local_sha" == "0000000000000000000000000000000000000000" ]]; then
		continue  # Skip deletes
	fi

	# Determine range
	local range
	if [[ "$remote_sha" == "0000000000000000000000000000000000000000" ]]; then
		range="$local_sha"
	else
		range="$remote_sha..$local_sha"
	fi

	# Get commits for this ref
	local commits
	commits=$(git log --format="%H %s" "$range" 2>/dev/null)

	if [[ -n "$commits" ]]; then
		all_commits+=("${(@f)commits}")
	fi
done

if [[ $ref_count -eq 0 ]]; then
	# No refs to push
	exit 0
fi

if [[ ${#all_commits} -eq 0 ]]; then
	# ✅ No commits to push
	exit 0
fi

echo "Checking ${#all_commits} commits..."

# Check all commits
for line in "${all_commits[@]}"; do
	local commit_hash="${line%% *}"
	local subject="${line#* }"

	if [[ "$subject" =~ '^[[:alnum:]_]+!' ]]; then
		echo "Autosquashing commit: $subject"
		echo "Refusing to push commits with fixup!, squash!, etc. prefixes"
		echo "Use 'git rebase -i --autosquash' to fix these commits"
		exit 1
	fi
done

echo "All good, pushing"
exit 0
