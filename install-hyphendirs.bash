# link stuff beginning with dot-* into ~/.,
# the other files are accessible in ~/.dotfiles/
#
USAGE='<sourcedir> [<targetdir>] <linkbasedir>'

set -e
set -u

CWD=$(pwd)

die() {
	echo "$@" >&2
	exit 1
}

SOURCEDIR=
TARGETDIR=
# linkbase is a directory where symlinks are written to (besides $HOME)
LINKBASE=

case "$#" in
	1)
		SOURCEDIR='.'
		TARGETDIR="$1"
		LINKBASE=""
		;;
	2)
		SOURCEDIR="$1"
		TARGETDIR="$2"
		LINKBASE=""
		;;
	3)
		SOURCEDIR="$1"
		TARGETDIR="$2"
		LINKBASE="$3"
		;;
	*)
		die "usage: $USAGE"
		;;
esac

for d in "$SOURCEDIR" "$TARGETDIR" "$LINKBASE"; do
	[ -n "$d" ] || continue
	[ -d "$d" ] || die "Err: directory doesn't exists '$d'"
done

if [ -n "$LINKBASE" ]; then
	CWDBASE=$(basename "$CWD")
	rm -f "$LINKBASE"/."$CWDBASE"
	ln -s "$CWD" "$LINKBASE"/."$CWDBASE"

	rm -f "$LINKBASE"/"$CWDBASE"
	ln -s "$CWD" "$LINKBASE"/"$CWDBASE"
fi

calc_hyphenfolder() {
	local folder="$1" # input folder, not a path
	local target="${2:-}"

	local dir=
	case "$folder" in
		-*) die "Err: invalid folder " ;;
		*-) die "Err: invalid folder " ;;
		dot-*)
			afterdot=${folder#*-}
			case "$afterdot" in
				files-* | file-*) die "Err: invalid dot dir '$folder'" ;;
				files | file) dir="." ;;
				*) dir=".$afterdot/" ;;
			esac
			;;
		*)
			dir="$folder/"
			;;
	esac
	local res="${dir//-/\/}"

	if [ -n "$target" ]; then
		if [ "$target" = "$HOME"/. ]; then
			echo "$target$res"
		else
			echo "$target/$res"
		fi

	else
		echo "$res"
	fi
}

install_hyphendirs() {
	local sourcedir="$1"
	local targetdir="$2"
	local basedir="${3:-}"

	local install=
	if [ -n "$basedir" ]; then
		install=$(calc_hyphenfolder "$basedir" "$targetdir")
	else
		install=$(calc_hyphenfolder "$sourcedir" "$targetdir")
	fi

	case "$install" in
		*.) : ;;
		*) mkdir -p "$install" ;;
	esac

	for i in "$sourcedir"/*; do
		[ -e "$i" ] || continue
		bn=$(basename "$i")
		if [ -d "$i" ]; then
			case "$bn" in
				*-*)
					install_hyphendirs "$i" "$install" "$bn"
					;;
				*)
					:
					;;
			esac
		elif [ -f "$i" ]; then
			local rpath=
			rpath="$(realpath "$i")"
			rm -f "$install$bn"
			echo "link: $rpath $install$bn"
			ln -s "$rpath" "$install$bn"

		else
			echo "Warn: invalid file in $i"
		fi
	done

}

for d in "$SOURCEDIR"/*; do
	[ -d "$d" ] || continue
	bd=$(basename "$d")
	case "$bd" in
		*-*) install_hyphendirs "$bd" "$TARGETDIR" ;;
		*) : ;;
	esac
done
