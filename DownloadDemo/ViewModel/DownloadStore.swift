//
//  DownloadStore.swift
//
//  Created by Eden on 2025/9/26.
//  
//

import UIKit

private
func kReducer(state: DownloadState, action: DownloadAction) -> DownloadState {
    
    var newState = state
    newState.error = nil
    
    if case .downloadStarted = action {
        
        newState.isDownloading = true
        newState.downloadProgress = 0.0
        newState.downloadedFileURL = nil
    }
    
    if case let .updateProgress(progress) = action {
        
        newState.downloadProgress = progress
        newState.downloadedFileURL = nil
    }
    
    if case let .downloadComplete(url) = action {
        
        newState.isDownloading = false
        newState.downloadedFileURL = url
    }
    
    if case let .downloadFailed(error) = action {
        
        newState.isDownloading = false
        newState.error = error
    }
    
    if case .downloadCanceled = action {
        
        newState.isDownloading = false
        newState.downloadProgress = 0.0
        newState.downloadedFileURL = nil
    }
    
    return newState
}

public
typealias DownloadStore = Store<DownloadState, DownloadAction>

@MainActor
let kDownloadStore = DownloadStore(initialState: DownloadState(),
                           reducer: kReducer,
                            middlewares: [
                                
                                DownloadMiddleware
                            ]
)
