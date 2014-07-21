//
//  SGZGitHubUserViewModel.m
//  OctoStar
//
//  Created by Fabian Canas on 4/2/14.
//  Copyright (c) 2014 Fabián Cañas. All rights reserved.
//

#import "SGZGitHubUserViewModel.h"

@interface SGZGitHubUserViewModel ()
@property (nonatomic, readonly, strong) OCTUser *user;
@end

@implementation SGZGitHubUserViewModel

- (instancetype)initWithUser:(OCTUser *)user
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    [self setUser:user];
    
    return self;
}

- (void)setUser:(OCTUser *)user
{
    _user = user;
    
    RAC(self, name) = RACObserve(user, name);
    RAC(self, login) = RACObserve(user, login);
    
    
//    RAC(self, avatar) = 
}

@end
