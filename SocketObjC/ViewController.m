//
//  ViewController.m
//  SocketObjC
//
//  Created by macuser on 8/14/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNetworkCommunication];
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.132", 23, &readStream, &writeStream);
    inputStream =  (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
}

- (IBAction)btnPressed:(UIButton *)sender
{
    NSString *tcpString;
    
    switch (sender.tag)
    {
        case 0:
            //vol +
            tcpString = @"MVUP";
            break;
            
        case 1:
            //vol -
            tcpString = @"MVDOWN";
            break;
            
        case 2:
            //directv
            tcpString = @"SISAT/CBL";
            break;
        
        case 3:
            //chromecast
            tcpString = @"SIDVR";
            break;
        
        case 4:
            //ps4
            tcpString = @"SIBD";
            break;
        
        case 5:
            //xbox1
            tcpString = @"SIDVD";
            break;
            
        case 6:
            //phono
            tcpString = @"SICD";
            break;
        default:
            break;
    }
    
    [self tcpCallwithcommand:tcpString];
    
}

-(void) tcpCallwithcommand:(NSString *)tcpString
{
    NSString *response  = [NSString stringWithFormat:@"%@\r", tcpString];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

@end
