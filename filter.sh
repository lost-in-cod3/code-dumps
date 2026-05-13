#!/bin/bash

INPUT_FILE="source.json"
FILTERED_FILE="source_filtered.json"
CSV_FILE="output.csv"

# Step 1: Filter records where businessArea starts with "CMT"
jq '
{
  problemstatements: [
    .problemstatements[]
    | select(.businessArea | startswith("CMT"))
  ],
  total_page
}
' "$INPUT_FILE" > "$FILTERED_FILE"

echo "Filtered JSON written to $FILTERED_FILE"

# Step 2: Convert filtered JSON to CSV
jq -r '
[
  "problemStatementId",
  "title",
  "businessArea",
  "description",
  "proposedSolution",
  "businessValue",
  "owner",
  "ownerMail"
],
(
  .problemstatements[]
  | [
      .problemStatementId,
      .title,
      .businessArea,
      .description,
      .proposedSolution,
      .businessValue,
      .owner,
      .ownerMail
    ]
)
| @csv
' "$FILTERED_FILE" > "$CSV_FILE"

echo "CSV written to $CSV_FILE"