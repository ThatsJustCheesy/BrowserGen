
#import "AppDelegate.h"

@interface AppDelegate () <WebFrameLoadDelegate>

@property(weak) IBOutlet NSWindow *window;
@property(weak) IBOutlet WebView *webView;
@property(weak) IBOutlet NSSegmentedControl *backForwardSegmentedControl;
@property(weak) IBOutlet NSSegmentedControl *zoomInOutSegmentedControl;

@end

static void* kKVOContext = &kKVOContext;

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:kKVOContext];
    [self.webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:kKVOContext];
    [self.webView addObserver:self forKeyPath:@"canMakeTextLarger" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:kKVOContext];
    [self.webView addObserver:self forKeyPath:@"canMakeTextSmaller" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:kKVOContext];
    
    self.webView.preferences.javaScriptEnabled = YES;
    self.webView.textSizeMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:@"initialTextSize"] ?: 1.0;
    [self goHome:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != kKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:@"canGoBack"]) {
        [self.backForwardSegmentedControl setEnabled:[change[NSKeyValueChangeNewKey] boolValue] forSegment:0];
    } else if ([keyPath isEqualToString:@"canGoForward"]) {
        [self.backForwardSegmentedControl setEnabled:[change[NSKeyValueChangeNewKey] boolValue] forSegment:1];
    } else if ([keyPath isEqualToString:@"canMakeTextLarger"]) {
        [self.zoomInOutSegmentedControl setEnabled:[change[NSKeyValueChangeNewKey] boolValue] forSegment:0];
    } else if ([keyPath isEqualToString:@"canMakeTextSmaller"]) {
        [self.zoomInOutSegmentedControl setEnabled:[change[NSKeyValueChangeNewKey] boolValue] forSegment:1];
    }
}

- (IBAction)backForwardClicked:(NSSegmentedControl *)sender {
    if (sender.selectedSegment == 0) {
        [self.webView goBack];
    } else if (sender.selectedSegment == 1) {
        [self.webView goForward];
    }
}

- (IBAction)zoomInOutClicked:(NSSegmentedControl *)sender {
    if (sender.selectedSegment == 0) {
        [self.webView makeTextLarger:sender];
    } else if (sender.selectedSegment == 1) {
        [self.webView makeTextSmaller:sender];
    }
}

- (IBAction)goHome:(id)sender {
    self.webView.mainFrameURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"homepage"] ?: @"data:text/plain,There is no homepage set! Try regenerating with BrowserGen.";
}

@end
