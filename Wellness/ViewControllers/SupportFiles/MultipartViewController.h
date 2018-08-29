//
//  MultipartViewController.h
//  Wellness
//
//  Created by think360 on 05/06/18.
//  Copyright © 2018 bharat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SecondDelegate;
@protocol SecondDelegate <NSObject>

@optional
- (void)responsewithToken: (NSMutableDictionary *)responseToken;
- (void)responsewithToken3;
- (void)responsewithToken2;
@end

@interface MultipartViewController : UIViewController

@property (nonatomic, assign) id <SecondDelegate> delegate;

- (void)next: (UIImage *)currentSelectedImage;
-(void)CheckLoginStatus;

@end
