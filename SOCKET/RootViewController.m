//
//  RootViewController.m
//  SOCKET
//
//  Created by 王德怀 on 15/10/29.
//  Copyright © 2015年 王德怀. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"%@",aStream);
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"数据流打开完成");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"有可读字节");
            [self readBytes];
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可发送字节");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"连接错误");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"到达流末尾，要关闭输入输出流");
            [outputStream close];
            [inputStream close];
            [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        default:
            break;
    }
}

-(void)connect{
    //连接服务器
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef) SOCKET_HOST, SOCKET_PORT, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)(readStream);
    outputStream = (__bridge NSOutputStream *)(writeStream);
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

-(void)login{
    NSString *str = @"iam:zhangsan";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:data.bytes maxLength:data.length];
}

-(void)readBytes{
    uint8_t buffer[1012];
    NSInteger len = [inputStream read:buffer maxLength:sizeof(buffer)];
    NSData *data = [NSData dataWithBytes:buffer length:len];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
