#!/bin/zsh

# Load environment variables
source "$(dirname "$0")/../.env"

if [ -z "$VERCEL_ADMIN_TOKEN" ]; then
  echo "Error: VERCEL_ADMIN_TOKEN not set. Check your .env file."
  exit 1
fi

curl -s -H "x-admin-token: $VERCEL_ADMIN_TOKEN" \
  https://grumpybids.com/api/waitlist-admin | python3 -m json.tool
