//
//  TCSettingsVC.h
//  
//
//  Created by Yang Fei on 13-11-24.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCSettingsVC : UITableViewController <RETableViewManagerDelegate>
@property (strong, readonly,  nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *basicSection;
@end
