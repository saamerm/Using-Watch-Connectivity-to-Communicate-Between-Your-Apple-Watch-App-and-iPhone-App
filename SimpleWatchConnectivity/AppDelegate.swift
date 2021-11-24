/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app delegate class of the iOS app.
*/

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var sessionDelegater: SessionDelegater = {
        return SessionDelegater()
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Trigger WCSession activation at the early phase of app launching.
        //
        assert(WCSession.isSupported(), "This sample requires Watch Connectivity support!")
        WCSession.default.delegate = sessionDelegater
        WCSession.default.activate()
        
        // Remind the setup of WatchSettings.sharedContainerID.
        //
        if WatchSettings.sharedContainerID.isEmpty {
            print("Specify a shared container ID for WatchSettings.sharedContainerID to use watch settings!")
        }

        return true
    }
}
