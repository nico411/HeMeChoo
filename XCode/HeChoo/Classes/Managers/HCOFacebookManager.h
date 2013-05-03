//
//  HCOFacebookManager.h
//  HeChoo
//
//  Created by Nicolas Bradier on 5/3/13.
//  Copyright (c) 2013 Nicolas Bradier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCOFacebookManager : NSObject

+ (void)checkOnLaunch;
+ (void)openSession;

+ (BOOL)handleOpenURL:(NSURL *)url;
+ (void)handleDidBecomeActive;

@end
