//
//  DownloadState.swift
//
//  Created by Eden on 2025/9/26.
//
//

import Foundation
import SwiftExtensions

public
struct DownloadState
{
    public
    var status: Status = .pending
    
    public
    var isDownloading: Bool {
        
        guard case .downloading(_) = self.status else {
            
            return false
        }
        
        return true
    }
}

extension DownloadState
{
    public
    enum Status
    {
        case pending
        
        case starting
        
        case downloading(progress: Double)
        
        case complete(path: URL)
        
        case failed(error: DownloadError)
        
        case canceled
    }
}

extension DownloadState.Status: CustomStringConvertible
{
    public
    var description: String {
        
        switch self {
            
            case .pending:
                "Pending Download..."
            
            case .starting:
                "Download Staring..."
            
            case .downloading(progress: let progress):
                (progress * 100.0).format("Downloading... %.2f%%")
            
            case .complete(path: _):
                "Download Complete"
            
            case .failed(error: let error):
                "Download Failed, error: \(error.message)"
            
            case .canceled:
                "Download Canceled"
        }
    }
}
