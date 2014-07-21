//
//  SGZGitHubUserService.h
//  OctoStar
//
//  Created by Fabian Canas on 4/1/14.
//  Copyright (c) 2014 Fabián Cañas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OctoKit/OctoKit.h>

@interface SGZGitHubClientService : NSObject

/**
 Returns the current OCTClient.

 This method will attempt to create an OCTClient with locally available keys and tokens. This method will not initiate a web login.
 @return An authenticated OCTClient, or nil if key and token are not locally available.
 */
- (OCTClient *)client;

/**
 Get an OCTClient.

 The method will return an OCTClient configured with local key and token when available.
 If a client cannot be built locally, this method initiates the login process and calls
 its callback parameter if that process results in an authenticated client.
 
 @param clientCallback A block that takes an authenticated OCTClient as a parameter. 
 Called when an appropriate OCTClient becomes available, either through local
 instantiation or web login.
 */
- (void)getClient:(void (^)(OCTClient *)) clientCallback;

+ (void)completeSignInWithCallbackURL:(NSURL *)url;

- (void)signOut;

@end
