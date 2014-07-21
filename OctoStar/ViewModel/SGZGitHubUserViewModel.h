//
//  SGZGitHubUserViewModel.h
//  OctoStar
//
//  Created by Fabian Canas on 4/2/14.
//  Copyright (c) 2014 Fabián Cañas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OctoKit/OctoKit.h>

@interface SGZGitHubUserViewModel : NSObject

@property (nonatomic, strong) NSImage *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *login;

- (instancetype)initWithUser:(OCTUser *)user;

@end
