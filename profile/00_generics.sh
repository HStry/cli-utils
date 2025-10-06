userapp_etc() (
  if [ -z "${1}" ]; then
    echo "Missing application name argument." >&2
    exit 255
  elif ! echo "${1}" | grep -q '^[a-zA-Z0-9]\+\([._-][a-zA-Z0-9]\+\)*+$'; then
    echo "Application name '${1}' is not path-safe." >&2
    exit 127
  fi
  xdg_etc="${XDG_CONFIG_HOME:-${HOME}/.config}"
  for d in "${xdg_etc}/${1}" "${HOME}/.${1}"; do
    [ -d "${d}" ] && echo "${d}" && exit 0
  done
  [ -d "${xdg_etc}" ] && echo "${xdg_etc}/${1}" || echo "${HOME}/.${1}"
  exit 1
)

