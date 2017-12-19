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

To push an  app to App Store you need to have the role of app manager (not just developer)



## Project Structure
### Core data:
The database, of exhibitors, is kept up to date with backend with the help of the classes in the data/api directory. This means that the exhibitor list completely decoupled from the network and that it can be used offline (as long as the data has been fetched once). Currently ETags are used when querying the backend so that old data isn't fetched unnecessarily.
### Matching:
Swiping between pages in the matchmaking view is made possible with the matchDataClass. This class holds the information of which view the user is currently interacting with and the selections made in each of the match-making views. When swiping left a new view is put on the view-stack and when swiping right the current view is removed from the view-stack. Changing the order or adding/removing a view in the Matching section requires hardcoding those views classes. On matching interest it's not clear that the view is scrollable (this is an UX issue, but worth righting here). The second page ("What are you looking for") is not iPhone X compatible at the moment. Page 6 ("How big is your future employer") is on the verge of not being iPhone X compatible.


### Events: 
The events are made by a GET request to the AIS. An issue which should be changed is that event don’t get labeled as “PAST” until the day has passed (e.g an event which ended 02.00 on the 23 november, will be set as “TODAY” until midnight, this should be changed)
### News: 
Getting news is made by a GET request to armada.nu (and not AIS, this is a big difference from the rest of the project!). The articles are then formatted with the html from the webpage. At the moment the images in the article are retrieved every time you open the article, this is due to the fact that we are using attributedHTMLStrings (this should be changed)
### Catalogue: 
The data is from the database (core data) in the device. Company objects saved to the sql database has several attributes which aren’t used this year, you might want to remove them or use them as inspiration in knowing what to ask from the ais team. The rendering of the background image in Company should be redone, since the size of the image depends on the content size of the company attributes.
### About
The about page loads the partners, but doesn’t take the ”main partner” attribute into account, this might need to change. The images aren’t clickable.

### General
All the details view (news, event, company) are based on the same scrollview which alters in the width of the inner white area. (try to run the code on an iPhone 7 plus and an iPhone SE) and compare.

The code has FilterCode (file: CompanyFilterTableViewController.swift) (which can work with a view to filter companies on certain criteria) however no View for this is implemented in the latest release version.

All the details view (news, event, company) are based on the same scrollview which alters in the width of the inner white area. (try to run the code on an iPhone 7 plus and an iPhone SE) and compare.

Get a beta test group NOW! and get them to try the existing version
Understand the errors from airbrake

## Practical links
Multiple good swift topics  
http://roadfiresoftware.com/blog/  
http://roadfiresoftware.com/2015/05/useful-xcode-keyboard-shortcuts-for-developers/  

Never tried to use this but seems interresting.  
https://packagecontrol.io/packages/Swift  

Iphone X compatability to be implemented 2018.  
https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions  

Saving stuff localy.  
https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults  
custom saving.  
https://www.hackingwithswift.com/read/12/3/fixing-project-10-nscoding  

Collection view tutorial  
http://www.brianjcoleman.com/tutorial-collection-view-using-swift  
https://www.raywenderlich.com/136161/uicollectionview-tutorial-reusable-views-selection-reordering  

http://fuckingswiftblocksyntax.com/  
http://goshdarnclosuresyntax.com/  

It's possible to use Objective-C code in your Swift project. This requires a "bridging header"  
https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html#//apple_ref/doc/uid/TP40014216-CH10-XID_80  
http://www.learnswiftonline.com/getting-started/adding-swift-bridging-header/  

http://www.electricpeelsoftware.com/2014/08/12/map-filter-reduce.html  
https://stackoverflow.com/questions/24110762/swift-determine-ios-screen-size  
https://stackoverflow.com/questions/25398753/swift-willset-didset-and-get-set-methods-in-a-property  
https://stackoverflow.com/questions/39676939/how-does-string-index-work-in-swift  

Problem building on real iphone after adding SDK  
https://stackoverflow.com/questions/37806538/code-signing-is-required-for-product-type-application-in-sdk-ios-10-0-stic

### Practical Tips 

# Setting up a ScrollView  
https://stackoverflow.com/questions/27326924/swift-uiscrollview-correct-implementation-for-only-vertical-scrolling  

1. Create your UIScrollView *scrollView.  

2. You want to create one UIView *contentView which you will put the rest of your view elements into.  
    [self.view addSubview:scrollView];  
    [scrollView addSubview:contentView];  
    [contentView addSubview:_label1];  
    [contentView addSubview:_label2];  
    [contentView addSubview:_label3];  
    [contentView addSubview:_label4];  
    [contentView addSubview:_label5];  
    [contentView addSubview:_label6];  

3. Pin the 4 edges of scrollView to the 4 edges of self.view  

4. Pin the top and bottom edges of contentView to the top and bottom of scrollView.  

5. This is the tricky part. To set the horizontal sizing, you want the leading (right) and trailing(left) edges of the contentView to be pinned to the leading and trailing edges self.view instead of scrollView. Even though contenView is a sub view of scrollView its horizontal constraints are going to reach outside of the scrollView and connect to self.view.  

6. Pin any other view elements to contentView as you normally would.  

(7.) If you want text view to push the parent views bounds you should deselect scrolling in Storyboard.  

# Using SwiftyJSON

let json = JSON(data: string.data(using: String.Encoding.utf8)!)  
print(json["key"])      --> value   

or  
 
let json = JSON.init(parseJSON: string)  

# Make cell-size follow content  

1. You need to set the StretchView margin constraints that is stretching the cell to be equal to the contentView of the cell.  
2. Add Stretch-View: Height- and Width-constraints  

3. Add Stretch-View: top-, leading- and bottom-margin constraints to 0  

4. Resize cell to match the stretchViews margins

## Licence Information 
Please check out [LICENSE](LICENSE) for information. 
