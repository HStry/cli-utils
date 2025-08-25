lsmnt() (
  TAB="$(printf '\t')"  # sh requires '\t'; bash requires $'\t'. This works for both.
  sort="${LSMNT_SORT:-d}"
  mptn='^\(.*\) on \(.*\) type \([^ ]*\) (\(.*\))$'
  sptn='\1'"${TAB}"'\2'"${TAB}"'\3'"${TAB}"'\4'
  mnts="$(mount | sed -e "s/${mptn}/${sptn}/")"
  case "${sort}" in
    d) mnts="$(echo "${mnts}" | sort -t "${TAB}" -k1,2)";;
    m) mnts="$(echo "${mnts}" | sort -t "${TAB}" -k2,3)";;
    t) mnts="$(echo "${mnts}" | sort -t "${TAB}" -k3,4)";;
    o) mnts="$(echo "${mnts}" | sort -t "${TAB}" -k4)";;
  esac
  
  dc="$({ echo 'DEVICE';
          echo "${mnts}" | awk -F "${TAB}" '{print $1}'; } | wc -L)"
  mc="$({ echo 'MOUNTPOINT';
          echo "${mnts}" | awk -F "${TAB}" '{print $2}'; } | wc -L)"
  tc="$({ echo 'TYPE';
          echo "${mnts}" | awk -F "${TAB}" '{print $3}'; } | wc -L)"
  oc="$({ echo 'OPTIONS';
          echo "${mnts}" | awk -F "${TAB}" '{print $4}'; } | wc -L)"
  
  pfmt="%-${dc}s  %-${mc}s  %-${tc}s  %s\n"
  printf "${pfmt}" 'DEVICE' 'MOUNTPOINT' 'TYPE' 'OPTIONS'
  echo "${mnts}" \
  | while read line; do
      printf "${pfmt}" \
        "$(echo "${line}" | awk -F "${TAB}" '{print $1}')" \
        "$(echo "${line}" | awk -F "${TAB}" '{print $2}')" \
        "$(echo "${line}" | awk -F "${TAB}" '{print $3}')" \
        "$(echo "${line}" | awk -F "${TAB}" '{print $4}')"
    done
)
