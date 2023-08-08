# SalesSparrow

This repository contains SalesSparrow, an SwiftUI iOS app.

### Prerequisites and System Requirements

Before using the "salessparrow" iOS app, make sure your development environment meets the following prerequisites and system requirements:

1. Xcode: The app requires Xcode version 14.3 or newer to build and run.

2. Minimum iOS Version: 16.0

3. Apple Developer Account: You need a valid Apple Developer account to run the app on a physical device or distribute it to the App Store.

## Getting Started

To clone the project and install dependencies, follow these steps:

### Clone the project

```
git clone git@github.com:TrueSparrowSystems/salessparrow.git
cd salessparrow
```

### Install the dependencies

```
pod install
```

##### Specific Requirements for Each Target:

- salessparrow: Requires a minimum iOS version of 16.0.

- salessparrowTests: Requires a minimum iOS version of 16.0.

- salessparrowUITests: Requires a minimum iOS version of 16.0.

Ensure that you have met these prerequisites and system requirements before working with the "salessparrow" iOS app.

### Build Commands

- To create an IPA file for different environments, follow these steps:

1. Open your Xcode project.

2. Select the target corresponding to the desired environment (dev, staging, or production).

3. In the Run tab, select the desired build configuration for the environment (e.g., dev, staging, or production).

4. Build the project using Product -> Archive Build or by pressing Cmd + B.

5. Once the build process is complete, the generated IPA file can be found in the project's build directory. By default, it is located in ~/Library/Developer/Xcode/DerivedData/<ProjectName>/Build/Products/<Configuration>-<Platform>/.

6. Rename the IPA file to indicate the environment it represents (e.g., salessparrow-staging.ipa)

### Testing and Quality Assurance

The app includes unit tests and UI tests to ensure the functionality is working as expected. To run the tests, use the following commands:

```
// Run all test
xcodebuild -scheme salessparrow -workspace salessparrow.xcworkspace -destination 'platform=iOS Simulator,name=iPhone 14 Pro' test

// Run unit tests
xcodebuild -scheme salessparrow -workspace salessparrow.xcworkspace -destination 'platform=iOS Simulator,name=iPhone 14 Pro' test -only-testing:salessparrowTests

// Run UI tests
xcodebuild -scheme salessparrow -workspace salessparrow.xcworkspace -destination 'platform=iOS Simulator,name=iPhone 14 Pro' test -only-testing:salessparrowUITests

```

### Firebase App Distribution

During the QA and testing phase, we use Firebase App Distribution to upload and distribute builds to testers. We have different projects in Firebase for dev, staging, and production. To upload the IPA file, follow these steps:

1. Open the Firebase console on the web.

2. Navigate to App Distribution for the desired project.

3. Follow the instructions to upload and distribute the IPA file.

4. Once the build is uploaded, testers will be able to download and install the build on their devices through the email invitation.

<u>Note for distributor</u>: Before distributing the app, please make sure that all the devices being invited have their UDIDs listed under ["Devices"] (https://developer.apple.com/account/resources/devices/list) in the Apple Developer account. Failing to do so will prevent the build from installing on the device.

### To add Crashlytics for Firebase:

<b>- Ensure Firebase Setup:</b> Make sure you have added the GoogleService-Info.plist file to your target folder. Verify if the bundle identifier in the plist file and target are same.

<b> - Uncomment the code in appdelegate.swift file:</b> Uncomment the imports for FirebaseCore and FirebaseCrashlytics. Uncomment the code in didFinishLaunchingWithOptions method and you're all set.

### Project Structure

The project is organized into the following directories:

<b><u>salessparrow:</u></b> This is the main folder that contains the source code and resources for the iOS app. It includes the SwiftUI views, view models, model files, and other necessary components for the app.

- Components: Contains the custom components used throughout the app.
- ViewModel: Contains the view models used for data binding and handling business logic.
- Utils: Contains utility classes and helper functions.
- Persistence.swift: Manages the Core Data persistence for the app.
- Model: Contains the data models used throughout the app.
- swiftui_boilerplateApp.swift: The entry point of the app.
- ContentView.swift: The root view of the app.

<b><u>salessparrowTests:</u></b> This folder contains the test cases for the app. It includes unit tests to ensure the app's functionality and performance.

<b><u>salessparrowUITests:</u></b> This folder contains the UI test cases for the app. These tests are focused on testing the user interface and interaction of the app.

### License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/TrueSparrowSystems/salessparrow/blob/master/LICENSE) file for details.

### Contributing

Contributions to the project are welcome! If you would like to contribute, please follow the guidelines in the [CONTRIBUTING](https://github.com/TrueSparrowSystems/salessparrow/blob/master/CONTRIBUTING.md) file.

### Code of Conduct

This project has a code of conduct that outlines expected behavior for contributors and users. Please read the [CODE_OF_CONDUCT](https://github.com/TrueSparrowSystems/salessparrow/blob/master/CODE_OF_CONDUCT.md) file before getting involved.
