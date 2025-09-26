//
//  DownloadRequest.swift
//
//  Created by Darktt on 2025/8/12.
//  Copyright © 2025 Darktt. All rights reserved.
//

import Foundation

#if canImport(SwiftExtensions)

import SwiftExtensions

#endif

#if canImport(SwiftPlayground)

import SwiftPlayground

#endif

public
enum DownloadEvent: Sendable
{
    case progress(Double)
    
    case success(URL)
}

@MainActor
public
protocol DownloadRequest
{
    var apiName: APIName { get }
    
    var parameters: Dictionary<AnyHashable, Any>? { get }
    
    var headers: Array<HTTPHeader>? { get }
}

extension DownloadRequest
{
    var urlRequest: URLRequest {
        
        var url: URL = self.apiName.url
        
        if let parameters = self.parameters.and({ !$0.isEmpty }) {
            
            url._append(queryItems: parameters.queryItems())
        }
        
        let headers: Dictionary<String, String>? = self.headers?.dictionary()
        
        var request = URLRequest(url: url)
        request.method = .get
        request.allHTTPHeaderFields = headers
        
        return request
    }
}

// MARK: - Private Extensions -

fileprivate
extension URL
{
    mutating
    func _append(queryItems: Array<URLQueryItem>)
    {
        if #available(iOS 16.0, *) {
            
            self.append(queryItems: queryItems)
            return
        }
        
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        self = urlComponents?.url ?? self
    }
}

fileprivate
extension Dictionary<AnyHashable, Any>
{
    func queryItems() -> Array<URLQueryItem>
    {
        self.compactMap {
            
            (key, value) in
            
            guard let keyString = key as? String else {
                
                return nil
            }
            
            let valueString = "\(value)"
            let item = URLQueryItem(name: keyString, value: valueString)
            
            return item
        }
    }
}
