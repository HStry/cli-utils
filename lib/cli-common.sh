# Source me!

_wc() (
  fmt='lines=%d\nchars=%d\n'
  if [ -z "${1}" ]; then
    lines=0
    chars=0
  else
    . <(echo "${1}" \
        | wc -lm \
        | sed -e 's/^\s*/lines=/' \
              -e 's/\s\+/\nchars=/' \
              -e 's/\s*$//')
  fi
  printf "${fmt}" "${lines}" "${chars}"
)

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

_li_init() {
  [ -n "${_LI_SEP}" ] && return 0
  _LI_SEP="$(cat /dev/urandom \
             | LC_ALL=C tr -dc '[:alnum:]' \
             | head -c 24)"
}

__li_initialized() (
  [ -n "${_LI_SEP}" ] || exit 1
  [ ${#_LI_SEP} -ge 12 ] || exit 2
  [ "$(echo "${_LI_SEP}" | LC_ALL=C tr -dc '[:alnum:]')" = "${_LI_SEP}" ] || exit 3
)
_li_initialized() (
  __li_initialized && exit 0 || ec=$?
  case $ec in
    1) echo "list function not initialized - run '_li_init'." >&2;;
    2) echo "list separator is too short." >&2;;
    3) echo "list separator contains non-alphanumeric characters." >&2;;
  esac
  exit $ec
)

__li_identify() (
  _li_initialized || exit $?
  [ -n "${1}" ] || exit 1
  [ ]
)

_li_identify() (
  if ! [ "$(echo "${1}" | head -n 1)" = "${_LI_SEP}" ]; then
    echo "Object provided is not a list." >&2
    exit 1
  fi
)

li_len() (
  _li_initialized || exit $?
  _li_identify "${1}" || exit $?
  echo "${1}" | grep -c "^${_LI_SEP}\$"
)

li_add() (
  _li_initialized || exit $?
  for el in "$@"; do
    _li_identify "${el}" 2> /dev/null || echo "${_LI_SEP}"
    echo "${el}"
  done
)

_li_normalize_index() (
  

)

li_index() (
  _len=$(li_len "$1") || exit $?
  if [ ${2} -ge ${_len} ] || [ $(( ${_len} + ${n} )) -lt 0 ]; then
    echo "Index '${2}' not available in list." >&2
    exit 1
  fi
  [ ${2} -lt 0 ] && n="$(( ${_len} - ${n} ))" || n="${2}"
  
)

li_iter() (
  _li_initialized || exit $?
  _li_identify "${1}" || exit $?
  li="${1}"
  while [ $(echo "${li}" | grep ) -ge 2 ]
  
)


li_del() (
  _li_initialized || exit $?
)

li_slice() (
  _li_initialized || exit $?
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

