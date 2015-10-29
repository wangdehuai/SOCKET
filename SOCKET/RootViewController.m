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
    //    NSStreamEventOpenCompleted = 1UL << 0,
    //    NSStreamEventHasBytesAvailable = 1UL << 1,
    //    NSStreamEventHasSpaceAvailable = 1UL << 2,
    //    NSStreamEventErrorOccurred = 1UL << 3,
    //    NSStreamEventEndEncountered = 1UL << 4
    switch (eventCode) {
        case NSStreamEventOpenCompleted://数据流打开完成
            NSLog(@"数据流打开完成");
            break;
        case NSStreamEventHasBytesAvailable://有可读字节
            NSLog(@"有可读字节");
            [self readBytes];
            break;
        case NSStreamEventHasSpaceAvailable:// 可发送字节
            NSLog(@"可发送字节");
            break;
        case NSStreamEventErrorOccurred://连接错误
            NSLog(@"连接错误");
            break;
        case NSStreamEventEndEncountered://到达流未尾，要关闭输入输出流
            NSLog(@"到达流未尾，要关闭输入输出流");
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
    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef) host, port, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)(readStream);
    outputStream = (__bridge NSOutputStream *)(writeStream);
    inputStream.delegate = self;
    outputStream.delegate = self;
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
