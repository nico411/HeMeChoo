//
//  HCOFacebookManager.m
//  HeChoo
//
//  Created by Nicolas Bradier on 5/3/13.
//  Copyright (c) 2013 Nicolas Bradier. All rights reserved.
//

#import "HCOFacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface HCOFacebookManager (PrivateMethods)

+ (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error;

@end

@implementation HCOFacebookManager

#pragma mark - Private methods

+ (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            // Close the login page
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [FBSession.activeSession closeAndClearTokenInformation];
            // Show the login view
            break;
        default:
            break;
    }
    
    // Show the error message if needed
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Public methods

#pragma mark - AppDelegate methods

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

+ (void)handleDidBecomeActive
{
    [FBSession.activeSession handleDidBecomeActive];
}

#pragma mark - Regular methods

+ (void)checkOnLaunch
{
    // See if the app has a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        // To-do, show logged in view
    }
    else
    {
        // No, display the login page.
        UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        [st instantiateViewControllerWithIdentifier:@"HCOLoginViewController"];
    }
}

+ (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
         [self sessionStateChanged:session state:state error:error];
     }];
}

@end
