//
//  FileDownloadState+CustomStringConvertible.swift
//  Downloader
//
//  Created by Gemuele Aludino on 12/25/24.
//

extension FileDownloadState: CustomStringConvertible {
    public var description: String {
        Self.table[self]!
    }
    
    private static let table: [FileDownloadState: String] = [
        .idle: "Idle",
        .downloading: "Downloading",
        .paused: "Paused",
        .error: "Error",
        .complete: "Complete"
    ]
}
