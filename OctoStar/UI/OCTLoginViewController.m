//
//  OCTLoginViewController.m
//  OctoStar
//
//  Created by Fabian Canas on 3/30/14.
//  Copyright (c) 2014 Fabián Cañas. All rights reserved.
//

#import "OCTLoginViewController.h"
#import <WebKit/WebKit.h>
#import <OctoKit/OctoKit.h>

@interface OCTLoginViewController ()
@property (nonatomic, strong) IBOutlet WebView *webView;
@end

@implementation OCTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    
}

@end
