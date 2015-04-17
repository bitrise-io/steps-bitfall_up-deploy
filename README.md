# Steps Bitrise Deploy

*Work in progress!*

Deploys your IPA and DSym to Bitrise.

## Dependencies

This step uses the following steps
* [steps-ipa-inspector](https://github.com/bitrise-io/steps-ipa-inspector)

## Input Environment Variables

* BITRISE_IPA_PATH (passed automatically)
* BITRISE_DSYM_PATH (passed automatically)
* BITRISE_DEPLOY_APP_ID
* BITRISE_DEPLOY_PATH
* BITRISE_DEPLOY_NOTE

## Output Environment Variables

* BITRISE_DEPLOY_STATUS [success/failed]
