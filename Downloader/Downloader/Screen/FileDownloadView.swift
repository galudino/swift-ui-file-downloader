//
//  FileDownloadView.swift
//  Downloader
//
//  Created by Gemuele Aludino on 12/25/24.
//

import SwiftUI

struct FileDownloadView: View {
    @StateObject private var viewModel: FileDownloadViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: FileDownloadViewModel())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            textLabelStack
            progressStack
            statusStack
            buttonStack
        }
        .padding()
    }
    
    private var textLabelStack: some View {
        VStack {
            Text("Downloading:")
                .font(.headline)
            
            Text(viewModel.fileName)
                .bold()
                .monospaced()
                .lineLimit(1)
                .truncationMode(.middle)
            
            Text(viewModel.urlString)
                .monospaced()
                .font(.subheadline)
                .foregroundStyle(.blue)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
    
    private var progressStack: some View {
        VStack {
            ProgressView(value: viewModel.progress)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(height: 20)
            
            Text("\(viewModel.percentageComplete)%")
                .font(.largeTitle)
        }
    }
    
    private var statusStack: some View {
        HStack {
            Text("Status: \(String(describing: viewModel.state))")
        }
    }
    
    private var buttonStack: some View {
        HStack {
            switch viewModel.state {
            case .idle:
                startDownloadButton
            case .downloading:
                pauseDownloadButton
            case .paused:
                resumeDownloadButton
            default:
                startDownloadButton
            }
            cancelDownloadButton
        }
    }
    
    private var startDownloadButton: some View {
        Button("Start Download") {
            viewModel.startDownload()
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var pauseDownloadButton: some View {
        Button("Pause Download") {
            viewModel.pauseDownload()
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var resumeDownloadButton: some View {
        Button("Resume Download") {
            viewModel.resumeDownload()
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var cancelDownloadButton: some View {
        Button("Cancel Download") {
            viewModel.cancelDownload()
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.state != .downloading)
    }
}

#Preview {
    FileDownloadView()
}
