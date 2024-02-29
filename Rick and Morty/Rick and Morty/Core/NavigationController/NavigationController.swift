//
//  NavigationController.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 28.02.24.
//

import UIKit


///  Navigation controller as entry point to hold the stack of viewControllers. 
final class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = CharactersListConfigurator().configured()
        setViewControllers([vc], animated: true)
    }
}
