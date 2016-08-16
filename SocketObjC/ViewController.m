//
//  ViewController.m
//  SocketObjC
//
//  Created by macuser on 8/14/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(checkConnectivity)
                                   userInfo:nil
                                    repeats:YES];
    
}

-(void)checkConnectivity
{
    Reachability *networkReachability = [Reachability reachabilityForLocalWiFi];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        [self makeAlert];
        
    } else {
        [self checkCorrectWiFi];
    }
}

-(void)checkCorrectWiFi
{
    NSArray *validSSIDs = [NSArray arrayWithObjects:@"MJ-2.4GHz",
                                                    @"MJ-5GHz",
                           nil];
    NSDictionary *ssIdInfo = [self fetchSSIDInfo];
    NSString *ssIdName = ssIdInfo[@"SSID"];
    bool ssIDok = false;
    for (NSString *okSSID in validSSIDs)
        if ([ssIdName isEqualToString:okSSID])
        {
            ssIDok = true;
            [timer invalidate];
            timer = nil;
            [self initNetworkCommunication];
        }
    if (!ssIDok)
    {
        [self makeAlert];
    }
}

- (NSDictionary *)fetchSSIDInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        NSLog(@"%@",SSIDInfo[@"SSID"]);
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

-(void) makeAlert
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Connect to an appropriate WiFi."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                           
                               
                               
                           }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
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
