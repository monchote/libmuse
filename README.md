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


## Uninstall

Simply remove libmuse directory


## Android

### Quick start

We've included an example app at `examples/TestLibMuseAndroid`. Just import it
into your IDE and modify the code under `src/` to make it do what you want it
to do.

### Including it in your own application

Drop libmuse.jar and libmuse_android.so into the right place in your project.
Open `doc/index.html` in your browser to read the API documentation.


## iOS

### Quick start

We've included an example app at `examples/MuseStatsIos`. Open it in Xcode and
modify it to make it do what you want it to do. `AppDelegate.m` and
`LoggingListener.m` are good starting points.

### Including it in your own application

Add `libMuse.a` to your Xcode project, following the instructions at
[Linking to a Library or
Framework](https://developer.apple.com/library/mac/recipes/xcode_help-project_editor/Articles/AddingaLibrarytoaTarget.html)
to do so. Add Muse.h header to your project or add it to your compiler include path. Add a `#import "Muse.h"` line to your source where appropriate.
You should be able to reference classes like `IXNMuse` and `IXNMuseManager`
now. Consult the API reference rooted at `doc/index.html` for usage
information.
