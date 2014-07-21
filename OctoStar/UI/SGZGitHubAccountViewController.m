//
//  SGZGitHubAccountViewController.m
//  OctoStar
//
//  Created by Fabian Canas on 4/1/14.
//  Copyright (c) 2014 Fabián Cañas. All rights reserved.
//

#import "SGZGitHubAccountViewController.h"
#import "SGZGitHubClientService.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

OBJC_ROOT_CLASS
@interface FCZombie

@end

@interface SGZGitHubAccountViewController ()
@property (nonatomic, strong) IBOutlet NSTextField *nameLabel;
@property (nonatomic, strong) IBOutlet NSTextField *usernameLabel;
@property (nonatomic, strong) IBOutlet NSImageView *userAvatarView;
@property (nonatomic, strong) IBOutlet NSButton *signInOutButton;

@property (nonatomic, strong) OCTClient *client;
@property (nonatomic, strong) SGZGitHubClientService *clientService;

@property (nonatomic, weak) NSImage *avatar;
@end

@implementation SGZGitHubAccountViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self == nil) {
        return nil;
    }
    
    self.clientService = [SGZGitHubClientService new];
    self.client = [self.clientService client];
    
    if (self.client == nil) {
        [self.clientService getClient:^(OCTClient *client) {
            self.client = client;
        }];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userAvatarView.layer.borderColor = [NSColor blackColor].CGColor;
    self.userAvatarView.layer.borderWidth = 1;
}

- (void)viewWillAppear
{
    [self updateUI];
}

- (void)updateUI
{
    if (_client == nil) {
        [self.signInOutButton setTitle:@"Sign In"];
    } else {
        [self.signInOutButton setTitle:@"Sign Out"];
    }
    
    [[[self.client fetchUserInfo] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(OCTUser *user) {
        
        if (user.avatarURL) {
            NSURLRequest *request = [NSURLRequest requestWithURL:user.avatarURL];
            [[[[NSURLConnection rac_sendAsynchronousRequest:request]
                                  reduceEach:^id(NSURLResponse *response, NSData *data){
                                      return [[NSImage alloc] initWithData:data];
                                  }]
                                 deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
                self.avatar = x;
            }];
        }
        
        if (user.login) {
            [self.usernameLabel setStringValue:user.login];
        }
        
        if (user.name) {
            [self.nameLabel setStringValue:user.name];
        }
    }];
    
}

- (IBAction)signInOut:(id)sender
{
    if (self.client) {
        self.client = nil;
        [self.clientService signOut];
    } else {
        [self.clientService getClient:^(OCTClient *client) {
            self.client = client;
        }];
    }
    [self updateUI];
}

- (void)setAvatar:(NSImage *)avatar
{
    _avatar = avatar;
    self.userAvatarView.image = _avatar;
}

- (NSString *)identifier
{
    return @"GitHibAccountPreferences";
}

- (NSString *)toolbarItemLabel
{
    return @"GitHub Account";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"guest"];
}

@end
