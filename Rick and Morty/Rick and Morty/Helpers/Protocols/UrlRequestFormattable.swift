//
//  UrlRequestFormattable.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import Foundation

protocol UrlRequestFormattable {
    func getUrlRequest(from request: Request) -> URLRequest?
}

extension UrlRequestFormattable {
    func getUrlRequest(from request: Request) -> URLRequest? {
        guard let url = request.getUrl() else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        return urlRequest
    }
}
