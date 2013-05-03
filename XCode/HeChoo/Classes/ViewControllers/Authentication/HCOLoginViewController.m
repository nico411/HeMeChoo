//
//  HCOLoginViewController.m
//  HeChoo
//
//  Created by Nicolas Bradier on 5/3/13.
//  Copyright (c) 2013 Nicolas Bradier. All rights reserved.
//

#import "HCOLoginViewController.h"

@interface HCOLoginViewController ()

@end

@implementation HCOLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction methods

- (IBAction)facebookConnectButtonPressed:(id)sender
{
    [HCOFacebookManager openSession];
}

@end
