#!/usr/bin/env sh

_self="$(realpath -s "$0" 2>/dev/null || realpath "$0")" # F* busybox.
_path="$(dirname "${_self}")"
_file="$(basename "${_self}")"
_name="${_file%.*}"

help_msg="$(cat << EOF
SYNOPSIS:
  ${_file} [OPTIONS] FILE [FILE...]

DESCRIPTION:
  A combination of chown, chmod, and touch.

OPTIONS:
  -h, --help                      Show this help text.
  -C, --create                    Create files.
  -P, --parents                   Create complete path.
  -t, --touch                     Update access and modification times.
  -R, --recursive                 Modify ownership and permissions recursively.
      --dereference
      --no-dereference
  -T, --types           TYPESPEC  Only apply changes to path objects of type TYPE[,TYPE...]
  -u, --user            USER
  -g, --group           GROUP
  -m, --mode            MODE
  -f, --reference       FILE

TYPESPEC:
  A selection of object symbols and modifiers.
  f: file            b: block device
  d: directory       c: character deviceq
  h: symbolic link
  
  file
  directory
  symbolic_link

EXAMPLES:
  Update atime/mtime of file 'test', or create it if it doesn't exist.
    ${_file} -Ct test
  
  Update atime/mtime of directory 'test', or create it if it doesn't exist.
    ${_file} -Ct test/

  Change ownership and permissions of a directory recursively if it exists. Do nothing if it doesn't.
    ${_file} -u student -g students -m 
  
  
EOF
)"

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
