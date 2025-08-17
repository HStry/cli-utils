# Source me!

istrue() (
  [ -z "${1}" ] && exit 1
  if echo "${1}" | grep -q '^\(0\|\(- \?\)\?[1-9][0-9]*\)$'; then
    [ ${1} -gt 0 ] && exit 0 || exit 1
  fi
  echo 'TRUE' | grep -qi "^${1}.\?\$" && exit 0
  echo 'YES' | grep -qi "^${1}.*\$" && exit 0
  exit 1
)

hasline() (
  m="$(echo "${1}" | grep -F "${2}")"
  [ "${m}" = "${2}" ]
)

if uname -a | grep -qi '\(^mingw\|microsoft\)'; then
  WINSYS=1
else
  WINSYS=0
fi

