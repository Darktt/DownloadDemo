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
    
    if case let .downloadProgress(progress) = action {
        
        newState.downloadProgress = progress
        newState.downloadedFileURL = nil
    }
    
    if case let .downloadComplete(url) = action {
        
        newState.downloadedFileURL = url
    }
    
    if case let .downloadFailed(error) = action {
        
        newState.error = error
    }
    
    if case .downloadCanceled = action {
        
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
