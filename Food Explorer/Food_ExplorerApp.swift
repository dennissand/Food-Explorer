//
//  Food_ExplorerApp.swift
//  Food Explorer
//
//  Created by Dennis Sand on 10.11.22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct Food_ExplorerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var spotVM = SpotViewModel()
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(spotVM)
                .environmentObject(locationManager)
        }
    }
}
