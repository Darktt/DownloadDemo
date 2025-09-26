//
//  DownloadFileRequest.swift
//  DowloadDemo
//
//  Created by Eden on 2025/9/26.
//

import Foundation
import SwiftExtensions

public
struct DownloadFileRequest
{
    
}

public
extension DownloadFileRequest
{
    struct _100MB: DownloadRequest
    {
        public
        var apiName: APIName = .download100MB
        
        public
        var parameters: Dictionary<AnyHashable, Any>? = nil
        
        public
        var headers: Array<HTTPHeader>? = nil
    }
    
    struct _1GB: DownloadRequest
    {
        public
        var apiName: APIName = .download1GB
        
        public
        var parameters: Dictionary<AnyHashable, Any>? = nil
        
        public
        var headers: Array<HTTPHeader>? = nil
    }
    
    struct _10GB: DownloadRequest
    {
        public
        var apiName: APIName = .download10GB
        
        public
        var parameters: Dictionary<AnyHashable, Any>? = nil
        
        public
        var headers: Array<HTTPHeader>? = nil
    }
}
