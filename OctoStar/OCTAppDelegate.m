//
//  OCTAppDelegate.m
//  OctoStar
//
//  Created by Fabian Canas on 3/30/14.
//  Copyright (c) 2014 Fabián Cañas. All rights reserved.
//

#import "OCTAppDelegate.h"
#import "SGZGitHubClientService.h"
#import "SGZGitHubAccountViewController.h"

#import <MASPreferences/MASPreferencesWindowController.h>

@interface OCTAppDelegate ()
@property (nonatomic, strong) NSWindowController *preferencesWindowController;
@end

@implementation OCTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager setEventHandler:self
                           andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                         forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    if ([url.scheme isEqualToString:@"octostar"] && [url.host isEqual:@"oauth"]) {
        [SGZGitHubClientService completeSignInWithCallbackURL:url];
    }
}

- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        NSViewController *accountViewController = [[SGZGitHubAccountViewController alloc] initWithNibName:@"SGZGitHubAccountViewController"
                                                                                                   bundle:nil];
//        NSViewController *advancedViewController = [[AdvancedPreferencesViewController alloc] init];
        NSArray *controllers = @[accountViewController];
        
        // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
        //     NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], advancedViewController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers
                                                                                                 title:title];
    }
    return _preferencesWindowController;
}

#pragma mark - Actions

- (IBAction)openPreferences:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
}

@end
