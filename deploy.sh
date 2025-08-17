#!/usr/bin/env sh

_realself="$(realpath -m "$0")"
_realpath="$(dirname "${_realself}")"

_ismode() (
  '[ugoa]*\([-+=]\([rwxXst]*\|[ugo]\)\)+\|[-+=][0-7]+'
)

_ismode() (
  isperm() (
    echo "$1" | grep -q '^[ugo]$' && exit 0
    echo "$1" | grep -q '^[rwxXst]\{1,6\}$' || exit 1
    dups="$(echo "$1" \
            | sed -z -e 's/\(.\)/\1\n/g' -e 's/\s*$//' \
            | uniq -d)"
    [ -z "${dups}" ]
  )
  echo "$1" | grep -q '^[0-7]\{1,4\}$' && exit 0
  fields="$(echo "$1" | awk -F, '{print NF}')" || exit 1
  [ ${fields} -gt 3 ] && exit 1
  for i in $(seq 1 ${fields}); do
    field="$(echo "$1" \
             | awk -F, '{print $'"${i}"'}' \
             | sed -e 's/\([augo]*[=+-]\)\?\([ugorwxXst]\+\)/\1,\2/' \
                   -e 's/^\([augo]*\)\?\([=+-]\)\?,/\1,\2,/' \
                   -e 's/^,/a,/' -e 's/,,/,=,/')"
    t="$(echo "${field}" | awk -F, '{print $1}')"
    o="$(echo "${field}" | awk -F, '{print $2}')"
    m="$(echo "${field}" | awk -F, '{print $3}')"
    echo "field: '${field}'"
    echo "  t:   '${t}'"
    echo "  o:   '${o}'"
    echo "  m:   '${m}'"
  done
)

xtouch() (
  local u g m r
  [ "$1" != '--' ] && u="$(getent passwd "$1" | awk -F: '{print $3}')" && shift
  [ "$1" != '--' ] && g="$(getent group "$1" | awk -F: '{print $3}')" && shift
  [ "$1" != '--' ] && ismode "$1" && m="$1" && shift
  [ "$1" = '--' ]  && shift
  [ -z "${m}" ] && [ -n "${reference}" ] && [ -e "${reference}" ] && r="${reference}"
  
  touch "$@"
  [ -n "${u}" ] && chown  ${u}  "$@"
  [ -n "${g}" ] && chgrp  ${g}  "$@"
  [ -n "${m}" ] && chmod "${m}" "$@"
  [ -n "${r}" ] && chmod --reference="${r}" "$@"
(

choose_dir() (
  echo "$1" | while IFS= read d; do
    [ -n "${d}" ] && [ -d "${d}" ] && echo "${d}" && exit 0
  done
  exit 1
)
xdg_lib_home() (
  _options() (
    [ -n "${XDG_LIBRARY_HOME}" ] && echo "${XDG_LIBRARY_HOME}"
    [ -n "${XDG_LIB_HOME}" ]     && echo "${XDG_LIB_HOME}"
    [ -n "${XDG_DATA_HOME}" ]    && echo "$(dirname "${XDG_DATA_HOME}")/lib"
    [ -n "${XDG_STATE_HOME}" ]   && echo "$(dirname "${XDG_STATE_HOME}")/lib"
    echo "${HOME}/.local/lib"
    echo "${HOME}/.lib"
    echo "${HOME}/lib"
  )
  choose_dir "$(_options)" || exit $?
)
xdg_bin_home() (
  _options() (
    [ -n "${XDG_BINARY_HOME}" ] && echo "${XDG_BINARY_HOME}"
    [ -n "${XDG_BIN_HOME}" ]    && echo "${XDG_BIN_HOME}"
    [ -n "${XDG_DATA_HOME}" ]   && echo "$(dirname "${XDG_DATA_HOME}")/bin"
    [ -n "${XDG_STATE_HOME}" ]  && echo "$(dirname "${XDG_STATE_HOME}")/bin"
    echo "${HOME}/.local/bin"
    echo "${HOME}/.bin"
    echo "${HOME}/bin"
  )
  choose_dir "$(_options)" || exit $?
)

if [ $(id -u) -gt 0 ]; then
  _lib_root="$(realpath -m "$(xdg_lib_home)")"
  _bin_root="$(realpath -m "$(xdg_bin_home)")"
else
  _lib_root='/usr/local/lib'
  _bin_root='/usr/local/bin'
fi

o="$(id -u):$(id -g)"
for f in "${_realpath}/lib/*"; do
  t="${_lib_root}/$(basename "${f}")"
  touch "${t}"
  chown "${o}" "${t}"
  chmod 644 "${t}"
  
  sed -e 's/%%LIBRARY_ROOT%%/'"${_lib_root}"'/g' \
      -e 's/%%BINARY_ROOT%%/'"${_bin_root}"'/g' \
      "${f}" \
  > "${t}"
done

for f in "${_realpath}/bin/*"; do
  t="${_bin_root}/$(basename "${f}")"
  touch "${t}"
  chown "${o}" "${t}"
  chmod 755 "${t}"
  
  sed -e 's/%%LIBRARY_ROOT%%/'"${_lib_root}"'/g' \
      -e 's/%%BINARY_ROOT%%/'"${_bin_root}"'/g' \
      "${f}" \
  > "${t}"
done
















