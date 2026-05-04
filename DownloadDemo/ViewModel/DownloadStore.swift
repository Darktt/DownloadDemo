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
    
    if case .downloadStarted = action {
        
        newState.status = .starting
    }
    
    if case let .updateProgress(progress) = action {
        
        newState.status = .downloading(progress: progress)
    }
    
    if case let .downloadComplete(url) = action {
        
        newState.status = .complete(path: url)
    }
    
    if case let .downloadFailed(error) = action {
        
        newState.status = .failed(error: error)
    }
    
    if case .downloadCanceled = action {
        
        newState.status = .canceled
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
