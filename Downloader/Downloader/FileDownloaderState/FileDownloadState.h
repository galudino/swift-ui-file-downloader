//
//  FileDownloadState.h
//  Downloader
//
//  Created by Gemuele Aludino on 12/25/24.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FileDownloadState) {
    FileDownloadStateIdle,
    FileDownloadStateDownloading,
    FileDownloadStatePaused,
    FileDownloadStateError,
    FileDownloadStateComplete
};

NS_ASSUME_NONNULL_END
