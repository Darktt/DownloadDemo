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
                    
                    await download(with: request, next: next)
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
func download(with request: any DownloadRequest, next: @escaping (DownloadAction) -> Void) async
{
    // Implement the logic for the action here
    
    do {
        
        for try await event in DownloadHandler.shared.downloadRequestStream(request) {
            
            let action: DownloadAction
            
            switch event {
                case let .progress(progress):
                    action = .downloadProgress(progress)
                    next(action)
                    
                case let .success(fileURL):
                    action = .downloadComplete(fileURL)
                    next(action)
            }
        }
        
    } catch {
        
        let error = error as NSError
        let downloadError: DownloadError = (error.code, error.localizedDescription)
        
        next(.downloadFailed(downloadError))
    }
}
