//
//  ViewController.h
//  SocketObjC
//
//  Created by macuser on 8/14/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"


NSInputStream *inputStream;
NSOutputStream *outputStream;
NSTimer *timer;

@interface ViewController : UIViewController <NSStreamDelegate>

- (IBAction)btnPressed:(UIButton *)sender;



@end

