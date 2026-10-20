ARTIFACTS_DIR="${ARTIFACTS_DIR:-artifacts}"

cmd="${1:-}"
if [ -z "$cmd" ]; then
  echo "Usage: artifacts.sh <status|unconverted-decs|unconverted-specs|next-tasks|context <TASK-id>|verify-links>" >&2
  exit 2
fi

case "$cmd" in
  status)
    mkdir -p "$ARTIFACTS_DIR"
    for f in context.md decisions.md specs.md plan.md; do
      if [ ! -f "$ARTIFACTS_DIR/$f" ]; then
        touch "$ARTIFACTS_DIR/$f"
      fi
    done

    context_status="none"
    if [ -s "$ARTIFACTS_DIR/context.md" ]; then
      context_status="present"
    fi

    dec_count=$(awk '/^[[:space:]]*- \[ \] DEC-[0-9A-Za-z_-]+/ { c++ } END { print c + 0 }' "$ARTIFACTS_DIR/decisions.md")
    spec_count=$(awk '/^[[:space:]]*- \[ \] SPEC-[0-9A-Za-z_-]+/ { c++ } END { print c + 0 }' "$ARTIFACTS_DIR/specs.md")
    task_count=$(awk '/^[[:space:]]*- \[ \] TASK-[0-9A-Za-z_-]+/ { c++ } END { print c + 0 }' "$ARTIFACTS_DIR/plan.md")

    printf "CONTEXT:%s DEC:%s SPEC:%s TASK:%s\n" "$context_status" "$dec_count" "$spec_count" "$task_count"
    ;;

  unconverted-decs)
    if [ ! -f "$ARTIFACTS_DIR/decisions.md" ]; then
      echo "NONE"
      exit 0
    fi
    matches=$(awk '/^[[:space:]]*- \[ \] DEC-[0-9A-Za-z_-]+/ { print }' "$ARTIFACTS_DIR/decisions.md")
    if [ -z "$matches" ]; then
      echo "NONE"
    else
      printf "%s\n" "$matches"
    fi
    ;;

  unconverted-specs)
    if [ ! -f "$ARTIFACTS_DIR/specs.md" ]; then
      echo "NONE"
      exit 0
    fi
    matches=$(awk '/^[[:space:]]*- \[ \] SPEC-[0-9A-Za-z_-]+/ { print }' "$ARTIFACTS_DIR/specs.md")
    if [ -z "$matches" ]; then
      echo "NONE"
    else
      printf "%s\n" "$matches"
    fi
    ;;

  next-tasks)
    if [ ! -f "$ARTIFACTS_DIR/plan.md" ]; then
      echo "NONE"
      exit 0
    fi

    declare -A done_tasks
    re_done="^[[:space:]]*-[[:space:]]*\[[xX]\][[:space:]]+(TASK-[0-9A-Za-z_-]+)"
    re_todo="^[[:space:]]*-[[:space:]]*\[[[:space:]]\][[:space:]]+(TASK-[0-9A-Za-z_-]+)"
    re_block="\(blocked-by:[[:space:]]*([^)]+)\)"

    while IFS= read -r line || [ -n "$line" ]; do
      if [[ "$line" =~ $re_done ]]; then
        done_tasks["${BASH_REMATCH[1]}"]=1
      fi
    done < "$ARTIFACTS_DIR/plan.md"

    found=0
    while IFS= read -r line || [ -n "$line" ]; do
      if [[ "$line" =~ $re_todo ]]; then
        blocked=0
        if [[ "$line" =~ $re_block ]]; then
          deps_clean="${BASH_REMATCH[1]//,/ }"
          read -r -a deps_arr <<< "$deps_clean"
          for dep in "${deps_arr[@]}"; do
            if [ -z "$dep" ] || [ "$dep" = "none" ] || [ "$dep" = "NONE" ]; then
              continue
            fi
            if [ -z "${done_tasks["$dep"]:-}" ]; then
              blocked=1
              break
            fi
          done
        fi
        if [ "$blocked" -eq 0 ]; then
          printf "%s\n" "$line"
          found=1
        fi
      fi
    done < "$ARTIFACTS_DIR/plan.md"

    if [ "$found" -eq 0 ]; then
      echo "NONE"
    fi
    ;;

  context)
    target_task="${2:-}"
    if [ -z "$target_task" ]; then
      echo "Error: TASK-id required for context subcommand" >&2
      exit 2
    fi

    if [ -s "$ARTIFACTS_DIR/context.md" ]; then
      awk '
        /^## Commands/ { in_commands=1; print; next }
        in_commands && /^## / { in_commands=0 }
        in_commands { print }
      ' "$ARTIFACTS_DIR/context.md"
    fi

    task_line=""
    if [ -f "$ARTIFACTS_DIR/plan.md" ]; then
      re_task="^[[:space:]]*-[[:space:]]*\[[xX[:space:]]\][[:space:]]+${target_task}([[:space:]]|:|\\[|$)"
      while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" =~ $re_task ]]; then
          task_line="$line"
          break
        fi
      done < "$ARTIFACTS_DIR/plan.md"
    fi

    if [ -n "$task_line" ]; then
      printf "%s\n" "$task_line"

      spec_ids=$(echo "$task_line" | awk '{
        while (match($0, /SPEC-[0-9A-Za-z_-]+/)) {
          print substr($0, RSTART, RLENGTH)
          $0 = substr($0, RSTART + RLENGTH)
        }
      }' | sort -u)

      dec_ids=$(echo "$task_line" | awk '{
        while (match($0, /DEC-[0-9A-Za-z_-]+/)) {
          print substr($0, RSTART, RLENGTH)
          $0 = substr($0, RSTART + RLENGTH)
        }
      }')
      while IFS= read -r s_id; do
        [ -z "$s_id" ] && continue
        re_spec="^[[:space:]]*-[[:space:]]*\[[xX[:space:]]\][[:space:]]+${s_id}([[:space:]]|:|\\[|$)"
        while IFS= read -r s_line || [ -n "$s_line" ]; do
          if [[ "$s_line" =~ $re_spec ]]; then
            printf "%s\n" "$s_line"
            spec_decs=$(echo "$s_line" | awk '{
              while (match($0, /DEC-[0-9A-Za-z_-]+/)) {
                print substr($0, RSTART, RLENGTH)
                $0 = substr($0, RSTART + RLENGTH)
              }
            }')
            dec_ids="$dec_ids $spec_decs"
            break
          fi
        done < "$ARTIFACTS_DIR/specs.md"
      done <<< "$spec_ids"

      if [ -n "$dec_ids" ]; then
        unique_decs=$(echo "$dec_ids" | tr " " "\n" | grep -E "^DEC-" | sort -u || true)
        while IFS= read -r d_id; do
          [ -z "$d_id" ] && continue
          re_dec="^[[:space:]]*-[[:space:]]*\[[xX[:space:]]\][[:space:]]+${d_id}([[:space:]]|:|\\[|$)"
          while IFS= read -r d_line || [ -n "$d_line" ]; do
            if [[ "$d_line" =~ $re_dec ]]; then
              printf "%s\n" "$d_line"
              break
            fi
          done < "$ARTIFACTS_DIR/decisions.md"
        done <<< "$unique_decs"
      fi
    fi
    ;;

  verify-links)
    errors=0

    declare -A defined_decs
    if [ -f "$ARTIFACTS_DIR/decisions.md" ]; then
      re_dec_def="^[[:space:]]*-[[:space:]]*\[[xX[:space:]]\][[:space:]]+(DEC-[0-9A-Za-z_-]+)"
      while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" =~ $re_dec_def ]]; then
          defined_decs["${BASH_REMATCH[1]}"]=1
        fi
      done < "$ARTIFACTS_DIR/decisions.md"
    fi

    if [ -f "$ARTIFACTS_DIR/specs.md" ]; then
      ref_decs=$(awk '{
        while (match($0, /\[[^]]*\]/)) {
          bracket = substr($0, RSTART, RLENGTH)
          $0 = substr($0, RSTART + RLENGTH)
          while (match(bracket, /DEC-[0-9A-Za-z_-]+/)) {
            print substr(bracket, RSTART, RLENGTH)
            bracket = substr(bracket, RSTART + RLENGTH)
          }
        }
      }' "$ARTIFACTS_DIR/specs.md" | sort -u)

      if [ -n "$ref_decs" ]; then
        while IFS= read -r id; do
          [ -z "$id" ] && continue
          if [ -z "${defined_decs["$id"]:-}" ]; then
            echo "Missing DEC ID: $id (referenced in specs.md)" >&2
            errors=1
          fi
        done <<< "$ref_decs"
      fi
    fi

    declare -A defined_specs
    if [ -f "$ARTIFACTS_DIR/specs.md" ]; then
      re_spec_def="^[[:space:]]*-[[:space:]]*\[[xX[:space:]]\][[:space:]]+(SPEC-[0-9A-Za-z_-]+)"
      while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" =~ $re_spec_def ]]; then
          defined_specs["${BASH_REMATCH[1]}"]=1
        fi
      done < "$ARTIFACTS_DIR/specs.md"
    fi

    if [ -f "$ARTIFACTS_DIR/plan.md" ]; then
      ref_specs=$(awk '{
        while (match($0, /\[[^]]*\]/)) {
          bracket = substr($0, RSTART, RLENGTH)
          $0 = substr($0, RSTART + RLENGTH)
          while (match(bracket, /SPEC-[0-9A-Za-z_-]+/)) {
            print substr(bracket, RSTART, RLENGTH)
            bracket = substr(bracket, RSTART + RLENGTH)
          }
        }
      }' "$ARTIFACTS_DIR/plan.md" | sort -u)

      if [ -n "$ref_specs" ]; then
        while IFS= read -r id; do
          [ -z "$id" ] && continue
          if [ -z "${defined_specs["$id"]:-}" ]; then
            echo "Missing SPEC ID: $id (referenced in plan.md)" >&2
            errors=1
          fi
        done <<< "$ref_specs"
      fi

      ref_decs_plan=$(awk '{
        while (match($0, /\[[^]]*\]/)) {
          bracket = substr($0, RSTART, RLENGTH)
          $0 = substr($0, RSTART + RLENGTH)
          while (match(bracket, /DEC-[0-9A-Za-z_-]+/)) {
            print substr(bracket, RSTART, RLENGTH)
            bracket = substr(bracket, RSTART + RLENGTH)
          }
        }
      }' "$ARTIFACTS_DIR/plan.md" | sort -u)

      if [ -n "$ref_decs_plan" ]; then
        while IFS= read -r id; do
          [ -z "$id" ] && continue
          if [ -z "${defined_decs["$id"]:-}" ]; then
            echo "Missing DEC ID: $id (referenced in plan.md)" >&2
            errors=1
          fi
        done <<< "$ref_decs_plan"
      fi
    fi

    if [ "$errors" -ne 0 ]; then
      exit 1
    fi

    echo "OK"
    exit 0
    ;;

  *)
    echo "Unknown subcommand: $cmd" >&2
    echo "Usage: artifacts.sh <status|unconverted-decs|unconverted-specs|next-tasks|context <TASK-id>|verify-links>" >&2
    exit 2
    ;;
esac
