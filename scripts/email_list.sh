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

curl -s -H "x-admin-token: ${VERCEL_ADMIN_TOKEN}" \
  https://www.grumpybids.com/api/waitlist-admin | python3 -m json.tool
