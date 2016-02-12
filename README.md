# libmuse

libmuse is a library for interfacing with Muse headbands, including finding
paired Muses, connecting to them, reading their state, and receiving packets
for raw EEG data and all other values. You can use it in your own applications,
subject to the terms of our license.

The library consists of two parts: a core in C++ and a platform-specific
interface in whatever language your platform writes its interfaces in: Java for
Android, Objective-C for iOS.

Visit http://developer.choosemuse.com for additional information.

Have questions? Visit [Muse Forum](http://forum.choosemuse.com/)

## iOS

### Quick start

We've included an example app at `Example`. Open it in Xcode and
modify it to make it do what you want it to do. `AppDelegate.m` and
`LoggingListener.m` are good starting points.

### Including it in your own application

Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) and add the following line to your project's Podfile:

```
pod "libmuse", :git => 'https://github.com/monchote/libmuse.git'
```

Add a `#import "Muse.h"` line to your source where appropriate. If you're using Swift, make sure you add it to your bridging header.
You should be able to reference classes like `IXNMuse` and `IXNMuseManager` now. Consult the API reference rooted at `doc/index.html` for usage information.
