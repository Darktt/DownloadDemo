//
//  DownloadDemoApp.swift
//  DownloadDemo
//
//  Created by Eden on 2025/9/26.
//

import SwiftUI

@main
struct DownloadDemoApp: App
{
    var body: some Scene {
        
        WindowGroup {
            
            MainView()
                .environmentObject(kDownloadStore)
        }
    }
}
