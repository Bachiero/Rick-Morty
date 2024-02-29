//
//  MockAppDelegate.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 28.02.24.
//

import Foundation
import UIKit


@objc(MockAppDelegate)
/// Mock app delegate for unit-testing.
/// When tests are executed, app doesn't need to load regular appDelegate with it's resources
class MockAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
 
}
