//
//  XNOAppDelegate.h
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/3/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)initializeCoreDataStack;

@end
