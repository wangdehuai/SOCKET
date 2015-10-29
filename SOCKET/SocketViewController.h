//
//  SocketViewController.h
//  SOCKET
//
//  Created by 王德怀 on 15/10/30.
//  Copyright © 2015年 王德怀. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SOCKET_HOST @"192.168.1.17"
#define SOCKET_PORT 8085
#define kBufferSize 1012
@interface SocketViewController : UIViewController<NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@property(nonatomic,retain)NSMutableData *receivedData;
@end
