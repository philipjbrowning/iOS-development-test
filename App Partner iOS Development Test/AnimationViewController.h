//
//  AnimationViewController.h
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/26/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
/*
@protocol MotionDelegate <NSObject>

- (void)motionSentMessage:(NSString*)message;
- (void)MotionSentX:(double)x andY:(double)y andZ:(double)z;

@end
*/

@interface AnimationViewController : UIViewController <AVAudioPlayerDelegate, UIAccelerometerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *characterView;
@property (weak, nonatomic) IBOutlet UILabel *textInstructionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *danceButton;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UIImage *character;
@property (strong, nonatomic) CMMotionManager *motionManager;

- (IBAction)danceStartStopPressed:(id)sender;

// - (void)startPushingAccelerationUpdatesWithX:(double*)x andY:(double*)y andZ:(double*)z;
// - (void)stopPushingAccelerationUpdates;

@end
