//
//  FileDownloadViewModel.swift
//  Downloader
//
//  Created by Gemuele Aludino on 12/25/24.
//

import SwiftUI
import Combine

/// Typically, I'd use the @Observable macro for this,
/// but for this app, we're using an Objective-C backend for the file downloader.
/// Therefore, to facilitate interop, we need to use the ObservableObject protocol & @Published property wrappers.
/// The FileDownloadManager (the file downloader, written in Objective-C) uses KVO (key-value observation) notifications
/// so we can monitor changes for UI updates.
class FileDownloadViewModel: ObservableObject {
    @Published var progress: Float = 0.0
    @Published var state: FileDownloadState = .idle
    
    private var manager: FileDownloadManager!
    
    private var kvoObservationDownloadProgress: NSKeyValueObservation!
    private var kvoObservationDownloadState: NSKeyValueObservation!
    
    var fileName: String {
        manager.fileName
    }
    
    var urlString: String {
        manager.fileURL.absoluteString
    }
    
    var percentageComplete: Int {
        Int(progress * 100)
    }
    
    static let sampleURL = URL(string: "http://ipv4.download.thinkbroadband.com/100MB.zip")!
    
    init(url: URL = sampleURL) {
        manager = FileDownloadManager(fileURL: url)
        initializeKVOObservation()
    }
    
    deinit {
        kvoObservationDownloadProgress.invalidate()
        kvoObservationDownloadState.invalidate()
    }
    
    func startDownload() {
        manager.startDownload()
    }
    
    func cancelDownload() {
        manager.cancelDownload()
    }
    
    func pauseDownload() {
        manager.pauseDownload()
    }
    
    func resumeDownload() {
        manager.resumeDownload()
    }
    
    private func initializeKVOObservation() {
        kvoObservationDownloadProgress = manager.observe(\.downloadProgress,
                                          options: [.new]) { [weak self] _, change in
            guard let progress = change.newValue else {
                return
            }
            
            DispatchQueue.main.async {
                self?.progress = progress
            }
        }
        
        kvoObservationDownloadState = manager.observe(\.downloadState,
                                          options: [.new]) { [weak self] _, change in
            guard let state = change.newValue else {
                return
            }
            
            DispatchQueue.main.async {
                self?.state = FileDownloadState(rawValue: UInt(state))!
            }
        }
    }
}
