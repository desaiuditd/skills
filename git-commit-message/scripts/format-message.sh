#!/usr/bin/env bash
set -euo pipefail

main() {
  local line_num=0
  local in_footer=false

  while IFS= read -r line || [[ -n "$line" ]]; do
    line_num=$(( line_num + 1 ))

    if [[ $line_num -eq 1 ]]; then
      [[ ${#line} -gt 72 ]] && echo "WARNING: Subject line is ${#line} chars (limit: 72)" >&2
      printf '%s\n' "$line"
      continue
    fi

    if [[ $line_num -eq 2 ]]; then
      printf '%s\n' "$line"
      continue
    fi

    if [[ "$line" =~ ^[A-Za-z-]+:[[:space:]] ]] || [[ "$line" =~ ^\[.*\]: ]]; then
      in_footer=true
    fi

    if [[ "$in_footer" == true ]] || [[ -z "$line" ]] || [[ "$line" =~ https?:// ]]; then
      printf '%s\n' "$line"
      continue
    fi

    printf '%s\n' "$line" | fold -s -w 72 | sed 's/ *$//'
  done
}

main
