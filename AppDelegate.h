//
//  AppDelegate.h
//  CutLongPic
//
//  Created by 威盛电气 on 2017/6/7.
//  Copyright © 2017年 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

