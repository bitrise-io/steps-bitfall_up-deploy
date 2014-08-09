#!/bin/bash

formatted_output_file_path="$BITRISE_STEP_FORMATTED_OUTPUT_FILE_PATH"

# Functions

function echo_string_to_formatted_output {
  echo "$1" >> $formatted_output_file_path
}

function write_section_to_formatted_output {
  echo '' >> $formatted_output_file_path
  echo "$1" >> $formatted_output_file_path
  echo '' >> $formatted_output_file_path
}

function echoStatusFailed {
  echo "export BITRISE_DEPLOY_STATUS=\"failed\"" >> ~/.bash_profile
  echo
  echo "BITRISE_DEPLOY_STATUS: \"failed\""
  echo " --------------"

  write_section_to_formatted_output "## Failed"
  write_section_to_formatted_output "Check the Logs for details."
}

# Script

cd deps/steps-ipa-inspector
./step.sh
source ~/.bash_profile

# IPA
if [ "$IPA_INSPECTOR_STATUS" != "success" ]; then
  echo
  echo "Failed to get info from IPA. Terminating..."
  echo
  echoStatusFailed
  exit 1
fi

response=$(curl http://up.bitfallinc.com/api/upload \
  --silent \
  --write-out '\n%{http_code}\n' \
  -F "app_id=${BITRISE_DEPLOY_APP_ID}" \
  -F "path=${BITRISE_DEPLOY_PATH}" \
  -F "file=@${BITRISE_IPA_PATH}" \
  -F "thumbnail=@${IPA_ICON}" \
  -F "note=${BITRISE_DEPLOY_NOTE}" \
  -F "released=${IPA_CREATION_DATE}" \
  -F "expires_at=${IPA_EXPIRATION_DATE}")

status_code=$(echo "$response" | sed -n '$p')
json=$(echo "$response" | sed '$d')

if [ ! $status_code -eq 200 ]; then
  echo
  echo $(ruby -e "require 'json'; puts JSON.parse('${json}')['error']")
  echo
  echoStatusFailed
  exit 1
else
  install_url=$(ruby -e "require 'json'; puts JSON.parse('${json}')['install_url']")
  echo
  echo "Open in your browser to install the app"
  echo $install_url
  echo

  write_section_to_formatted_output "## Install URL"
  write_section_to_formatted_output $install_url
fi
