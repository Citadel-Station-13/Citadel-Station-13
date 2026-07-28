# Set all convenience variables and loads dependencies.
#
# bootstrap_dir = directory to /tools/bootstrap
# invoke_dir = where we were ran from
# context_dir = directory to /tools which is where all our scripts/whatnot should be running from.
# cache_dir = where to store bootstrap'd data/scripts/etc.
function initialize_bootstrap () {
	bootstrap_dir="$(dirname "$0")"
	invoke_dir="$PWD"
	context_dir="$(dirname "$bootstrap_dir")"
	cache_dir="$bootstrap_dir/.cache"

	# echo "bootstrap-common: bootstrap in $bootstrap_dir"
	# echo "bootstrap-common: invoked from $invoke_dir"
	# echo "bootstrap-common: context in $context_dir"

	source "$bootstrap_dir/../../dependencies.sh"
}
