#!/bin/zsh

# Load token from .env without shell expansion
ENV_FILE="$(dirname "$0")/../.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: .env file not found."
  exit 1
fi

VERCEL_ADMIN_TOKEN=$(grep '^VERCEL_ADMIN_TOKEN=' "$ENV_FILE" | cut -d'=' -f2-)

if [ -z "$VERCEL_ADMIN_TOKEN" ]; then
  echo "Error: VERCEL_ADMIN_TOKEN not set in .env"
  exit 1
fi

RESPONSE=$(curl -s -H "x-admin-token: ${VERCEL_ADMIN_TOKEN}" \
  https://www.grumpybids.com/api/waitlist-admin)

COUNT=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['count'])")

echo ""
echo "  Waitlist Signups ($COUNT total)"
echo "  ─────────────────────────────────────────────────────────"
printf "  %-35s %s\n" "EMAIL" "SIGNED UP"
echo "  ─────────────────────────────────────────────────────────"

echo "$RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for s in data['signups']:
    date = s['timestamp'][:10]
    time = s['timestamp'][11:16]
    print(f\"  {s['email']:<35} {date} {time} UTC\")
"

echo "  ─────────────────────────────────────────────────────────"
echo ""
