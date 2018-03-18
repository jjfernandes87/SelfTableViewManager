fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### change_version_number
```
fastlane change_version_number
```
Change version number with prompt
### patch
```
fastlane patch
```
Increment Patch version
### minor
```
fastlane minor
```
Increment minor version
### major
```
fastlane major
```
Increment major version
### bump
```
fastlane bump
```
bump build version and commit
### pr
```
fastlane pr
```
Create a pull request from the current branch
### tag_the_release
```
fastlane tag_the_release
```
Tag the current repo status for App Store Release
### install_private_repo
```
fastlane install_private_repo
```

### publish_pod
```
fastlane publish_pod
```

### lint_pod
```
fastlane lint_pod
```

### tag_and_pod
```
fastlane tag_and_pod
```
Create a new tag and publish the new pod you can pass : force

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
