# Source me!

_li_sep=

isint() (
  [ -n "${1}" ] && echo "$1" | grep -q '^\(0\|-\?[1-9][0-9]*\)$'
)

tobool() (
  [ -z "${1}" ] || [ $(echo "${1}" | wc -l) -gt 1 ] && exit 1

  if isint "${1}"; then
    [ ${1} -ne 0 ] && echo 'true' || echo 'false'
    exit 0
  fi
  case "${1}" in
    'false'|'False'|'FALSE'|'n'|'N'|'no'|'No'|'NO'|'-') echo 'false';;
    'true'|'True'|'TRUE'|'y'|'Y'|'yes'|'Yes'|'YES'|'+') echo 'true';;
    *) exit 1;;
  esac
)

istrue() (
  b="$(tobool "${1}")" && [ "${b}" = 'true' ]
)

isfalse() (
  b="$(tobool "${1}")" && [ "${b}" = 'false' ]
)

li_add() (
  [ -n "${1}" ] && echo "${1}"; shift
  for a in "$@"; do
    echo "${_li_sep}${2}"
  done
)

li_len() (
  echo "${1}" | grep -c "^${_li_sep}"
)

li_item() (
  if ! isnum "${2}"; then
    echo "Provided index is not numeric." >&2
    exit 1
  fi
  len=$(li_len
  isnum "${2}" || exit 1
  [ ${2} -lt $(li_len "${1}") ] || exit 1
  linenums="$(echo "${1}" | grep -n "^${_li_sep}" \
              | tail -n +$(( ${2} + 1 )) | head -n 2 \
              | awk -F: '{print $1}')"
  a=$(echo "${linenums}" | head -n 1)
  b=$(( $(echo "${linenums}" | head -n 1)"
  n="${2}"
)

li_iter() (
  li="${1}"
  
)








_set_li_sep() {
  if [ "${#LI_SEP}" -ge 4 ] && echo "${LI_SEP}" | grep -q '^[a-zA-Z0-9]$'; then
    _li_sep="${LI_SEP}"
    return 0
  if isint "${LI_SEPLEN}" && [ ${LI_SEPLEN} -ge 4 ]; then
    _li_seplen="${LI_SEPLEN}"
  else
    _li_seplen=16
  fi
  _li_sep="$(tr -dc '[:alnum:]' < /dev/urandom | head -c ${_li_seplen})"
}


if isint "${LI_SEPLEN}" && [ ${LI_SEPLEN} -ge 4 ]; then
  _li_seplen="${LI_SEPLEN}"
else
  _li_seplen=16
fi

_li_sep="$(tr -dc '[:alnum:]' < /dev/urandom | head -c 16)"






hasline() (
  m="$(echo "${1}" | grep -F "${2}")"
  [ "${m}" = "${2}" ]
)

if uname -a | grep -qi '\(^mingw\|microsoft\)'; then
  WINSYS=1
else
  WINSYS=0
fi

