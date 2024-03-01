//
//  Request.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import Foundation

/// This object should be used to create single request for API call
final class Request {
    private let endpoint: Endpoint
    private let pathComponents: Set<String>
    private let queryParameters: [URLQueryItem]
    
    
    /// Construct Request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Array of path components
    ///   - queryParameters: Array of query parameters
    init(
        endpoint: Endpoint,
        pathComponents: Set<String> = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    
    /// - Returns: Combined base url, path components and query parameters in URL  format for API call
    public func getUrl() -> URL? {
        let urlString = getCombinedStringUrl()
        return URL(string: urlString)
    }
}

//MARK: - UrlString combining
extension Request {
    
    /// Combines base url, path components and query parameters in String format
    /// - Returns: String for building the URL
    private func getCombinedStringUrl() -> String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if let pathComponentsUrlString = getStringUrlForPathComponents(pathComponents) {
            string += pathComponentsUrlString
        }
        if let queryParametersUrlString = getStringUrlForQueryParameters(queryParameters) {
            string += queryParametersUrlString
        }
        
        return string
    }
    
    private func getStringUrlForPathComponents(_ pathComponents: Set<String>) -> String? {
        guard !pathComponents.isEmpty else { return nil }
        var string = ""
        pathComponents.forEach { string += "/\($0)"}
        
        return string
    }
    
    private func getStringUrlForQueryParameters(_ parameters: [URLQueryItem]) -> String? {
        guard !parameters.isEmpty else { return nil }
        var string = "?"
        let args = parameters.compactMap {
            guard let value = $0.value else { return nil }
            return "\($0.name)=\(value)"
        }.joined(separator: "&")
        string += args
        
        return string
    }
}
