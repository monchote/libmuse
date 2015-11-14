//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import "AppDelegate.h"

#import "LoggingListener.h"

@interface AppDelegate ()

@property (weak, nonatomic) IXNMuseManager *manager;
@property (nonatomic) LoggingListener *loggingListener;
@property (nonatomic) NSTimer *musePickerTimer;

@end

@implementation AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    @synchronized (self.manager) {
        // All variables and listeners are already wired up; return.
        if (self.manager)
            return;
        self.manager = [IXNMuseManager sharedManager];
    }
    if (!self.muse) {
        // Intent: show a bluetooth picker, but only if there isn't already a
        // Muse connected to the device. Do this by delaying the picker by 1
        // second. If startWithMuse happens before the timer expires, cancel
        // the timer.
        self.musePickerTimer =
            [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(showPicker)
                                           userInfo:nil
                                            repeats:NO];
    }
    // to resume connection if we disconnected in applicationDidEnterBakcground::
    // else if (self.muse.getConnectionState == IXNConnectionStateDisconnected)
    //     [self.muse runAsynchronously];
    if (!self.loggingListener)
        self.loggingListener = [[LoggingListener alloc] initWithDelegate:self];
    [self.manager addObserver:self
                   forKeyPath:[self.manager connectedMusesKeyPath]
                      options:(NSKeyValueObservingOptionNew |
                               NSKeyValueObservingOptionInitial)
                      context:nil];
}

- (void)showPicker {
    [self.manager showMusePickerWithCompletion:^(NSError *e) {
        if (e)
            NSLog(@"Error showing Muse picker: %@", e);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:[self.manager connectedMusesKeyPath]]) {
        NSSet *connectedMuses = [change objectForKey:NSKeyValueChangeNewKey];
        if (connectedMuses.count) {
            [self startWithMuse:[connectedMuses anyObject]];
        }
    }
}

- (void)startWithMuse:(id<IXNMuse>)muse {
    // Uncomment to test Muse File Reader
//    [self playMuseFile];
    @synchronized (self.muse) {
        if (self.muse) {
            return;
        }
        self.muse = muse;
    }
    [self.musePickerTimer invalidate];
    self.musePickerTimer = nil;
    [self.muse registerDataListener:self.loggingListener
                               type:IXNMuseDataPacketTypeArtifacts];
    [self.muse registerDataListener:self.loggingListener
                               type:IXNMuseDataPacketTypeBattery];
    [self.muse registerDataListener:self.loggingListener
                               type:IXNMuseDataPacketTypeAccelerometer];
    [self.muse registerConnectionListener:self.loggingListener];
    [self.muse runAsynchronously];
}

// This gets called by LoggingListener
- (void)sayHi {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Muse says hi"
                                                    message:@"Muse is now connected"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)reconnectToMuse {
    [self.muse runAsynchronously];
}

/*
 * Simple example of getting data from the "*.muse" file
 */
- (void)playMuseFile {
    NSLog(@"start play muse");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath =
        [documentsDirectory stringByAppendingPathComponent:@"testfile.muse"];
    id<IXNMuseFileReader> fileReader =
            [IXNMuseFileFactory museFileReaderWithPathString:filePath];
    while ([fileReader gotoNextMessage]) {
        IXNMessageType type = [fileReader getMessageType];
        int id_number = [fileReader getMessageId];
        int64_t timestamp = [fileReader getMessageTimestamp];
        NSLog(@"type: %d, id: %d, timestamp: %lld",
             (int)type, id_number, timestamp);
        switch(type) {
            case IXNMessageTypeEeg:
            case IXNMessageTypeQuantization:
            case IXNMessageTypeAccelerometer:
            case IXNMessageTypeBattery:
            {
                IXNMuseDataPacket* packet = [fileReader getDataPacket];
                NSLog(@"data packet = %d", (int)packet.packetType);
                break;
            }
            case IXNMessageTypeVersion:
            {
                IXNMuseVersion* version = [fileReader getVersion];
                NSLog(@"version = %@", version.firmwareVersion);
                break;
            }
            case IXNMessageTypeConfiguration:
            {
                IXNMuseConfiguration* config = [fileReader getConfiguration];
                NSLog(@"configuration = %@", config.bluetoothMac);
                break;
            }
            case IXNMessageTypeAnnotation:
            {
                IXNAnnotationData* annotation = [fileReader getAnnotation];
                NSLog(@"annotation = %@", annotation.data);
                break;
            }
            default:
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    // To disconnect instead of executing in the background:
    // [self.muse disconnect:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    self.muse = nil;
}

@end
