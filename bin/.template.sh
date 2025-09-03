#!/usr/bin/env sh
#cat << "EndOfScript"
#!/usr/bin/env sh

_self="$(readlink -fn "$0")"
_path="$(dirname "${_self}")"
_file="$(basename "${_self}")"
_name="${_file%.*}"

_cli_common() (
  fn='cli-common.sh'
  [ -f "${_path}/${fn}" ] && echo "${_path}/${fn}" && exit 0
  
  if [ "${_self#$(readlink -fn "${HOME}")/}" = "${_self}" ]; then
    for d in "$(dirname "${_path}")/lib" \
             "${XDG_LIBRARY_HOME:-${XDG_LIB_HOME:-${HOME}/.local/lib}}" \
             "${HOME}/.lib"; do
      [ -d "${d}" ] && [ -f "${d}/${fn}" ] && echo "${d}/${fn}" && exit 0
    done
  else
    for d in /usr/local/lib /usr/lib /lib; do
      [ -d "${d}" ] && [ -f "${d}/${fn}" ] && echo "${d}/${fn}" && exit 0
    done
  fi
  exit 1
)

if ! _common="$(_cli_common)"; then
  echo "Could not locate required 'cli-common.sh'" >&2
  exit 255
fi
. "${_common}"


_lisep="$(tr -dc '[:alnum:]' < /dev/urandom | head -c 16)"

liadd() (
  echo "${1}${_lisep}${2}"
)

liiter() (
)

help_msg="$(cat << EOF
SYNOPSIS:
  ${_file} [OPTIONS] FILE [FILE...]

DESCRIPTION:
  « Enter your description here. »

OPTIONS:
  -h, --help             Show this help text.
  -a, --my-arg   VALUE   « Description on 'my-arg'. See VALUE »

VALUE:
  « A more detailed description on the value for 'my-arg' »

EXAMPLES:
  « The command below does x and y. »
    ${_file} -Ct test
EOF
)"

parse_args() {
  lihead="$(tr -dc '[:alnum:]' < /dev/urandom | head -c 16)"
  help=0
  my_arg=''
  files=''
  
  local active_arg=''
  local parse_args=1
  for arg in "$@"; do
    [ ${parse_args} -gt 0 ] && [ "${arg}" = '--' ] && parse_args=0 && continue
    [ ${parse_args} -le 0 ] && [ "${arg}" = '++' ] && parse_args=1 && continue
    
    [ ${parse_args} -gt 0 ] && [ "${arg#--}" != "${arg}" ] && \
    case "$(echo "${arg#--}" | sed -e 's/_/-/g')" in
      'help')      help=1;;
      'my-arg')    active_arg='my-arg';;
      *) echo "Unrecognized argument '${arg}'." >&2;
         return 1;;
    esac && continue
    
    [ ${parse_args} -gt 0 ] && [ "${arg#-}" != "${arg}" ] && \
    for a in $(echo "${arg#-}" | sed -e 's/\(.\)/\1\n/g' | grep -v '^$'); do
      case "${a}" in
        'h'|'?') help=1;;
        'a')     active_arg='my-arg';;
        *) echo "Unrecognized argument '-${a}'." >&2;
           return 1;;
      esac
    done && continue

    [ -n "${active_arg}" ] && \
    case "${active_arg}" in
      'my-arg')  my_arg="${arg}" && active_arg='';;
      *) echo -n "Coding error, unhandled argument '${active_arg}'." >&2;
         echo    " This should not occur." >&2;
         return 1;;
    esac && continue

    # If positionals aren't used:
    # echo "Orphaned argument '${arg}' encountered." >&2
    # return 1;;
    # If positionals are used:
    files="${files}"'\n'"${}${arg}"
  done
}


for arg in "$@"; do
  [ ${parse_args} -gt 0 ] && [ "${arg}" = '--' ] && parse_args=0 && continue
  [ ${parse_args} -le 0 ] && [ "${arg}" = '++' ] && parse_args=1 && continue
  [ ${parse_args} -gt 0 ] && [ "${arg#--}" != "${arg}" ] && \
  case "$(echo "${arg#--}" | sed -e 's/-/_/g')" in
    'help')      help=1;;
    'force')     force=1;;
    'wipe-disk') wipe_disk=1;;
    'device')    active_arg='device';;
    'partition') active_arg='partition';;
    'vg_name')   active_arg='vg_name';;
    'lv_part')   active_arg='lv_part';;
    'firmware')  active_arg='firmware';;
    *) echo "Unrecognized argument '${arg}'." >&2;
       exit 1;;
  esac && continue
  [ ${parse_args} -gt 0 ] && [ "${arg#-}" != "${arg}" ] && \
  for a in $(echo "${arg#-}" | sed -e 's/\(.\)/\1\n/g'); do
    case "${a}" in
      'h'|'?') help=1;;
      'F')     force=1;;
      'd')     active_arg='device';;
      'p')     active_arg='partition';;
      'g')     active_arg='vg_name';;
      'v')     active_arg='lv_part';;
      'f')     active_arg='firmware';;
      *) echo "Unrecognized argument '-${a}'." >&2;
         exit 1;;
    esac
  done && continue
  [ -n "${active_arg}" ] && \
  case "${active_arg}" in
    'firmware') firmware="${arg}";;
    'vg_name')  vg_name="${arg}";;
    'lv_part')  lv_parts="${lv_parts}${arg};";;
    'device')   devices="${devices}${arg},";;
    *) echo -n "Coding error, unhandled argument '${active_arg}'." >&2;
       echo    " This should not occur." >&2;
       exit 1;;
  esac && continue
  echo "Orphaned argument '${arg}' encountered." >&2
  exit 1;;
done
