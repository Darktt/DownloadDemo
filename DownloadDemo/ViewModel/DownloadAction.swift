//
//  DownloadAction.swift
//
//  Created by Eden on 2025/9/26.
//  
//

import Foundation

public
enum DownloadAction
{
    case downloadAction(any DownloadRequest)
    
    case cancelDownload
    
    case downloadProgress(Double)
    
    case downloadComplete(URL)
    
    case downloadFailed(DownloadError)
    
    case downloadCanceled
}
