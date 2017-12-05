# Armada-iOS
To gain editing access to this project, you need to be added to the organisation https://github.com/armada-ths from your head of IT. 

## Xcode and Swift
Download the latest Xcode-version (not the Beta version). Either from App-store or via https://developer.apple.com/xcode/. At the moment the project is guaranteed to work for Xcode 9.0 and 9.1. The projects is implemented in Swift 3.  

There are two project files Armada.xcodeproj and Armada.xcworkspace. To be able to build the third-party “Pod” libraries you have to open the Armada.xcworkspace file. 

## Pods
Install the Pod terminal-application at https://cocoapods.org
Pods are used to add external libraries. Pod is a application run in terminal with the command “pod”. “pod install” runs the “Podfile” in the current directory. This file installs the listed external libraries and uninstalls all external libraries that are installed but not listed in the “Podfile”  

### SwiftRangeSlider pod
This pod holds the code for the slider-functionality in Matching. It was forked from BrianCorbin/SwiftRangeSlider and lies within the THS Armada github repository. It was forked and changed because the original slider could not be implemented as a vertical slider. Changes to the slider should be saved in the repository https://github.com/armada-ths/SwiftRangeSlider, the latest commit-sha can then be added to the "Podfile" for the Armada-iOS project and installed with pod install. 

## Using Xcode 
Clone the github repository to your hard-drive: https://github.com/armada-ths/Armada-iOS 
To build the project in choose a iphone-version to simulate by changing the “Generic iOS Device” (top left corner) to any device you want to simulate.. Then CMD + R or push the “play” icon (top left corner), if anything fails to build, make sure everything is up-to-date in your projects "Build Phases".

## Pushing to Test-flight and App-Store
In Xcode -> “Preferences..” 
Accounts
Add the Apple ID of your developer account.


## Project Structure
### Core data:
The database, of exhibitors, is kept up to date with backend with the help of the classes in the data/api directory. This means that the exhibitor list completely decoupled from the network and that it can be used offline (as long as the data has been fetched once). Currently ETags are used when querying the backend so that old data isn't fetched unnecessarily.
### Matching:
Swiping between pages in the matchmaking view is made possible with the matchDataClass. This class holds the information of which view the user is currently interacting with and the selections made in each of the match-making views. When swiping left a new view is put on the view-stack and when swiping right the current view is removed from the view-stack. Changing the order or adding/removing a view in the Matching section requires hardcoding those views classes. 


### Events: 
The events are made by a GET request to the AIS. An issue which should be changed is that event don’t get labeled as “PAST” until the day has passed (e.g an event which ended 02.00 on the 23 november, will be set as “TODAY” until midnight, this should be changed)
### News: 
Getting news is made by a GET request to armada.nu (and not AIS, this is a big difference from the rest of the project!). The articles are then formatted with the html from the webpage. At the moment the images in the article are retrieved every time you open the article, this is due to the fact that we are using attributedHTMLStrings (this should be changed)
### Catalogue: 
The data is from the database (core data) in the device.
### About

# Licence Information 
Please check out [LICENSE](LICENSE) for information. for information.
