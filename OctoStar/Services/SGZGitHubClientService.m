//
//  SGZGitHubClientService.m
//  OctoStar
//
//  Created by Fabian Canas on 4/1/14.
//  Copyright (c) 2014 Fabián Cañas. All rights reserved.
//

#import "SGZGitHubClientService.h"
#import <OctoKit/OctoKit.h>
#import <FXKeychain/FXKeychain.h>

NSString * const OCTKeychainRawLoginKey = @"OCTKeychainRawLoginKey";
NSString * const OCTKeychainSavedTokenKey = @"OCTLoginKeychainKey";

@interface SGZGitHubClientService ()
@property (nonatomic, strong) OCTClient *client;
@end

@implementation SGZGitHubClientService

- (instancetype)init
{
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    
    [OCTClient setClientID:keys[@"githubClientID"]
              clientSecret:keys[@"githubSecret"]];
    
    return self;
}

- (OCTClient *)client
{
    if (_client != nil) {
        return _client;
    }
    
    _client = [self clientFromLocalCredentials];
    
    return _client;
}

- (OCTClient *)clientFromLocalCredentials
{
    // Load client from local credentials.
    NSString *rawLogin = [[FXKeychain defaultKeychain] objectForKey:OCTKeychainRawLoginKey];
    NSString *savedToken = [[FXKeychain defaultKeychain] objectForKey:OCTKeychainSavedTokenKey];
    if (!(rawLogin.length > 0 && savedToken.length > 0)) {
        return nil;
    }
    
    OCTUser *user = [OCTUser userWithRawLogin:rawLogin server:OCTServer.dotComServer];
    return [OCTClient authenticatedClientWithUser:user token:savedToken];
}

- (void)getClient:(void (^)(OCTClient *)) clientCallback
{
    OCTClient *client = [self client];
    
    if (client == nil) {
        [self signInWithCallback:clientCallback];
        return;
    }
    
    if (clientCallback) {
        clientCallback(client);
    }
}

- (void)signInWithCallback:(void (^)(OCTClient *)) clientCallback
{
    [[OCTClient signInToServerUsingWebBrowser:OCTServer.dotComServer
                                       scopes:OCTClientAuthorizationScopesUser]
     subscribeNext:^(OCTClient *authenticatedClient) {
         // Authentication was successful. Do something with the created client.
         NSString *rawlogin = authenticatedClient.user.rawLogin;
         [[FXKeychain defaultKeychain] setObject:rawlogin forKey:OCTKeychainRawLoginKey];
         [[FXKeychain defaultKeychain] setObject:authenticatedClient.token forKey:OCTKeychainSavedTokenKey];
         if (clientCallback) {
             clientCallback(authenticatedClient);
         }
     } error:^(NSError *error) {
         // Authentication failed.
         
         NSAlert *loginAlert = [[NSAlert alloc] init];
         [loginAlert setMessageText:NSLocalizedString(@"Logging in to GitHub Failed.", nil)];
         [loginAlert addButtonWithTitle:@"OK"];
         [loginAlert setInformativeText:[error localizedDescription]];
         
         [loginAlert runModal];
     }];
}

- (void)signOut
{
    [[FXKeychain defaultKeychain] removeObjectForKey:OCTKeychainRawLoginKey];
    [[FXKeychain defaultKeychain] removeObjectForKey:OCTKeychainSavedTokenKey];
    self.client = nil;
}

+ (void)completeSignInWithCallbackURL:(NSURL *)url
{
    [OCTClient completeSignInWithCallbackURL:url];
}

@end
