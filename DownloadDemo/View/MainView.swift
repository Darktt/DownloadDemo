//
//  MainView.swift
//  DownloadDemo
//
//  Created by Eden on 2025/9/26.
//

import SwiftUI

private
enum DownloadSize
{
    case size100MB
    
    case size1GB
    
    case size10GB
}

public
struct MainView: View
{
    @EnvironmentObject
    private
    var store: DownloadStore
    
    private
    var state: DownloadState {
        
        self.store.state
    }
    
    private
    var isDownloading: Bool {
        
        self.state.isDownloading
    }
    
    @State
    private
    var selectedSize: DownloadSize = .size100MB
    
    @State
    private
    var isShowingErrorAlert: Bool = false
    
    public
    var body: some View {
        
        ZStack {
            
            GeometryReader {
                
                _ in
                
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 20.0) {
                
                HStack(spacing: 10.0) {
                    
                    Image(systemName: "arrow.down.circle")
                    
                    Text(self.state.downloadStatus)
                        .font(.subheadline)
                }
                .frame(minWidth: 200.0, minHeight: 40.0)
                .glassEffect()
                
                if self.isDownloading {
                    
                    ProgressView(value: self.state.downloadProgress)
                        .tint(Color.orange)
                        .glassEffect()
                }
                
                Picker("Select download size:", selection: self.$selectedSize) {
                    
                    Text("100MB").tag(DownloadSize.size100MB)
                    Text("1GB").tag(DownloadSize.size1GB)
                    Text("10GB").tag(DownloadSize.size10GB)
                }
                .disabled(self.isDownloading)
                .pickerStyle(.segmented)
                .glassEffect(.clear)
                
                if self.isDownloading {
                    
                    Button("Cancel") {
                        
                        self.cancelDownload()
                    }
                    .bold()
                    .font(.default)
                    .buttonStyle(.glass)
                } else {
                    Button("Start Download") {
                        
                        self.startDownload()
                    }
                    .bold()
                    .font(.default)
                    .buttonStyle(.glass)
                }
            }
            .padding([.leading, .trailing], 20.0)
        }
        .alert("Error", isPresented: self.$isShowingErrorAlert) {
            
            Button("OK", role: .cancel) {
                
                self.isShowingErrorAlert = false
            }
        } message: {
            
            Text(self.state.error?.message ?? "Unknown Error")
        }
        .onChange(of: self.state.error != nil) {
            
            _, newValue in
            
            self.isShowingErrorAlert = newValue
        }
    }
}

private
extension MainView
{
    func startDownload() {
        
        let action: DownloadAction = switch self.selectedSize {
                
            case .size100MB:
                .downloadAction(DownloadFileRequest._100MB())
                
            case .size1GB:
                .downloadAction(DownloadFileRequest._1GB())
                
            case .size10GB:
                .downloadAction(DownloadFileRequest._10GB())
        }
        
        self.store.dispatch(action)
    }
    
    func cancelDownload() {
        
        let action = DownloadAction.cancelDownload
        
        self.store.dispatch(action)
    }
}

#Preview {
    
    MainView()
        .environmentObject(kDownloadStore)
}
