//
//  Macros.h
//  HeChoo
//
//  Created by Nicolas BRADIER on 5/4/13.
//  Copyright (c) 2013 Nicolas Bradier. All rights reserved.
//

#ifndef HeChoo_Macros_h
#define HeChoo_Macros_h

#import "HCOAppDelegate.h"

#define AppDelegate (HCOAppDelegate *)[[UIApplication sharedApplication] delegate]
#define MainStorybard (UIStoryboard *)[UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]]
#define MainTabBarController (UITabBarController *)AppDelegate.window.rootViewController

#endif
