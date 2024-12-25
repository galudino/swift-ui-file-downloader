//
//  FileDownloadManager.h
//  Downloader
//
//  Created by Gemuele Aludino on 12/25/24.
//

#import "FileDownloadState.h"

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface FileDownloadManager : NSObject

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSString *fileName;

// KVO-compliant property.
@property (nonatomic, assign) float downloadProgress;

// KVO-compliant property.
// downloadState should be re-instantiated or cast back
// to FileDownloadState.
// KVO notifications don't work properly with NS_ENUM types
// for some reason, even though the underlying
// type for FileDownloadState is NSUInteger.
@property (nonatomic, assign) NSUInteger downloadState;

- (instancetype)initWithFileURL:(NSURL *)fileURL;
- (void)startDownload;
- (void)cancelDownload;
- (void)pauseDownload;
- (void)resumeDownload;

@end

NS_ASSUME_NONNULL_END
