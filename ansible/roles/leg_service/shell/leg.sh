#!/bin/sh

# Cleanup temporarily files on every exit
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

json_file="$TMP_DIR/mettmenstetten.json"

# API URL
URL="http://localhost:8080/rest/items/LaMetric_Inverter"

# read JSON data
response=$(curl -s $URL)
state=$(echo $response | jq -r '.state')
echo "Power: $state"

# limiter
if [ "$state" -lt 0 ]; then
  state=0
elif [ "$state" -gt 20000 ]; then
  state=20000
fi

# calculate percentage value
percentage=$(awk "BEGIN {printf \"%d\", ($state / 20000) * 100}")
echo "State: $percentage%"

# generate json
json_content=$(jq -n --arg percentage "$percentage" '{solar_power_percentage: $percentage}')
echo "$json_content" > "$json_file"

# upload to aws
bucket="www.leg-mettmenstetten.ch"
folder="state"
aws s3 cp "$json_file" "s3://$bucket/$folder/"

echo "Script finished"
