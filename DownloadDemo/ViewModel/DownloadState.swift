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
    var isDownloading: Bool = false
    
    public
    var downloadProgress: Double = 0.0
    
    public
    var downloadedFileURL: URL?
    
    public
    var downloadStatus: String {
        
        switch (self.isDownloading, self.downloadProgress, self.downloadedFileURL) {
            
            case (false, 0.0, nil):
                return "Pending Download..."
                
            case (true, 0.0, nil):
                return "Downloading..."
                
            case (true, let progress, nil) where progress > 0.0 && progress < 1.0:
                return (progress * 100.0).format("Downloading... %.2f%%")
                
            case (false, let progress, let url) where progress >= 1.0 && url != nil:
                return "Download Complete"
                
            default:
                return "Download Failed"
        }
    }
    
    public
    var error: DownloadError?
}
