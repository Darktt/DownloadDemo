//
//  DownloadMiddleware.swift
//
//  Created by Eden on 2025/9/26.
//  
//

import UIKit

@MainActor
public
let DownloadMiddleware: Middleware<DownloadState, DownloadAction> = {
    
    store in
    
    {
        next in
        
        {
            action in
            
            if case let .downloadAction(request) = action {
                
                Task {
                    
                    let action = DownloadAction.downloadStarted
                    
                    next(action)
                    await download(with: request)
                }
                return
            }
            
            if case .cancelDownload = action {
                
                DownloadHandler.shared.cancelDownload()
                
                let action = DownloadAction.downloadCanceled
                
                next(action)
                return
            }
            
            next(action)
        }
    }
}

private
func download(with request: any DownloadRequest) async
{
    // Implement the logic for the action here
    
    do {
        
        for try await event in DownloadHandler.shared.downloadRequestStream(request) {
            
            let action: DownloadAction = switch event {
                    
                case let .progress(progress):
                        .updateProgress(progress)
                    
                case let .success(fileURL):
                        .downloadComplete(fileURL)
            }
            
            kDownloadStore.dispatch(action)
        }
        
    } catch {
        
        let error = error as NSError
        let downloadError: DownloadError = (error.code, error.localizedDescription)
        let action = DownloadAction.downloadFailed(downloadError)
        
        kDownloadStore.dispatch(action)
    }
}
