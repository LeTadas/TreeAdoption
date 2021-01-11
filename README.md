# TreeAdoption
TreeAdoption iOS application

## Getting Started

Make sure you have `xcodegen` installed.
- Install using [**homebrew**](https://brew.sh/): `brew install xcodegen`

Install other tools using [**bundler**](https://bundler.io/), this Ruby dependency manager is shipped with macOS by default.
- Run: `bundle install`

Prepare the project:
1. Close Xcode;
2. Run: `xcodegen generate` to generate `TreeAdoption.xcodeproj`;
3. Run: `bundle exec pod install` to install the Swift dependencies, and generate `TreeAdoption.xcworkspace`;
4. Now run: `open TreeAdoption.xcworkspace` and get started.

_**Please note** you need to rerun the project preparation steps when you switch branches._
