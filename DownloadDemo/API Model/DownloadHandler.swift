//
//  DownloadHandler.swift
//  DTTest
//
//  Created by Darktt on 2025/8/12.
//  Copyright © 2025 Darktt. All rights reserved.
//

import Foundation

#if canImport(SwiftExtensions)
    
import SwiftExtensions

#endif

#if canImport(SwiftPlayground)

import SwiftPlayground

#endif

@MainActor
public
class DownloadHandler
{
    // MARK: - Properties -
    
    public static
    let shared: DownloadHandler = DownloadHandler()
    
    private
    lazy var delegate: URLSessionDelegate = {
        
        URLSessionDelegate(parent: self)
    }()
    
    private
    lazy var urlSession: URLSession = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 300.0
        let urlSession = URLSession(configuration: configuration, delegate: self.delegate, delegateQueue: .main)
        
        return urlSession
    }()
    
    private
    var downloadTask: URLSessionDownloadTask?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    private
    init()
    {
        
    }
    
    deinit
    {
        
    }
    
    public
    func downloadRequest<Request>(_ request: Request) async throws -> URL where Request: DownloadRequest
    {
        let urlRequest = request.urlRequest
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let (url, response) = try await session.download(for: urlRequest)
        session.finishTasksAndInvalidate()
        
        if let response = response as? HTTPURLResponse,
           let statusCode = HTTPError.StatusCode(rawValue: response.statusCode) {
            
            let error = HTTPError(statusCode)
            
            throw error
        }
        
        let fileUrl: URL = try self.delegate.moveToCatch(url)
        
        return fileUrl
    }
    
    public
    func downloadRequestStream<Request>(_ request: Request) -> AsyncThrowingStream<DownloadEvent, Error> where Request: DownloadRequest
    {
        let stream = AsyncThrowingStream<DownloadEvent, Error> {
            
            continuation in
            
            let urlRequest = request.urlRequest
            
            let downloadTask: URLSessionDownloadTask = self.urlSession.downloadTask(with: urlRequest)
            downloadTask.resume()
            
            self.downloadTask = downloadTask
            
            let terminationHandler: @Sendable (AsyncThrowingStream<DownloadEvent, Error>.Continuation.Termination) -> Void = {
                
                _ in
                
                Task {
                    
                    @MainActor in
                    
                    self.downloadTask?.cancel()
                    self.downloadTask = nil
                    self.delegate.continuation = nil
                }
            }
            
            continuation.onTermination = terminationHandler
            self.delegate.continuation = continuation
        }
        
        return stream
    }
    
    public
    func cancelDownload()
    {
        guard let downloadTask = self.downloadTask else {
            
            return
        }
        
        downloadTask.cancel()
        self.downloadTask = nil
        self.delegate.continuation?.finish()
        self.delegate.continuation = nil
    }
}

// MARK: - DownloadHandler.URLSessionDelegate -

private
extension DownloadHandler
{
    class URLSessionDelegate: NSObject, @unchecked Sendable
    {
        // MARK: - Properties -
        
        private
        unowned var parent: DownloadHandler
        
        fileprivate
        var continuation: AsyncThrowingStream<DownloadEvent, Error>.Continuation?
        
        // MARK: - Methods -
        // MARK: Initial Method
        
        init(parent: DownloadHandler)
        {
            self.parent = parent
            super.init()
        }
        
        func moveToCatch(_ from: URL) throws -> URL
        {
            let fileManager = FileManager.default
            let catchDirectory: URL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let destinationURL = catchDirectory.appendingPathComponent("file.tmp")
            let destinationPath: String = destinationURL._path
            
            if fileManager.fileExists(atPath: destinationPath) {
                
                try fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.moveItem(at: from, to: destinationURL)
            
            return destinationURL
        }
    }
}

// MARK: - Delegate Methods -

extension DownloadHandler.URLSessionDelegate: URLSessionDownloadDelegate
{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        if let response = downloadTask.response as? HTTPURLResponse,
            let statusCode = HTTPError.StatusCode(rawValue: response.statusCode) {
            
            let error = HTTPError(statusCode)
            
            self.continuation?.finish(throwing: error)
            return
        }
        
        do {
            
            let fileUrl: URL = try self.moveToCatch(location)
            
            self.continuation?.yield(.success(fileUrl))
        } catch {
            
            self.continuation?.finish(throwing: error)
        }
        
        self.continuation?.finish()
    }
    
    nonisolated
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        guard totalBytesExpectedToWrite > 0 else {
            
            return
        }
        
        Task {
            
            @MainActor in
            
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            
            self.continuation?.yield(.progress(progress))
        }
    }
    
    nonisolated
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        guard let error = error else {
            
            return
        }
        
        Task {
            
            @MainActor in
            
            self.continuation?.finish(throwing: error)
        }
    }
}

// MARK: - Private Extensions -

fileprivate
extension URL
{
    var _path: String {
        
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            
            return self.path(percentEncoded: true)
        }
        
        return self.path
    }
}
