# Using Watch Connectivity to Communicate Between Your Apple Watch App and iPhone App
Implement two-way communication between your Apple Watch app and the paired iPhone app with the Watch Connectivity framework.

## Overview
Most Apple Watch apps require an exchange of data with a paired iPhone app. This sample demonstrates how to use the Watch Connectivity APIs to:

- Update application contexts
- Send messages
- Transfer user info and manage the outstanding transfers
- Transfer files, view transfer progress, and manage the outstanding transfers
- Update current complications from iOS apps
- Handle Watch Connectivity background tasks  

Watch Connectivity background tasks are handled in the [`ExtensionDelegate`](SimpleWatchConnectivity%20WatchKit%20Extension/ExtensionDelegate.swift) class; all other WatchConnectivity code is implemented in the Swift files in the [`Shared`](Shared/) folder for both the iPhone app and the WatchKit extension. The payload transferred across the devices in this sample is a dictionary containing a timestamp and a random color, which are displayed on the UI of both sender and receiver.

When building your own apps, carefully choose an API based on how your data should be delivered. For example, a message delivers immediately if the peer is [`reachable`](https://developer.apple.com/documentation/watchconnectivity/wcsession/1615683-isreachable); otherwise, an error is returned via the error handler. User info transfer behaves differently: the data is queued to be delivered in the order sent, and transfers can be monitored or canceled using [`WCSessionUserInfoTransfer`](https://developer.apple.com/documentation/watchconnectivity/wcsessionuserinfotransfer). An application context is stateless, so setting a new context overwrites the previous one. 

## Get Started
To run this sample on your devices, change the bundle IDs so the apps can be provisioned correctly in your environment:

1. Open this sample with the latest version of Xcode, select the “SimpleWatchConnectivity” target, change the bundle ID to `<Your iOS app bundle ID>`, and select the right team to let Xcode automatically manage your provisioning profile. See [`QA1814`](https://developer.apple.com/library/content/qa/qa1814/_index.html#//apple_ref/doc/uid/DTS40014030) for details.
2. Do the same thing for the WatchKit app and WatchKit Extension target. The bundle IDs should be `<Your iOS app bundle ID>.watchkitapp` and `<Your iOS app bundle ID>.watchkitapp.watchkitextension`, respectively.
3. Next, open the `Info.plist` file of the WatchKit app target, and change the value of `WKCompanionAppBundleIdentifier` key to `<Your iOS app bundle ID>`.
4. Open the `Info.plist` file of the WatchKit Extension target, change the value of the `NSExtension > NSExtensionAttributes > WKAppBundleIdentifier` key to `<Your iOS app bundle ID>.watchkitapp`.
5. Open the `Root.plist` file of `Settings-Watch.bundle` and set the value of `ApplicationGroupContainerIdentifier` key to that of your group container. Follow the steps described in the [`Settings`](https://developer.apple.com/library/content/documentation/General/Conceptual/WatchKitProgrammingGuide/Settings.html#//apple_ref/doc/uid/TP40014969-CH22-SW1) section to set up the group container.
6. Finally, open [`TestDataProvider`](Shared/TestDataProvider.swift) class and change the value of `WatchSettings.sharedContainerID` to your group container ID.

Now you should be able to make a clean build and run the apps on your devices. Restart the devices to make sure everything is clean if you see anything unexpected.

## Update Current Complications from iOS apps
The complication implemented in this sample only supports the Modular Large (tall body) family and shows a random number for the current timeline entry. Use these steps to make the complication current:
1. Choose a Modular watch face on your watch.
2. Deep press to get to the customization screen, tap the Customize button, then swipe right to get to the complications configuration screen and tap the tall body area.
3. Rotate the digital crown to choose the SimpleWatchConnectivity complication.
4. Press the digital crown and tap the screen to go back to the watch face.

Once the complication is current, you can tap the transferCurrentComplicationUserInfo button on the iOS app and see the update on the watch face if the execution time is still under budget.

To update current complications, this sample uses WCSession's
[`transferCurrentComplicationUserInfo`](https://developer.apple.com/documentation/watchconnectivity/wcsession/1615639-transfercurrentcomplicationuseri) method on the iOS side to transfer data to the watch, then call CLKComplicationServer's [`reloadTimeline`](https://developer.apple.com/documentation/clockkit/clkcomplicationserver/1627891-reloadtimeline) method on the watchOS side to trigger the update. If the complication is current and still has execution time, it will show a new random number.

## Handle Watch Connectivity Background Tasks
Watch Connectivity background tasks have to be completed after the data is received, as described in [`WKWatchConnectivityRefreshBackgroundTask`](https://developer.apple.com/documentation/watchkit/wkwatchconnectivityrefreshbackgroundtask). In order to make sure the background tasks have completed, this sample retains the tasks in an array and completing them when the session is activated and the [`hasContentPending`](https://developer.apple.com/documentation/watchconnectivity/wcsession/1648961-hascontentpending) property is false.

Debugging background tasks can be tricky because they often trigger when the watch app is suspended, which will not be the case if the Xcode debugger launches the watch app. For debugging purposees, this sample uses the [`Logger`](Shared/Logger.swift) class to write debug information into a log file, which can be transferred to the iOS app by tapping the transferFile button on the watch app. To enable the log transfer and clearance, this sample provides a watch setting bundle, which can be seen on the SimpleWatchConnectivity setting page in the iOS watch app.
