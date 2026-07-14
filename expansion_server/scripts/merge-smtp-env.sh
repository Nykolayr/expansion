#!/bin/bash
ENV=/opt/expansion-api/.env
FRAG=/tmp/smtp.env
while IFS= read -r line || [ -n "$line" ]; do
  key="${line%%=*}"
  [ -z "$key" ] && continue
  if grep -q "^${key}=" "$ENV"; then
    sed -i "s|^${key}=.*|${line}|" "$ENV"
  else
    echo "$line" >> "$ENV"
  fi
done < "$FRAG"
