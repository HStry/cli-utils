lsmnt() {
  local sort=${LSMNT_SORT:-d}
  local mptn='^\(.*\) on \(.*\) type \([^ ]*\) (\(.*\))$'
  local sptn='\1\t\2\t\3\t\4'
  local mnts="$(mount | sed -e "s/${mptn}/${sptn}/")"
  case "${sort}" in
    d) mnts="$(sort -t$'\t' -k1,2 <<< "${mnts}")";;
    m) mnts="$(sort -t$'\t' -k2,3 <<< "${mnts}")";;
    t) mnts="$(sort -t$'\t' -k3,4 <<< "${mnts}")";;
    o) mnts="$(sort -t$'\t' -k4   <<< "${mnts}")";;
  esac
  local d dc m mc t tc o oc
  dc="$({ echo 'DEVICE';
          awk -F'\t' '{print $1}' <<< "${mnts}"; } | wc -L)"
  mc="$({ echo 'MOUNTPOINT';
          awk -F'\t' '{print $2}' <<< "${mnts}"; } | wc -L)"
  tc="$({ echo 'TYPE';
          awk -F'\t' '{print $3}' <<< "${mnts}"; } | wc -L)"
  oc="$({ echo 'OPTIONS';
          awk -F'\t' '{print $4}' <<< "${mnts}"; } | wc -L)"
  
  local pfmt="%-${dc}s  %-${mc}s  %-${tc}s  %s\n"
  printf "${pfmt}" 'DEVICE' 'MOUNTPOINT' 'TYPE' 'OPTIONS'
  while read line; do
    printf "${pfmt}" \
      "$(awk -F'\t' '{print $1}' <<< "${line}")" \
      "$(awk -F'\t' '{print $2}' <<< "${line}")" \
      "$(awk -F'\t' '{print $3}' <<< "${line}")" \
      "$(awk -F'\t' '{print $4}' <<< "${line}")"
  done <<< "${mnts}"
}
