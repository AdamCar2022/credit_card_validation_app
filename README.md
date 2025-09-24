**Credit Card Validator 
**

Prerequisites
---------------------------------------------------------------------------------------------------------

- This app requires Java 17 to run, if you dont have this please download the appropriate Java JDK version and apply it as "JAVA_HOME" in system variables, otherwise ignore this
- Flutter SDK installed
- Android Studio (for Android emulator) or Xcode (for iOS simulator on macOS)
- VS Code with Flutter and Dart extensions installed (or with preferred IDE)
---------------------------------------------------------------------------------------------------------

Running the App on Emulators via VS Code

Android Emulator
- Open Android Studio → AVD Manager, and start an emulator.
- In VS Code, open the Command Palette (Ctrl+Shift+P / Cmd+Shift+P) → search Flutter: Launch Emulator → select your emulator.
- Press F5 or click Run → Start Debugging. Your app will launch on the Android emulator.

iOS Simulator (macOS only)
- Open Xcode → Simulator → select a device and start it.
- In VS Code, the running simulator should appear in the device selector at the bottom-right.
- Press F5 or click Run → Start Debugging. Your app will launch on the iOS simulator.

Check connected devices with the command in the terminal:
flutter devices


Switch target device using the device selector in the bottom-right of VS Code.
Make sure emulators/simulators are started before running the app.

To Run the App:
flutter run

---------------------------------------------------------------------------------------------------------

CARD VALIDATOR APP

[Watch Demo Video](https://youtu.be/AD7BxVPNv3o)


Home Screen:
The landing page where the user can navigate from here to the cards screen 

Add Cards Screen: 
Here the user can view their cards, add a new card, view their banned countries and navigate back home 

Banned Countries Screen: 
The user can view all their pre populated banned countries and then add a new country if they please

---------------------------------------------------------------------------------------------------------

PLEASE NOTE!!:

The app only navigates correctly on the first time launching the emulator after pressing the "Get Started" button on the Home Screen, if you try do it again it will not work on the second run. You'd have to close and reopen the emulator, this also happens when you click the home button in the drop down of the My Cards screen (this was an Android issue and has not been tested for iOS as I was unable to use an iOS emulator as I dont have a Mac) 

---------------------------------------------------------------------------------------------------------
