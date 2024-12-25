# swift-ui-file-downloader
Project that demonstrates interop between Swift, SwiftUI, and Objective-C. (file downloader)

Note: this readme is under construction.

This project, as of this README writing, builds and runs on macOS 14.6.1, with Xcode 16.2.
Haven't tested it on other platforms yet.

The goal of this project is to learn how to:
- Integrate an Objective-C backend class (say, a file download manager) into a SwiftUI environment
- Observe changes in the Objective-C class, and have them propagate to a SwiftUI view

The Objective-C class must have properties that are KVO-compliant, 
as this is the means by which the properties will be observed on the Swift/SwiftUI end.

Source files to look at:
- `DownloaderApp.swift`: app entry point
- `ContentView.swift`: initial view
- `FileDownloadView.swift`: the main view - this is a single window/view application
- `FileDownloadViewModel.swift`: `FileDownloadView`'s view model - the view's interface for the backend
- `FileDownloadManager.h`: Objective-C class declaration for the `FileDownloadManager` (app's backend)
- `FileDownloadManager.m`: Objective-C class definition for the `FileDownloadManager`
- `FileDownloadState.h`: `NS_ENUM` type that represents the state of the download
