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
        
        if self.downloadProgress == 0.0, self.downloadedFileURL == nil {
            
            return "Pending Download..."
        }
        
        if self.isDownloading, self.downloadProgress == 0.0, self.downloadedFileURL == nil {
            
            return "Downloading..."
        }
        
        if self.downloadProgress > 0.0, self.downloadProgress < 1.0 {
            
            return (self.downloadProgress * 100.0).format("Downloading... %.2f%%")
        }
        
        if self.downloadedFileURL != nil, self.downloadProgress >= 1.0 {
            
            return "Download Complete"
        }
        
        return "Download Failed"
    }
    
    public
    var error: DownloadError?
}
