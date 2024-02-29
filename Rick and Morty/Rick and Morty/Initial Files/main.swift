//
//  main.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 28.02.24.
//

import UIKit

/// Here we check if project is compiled for tests so we can use mock app delegate instead of regular app delegate.

let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass = isRunningTests ? "MockAppDelegate" : NSStringFromClass(AppDelegate.self)

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    appDelegateClass
)
