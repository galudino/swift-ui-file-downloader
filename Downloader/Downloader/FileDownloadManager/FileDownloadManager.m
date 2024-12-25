//
//  FileDownloadManager.m
//  Downloader
//
//  Created by Gemuele Aludino on 12/25/24.
//

#import "FileDownloadState.h"
#import "FileDownloadManager.h"

@interface FileDownloadManager () <NSURLSessionDownloadDelegate> {
    NSURLSession *session;
    NSURLSessionDownloadTask *currentDownloadTask;
    NSData *resumeData;
}

@end

@implementation FileDownloadManager

@synthesize fileURL;
@synthesize fileName;
@synthesize downloadProgress;
@synthesize downloadState;

- (instancetype)initWithFileURL:(NSURL *)fileURL {
    if (!(self = [super init])) {
        return nil;
    }
        
    self.fileURL = fileURL;
    self.fileName = [fileURL lastPathComponent];
    downloadProgress = 0.0;
    downloadState = FileDownloadStateIdle;
        
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self->session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    currentDownloadTask = nil;
    
    NSLog(@"FileDownloadManager initialized.");
        
    return self;
}

- (void)startDownload {
    currentDownloadTask = [self->session downloadTaskWithURL:self.fileURL];
    [currentDownloadTask resume];
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) sself = wself;
        sself.downloadState = FileDownloadStateDownloading;
    });
    
    NSLog(@"Starting download");
}

- (void)cancelDownload {
    [currentDownloadTask cancel];
    currentDownloadTask = nil;
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) sself = wself;
        sself.downloadProgress = 0.0;
        sself.downloadState = FileDownloadStateIdle;
        sself->resumeData = nil;
    });
    
    NSLog(@"Download canceled.");
}

- (void)pauseDownload {
    __weak typeof(self) wself = self;
    [currentDownloadTask cancelByProducingResumeData:^(NSData *data) {
        __strong typeof(self) sself = wself;
        sself->resumeData = data;
        sself->currentDownloadTask = nil;
        sself.downloadState = FileDownloadStatePaused;
    }];
    
    NSLog(@"Download paused.");
}

- (void)resumeDownload {
    currentDownloadTask = [self->session downloadTaskWithResumeData:resumeData];
    [currentDownloadTask resume];
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) sself = wself;
        sself.downloadState = FileDownloadStateDownloading;
        sself->resumeData = nil;
    });
    
    NSLog(@"Download resumed.");
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (totalBytesExpectedToWrite <= 0) {
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) sself = wself;
            sself.downloadState = FileDownloadStateError;
        });
        
        NSLog(@"Expected to write 0. Now returning.");
        return;
    }
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) sself = wself;
        sself.downloadProgress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    });
    
    NSLog(@"Download progress: %.2f%%", self.downloadProgress * 100);
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didFinishDownloadingToURL:(NSURL *)location {
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) sself = wself;
        sself.downloadState = FileDownloadStateComplete;
    });
    
    resumeData = nil;
    
    
    NSLog(@"File downloaded to: %@ - download complete.", location.path);
}

@end
