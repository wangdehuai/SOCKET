//
//  SocketViewController.m
//  SOCKET
//
//  Created by 王德怀 on 15/10/30.
//  Copyright © 2015年 王德怀. All rights reserved.
//

#import "SocketViewController.h"

@interface SocketViewController ()

@end

@implementation SocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%d",SOCKET_HOST,SOCKET_PORT]];
    [[[NSThread alloc] initWithTarget:self selector:@selector(loadDataFromServerWithURL:) object:url] start];
}

- (void)loadDataFromServerWithURL:(NSURL *)url
{
    NSInputStream * readStream;
    [NSStream getStreamsToHostWithName:SOCKET_HOST port:SOCKET_PORT inputStream:&readStream outputStream:NULL];
    [readStream setDelegate:self];
    [readStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [readStream open];
    
    [[NSRunLoop currentRunLoop] run];
}

#pragma mark NSStreamDelegate
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    NSLog(@" >> NSStreamDelegate in Thread %@", [NSThread currentThread]);
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            if (_receivedData == nil) {
                _receivedData = [[NSMutableData alloc] init];
            }
            uint8_t buffer[1012];
            NSInteger len = [inputStream read:buffer maxLength:sizeof(buffer)];
            if (len > 0) {
                NSData *data = [NSData dataWithBytes:buffer length:len];
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@",str);
            } else if (len == 0) {
                NSLog(@" >> End of stream reached");
            } else {
                NSLog(@" >> Read error occurred");
            }
            break;
        }
        case NSStreamEventErrorOccurred: {
            NSError * error = [stream streamError];
            NSString * errorInfo = [NSString stringWithFormat:@"Failed while reading stream; error '%@' (code %ld)", error.localizedDescription, (long)error.code];
            [self cleanUpStream:stream];
            NSLog(@"%@",errorInfo);
        }
        case NSStreamEventEndEncountered: {
            [self cleanUpStream:stream];
            NSLog(@"传输完成");
            break;
        }
        default:
            break;
    }
}

- (void)cleanUpStream:(NSStream *)stream
{
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream close];
    stream = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
