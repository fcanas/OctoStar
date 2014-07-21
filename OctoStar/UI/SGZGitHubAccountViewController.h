//
//  SGZGitHubAccountViewController.h
//  OctoStar
//
//  Created by Fabian Canas on 4/1/14.
//  Copyright (c) 2014 Fabián Cañas. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MASPreferences/MASPreferencesViewController.h>

@interface SGZGitHubAccountViewController : NSViewController <MASPreferencesViewController>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSImage *toolbarItemImage;
@property (nonatomic, readonly) NSString *toolbarItemLabel;

@end
