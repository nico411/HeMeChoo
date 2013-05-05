//
//  HCOFacebookManager.m
//  HeChoo
//
//  Created by Nicolas Bradier on 5/3/13.
//  Copyright (c) 2013 Nicolas Bradier. All rights reserved.
//

#import "HCOFacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "HCOLoginViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

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
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[MainTabBarController presentedViewController] view]
                                                      animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Loading";
            
            /*NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BASE_URL, @"/users/create_fb"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                    NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
                                                                                                    [hud hide:YES];
                                                                                                }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                    NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
                                                                                                    [hud hide:YES];
                                                                                                }];
            [operation start];*/
            
            NSURL *url = [NSURL URLWithString:@"http://api-base-url.com"];
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
            NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.jpg"], 0.5);
            NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
            }];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
            }];
            [httpClient enqueueHTTPRequestOperation:operation];
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
        if (![[MainTabBarController presentedViewController] isKindOfClass:[HCOLoginViewController class]]) {
            [MainTabBarController presentModalViewController:[MainStorybard instantiateViewControllerWithIdentifier:@"HCOLoginViewController"]
                                                    animated:YES];
        };
    }
    else
    {
        // No, check if the login is visible. If not, display the login page.
        if (![[MainTabBarController presentedViewController] isKindOfClass:[HCOLoginViewController class]]) {
            [MainTabBarController presentModalViewController:[MainStorybard instantiateViewControllerWithIdentifier:@"HCOLoginViewController"]
                                                    animated:YES];
        };
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
