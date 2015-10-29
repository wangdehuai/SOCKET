//
//  RootViewController.h
//  SOCKET
//
//  Created by 王德怀 on 15/10/29.
//  Copyright © 2015年 王德怀. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SOCKET_HOST @"192.168.1.17"
#define SOCKET_PORT 8085

@interface RootViewController : UIViewController<NSStreamDelegate>
@end
