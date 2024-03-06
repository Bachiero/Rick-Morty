//
//  CharactersListViewSpy.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 06.03.24.
//

import Foundation
@testable import Rick_and_Morty

class CharactersListViewSpy: CharactersListView {
    var reloadTableViewCalled = false
    func reloadTableView() {
        reloadTableViewCalled = true
    }
    
    var startLoaderCalled = false
    func startLoader() {
        startLoaderCalled = true
    }
    
    var stopLoaderCalled = false
    func stopLoader() {
        stopLoaderCalled = true
    }
    
    var showErrorMessageCalled = false
    var errorMessage: String?
    func showErrorMessage(_ text: String) {
        showErrorMessageCalled = true
        errorMessage = text
    }
}
