//
//  DHActionManager.h
//  
//
//  Created by Yang Fei on 13-7-21.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface DHActionManager : NSObject <UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate>

+ (DHActionManager *)shared;
- (void)showAndHideHUDWithTitle:(NSString *)title detailText:(NSString *)detail inView:(UIView *)view;
- (void)showHUDWithTitle:(NSString *)title detailText:(NSString *)detail;
- (MBProgressHUD *)showHUDWithTitle:(NSString *)title detailText:(NSString *)detail inView:(UIView *)view;
- (void)composeMailToRecipients:(NSArray *)recipients withSubject:(NSString *)subject body:(NSString *)body;
- (void)composeMessageToRecipients:(NSArray *)recipients withBody:(NSString *)body;

@end
