//
//  NetworkError.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import Foundation

enum NetworkError: Error {
    case failedToCreateRequest
    case failedToGetData
}
