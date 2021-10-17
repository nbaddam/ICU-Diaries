# ICU-Diaries

## Instructions to run our project:

### In Terminal:
- If you do not yet have cocoapods installed on your machine, run the following command in you root directory:

        `sudo gem install cocoapods`

### In this GitHub Repository:
- Go to “Code”
- Select “Open with XCode”

### On XCode:
- Xcode will prompt you to choose a branch
- Select “main” and hit “clone”
- Choose a location to save it to and hit “clone”
- Wait for packages to load (this should take a minute or so)
- Ensure that the correct scheme and simulator are selected (see screenshot below)

![Instruction1](images/screenshot-1.png)

- If not, click on “ICU Diaries” within the red circle (this may not say ICU Diaries on your machine, but click it anyway) and select the correct scheme and simulator as shown in the next screenshot

![Instruction2](images/screenshot-2.png)

(Note: any simulator running iOS 14.5 or higher will work for this)
- Once the simulator is up and running, you should be able to sign-up and then log in to the application.

### Troubleshooting:
- If you get an error like “No such module ’Firebase Auth’”, close the project and open “ICU Diaries.xcworkspace” (not “ICU Diaries.xcodeproj”). Follow the steps again to build and select a simulator
