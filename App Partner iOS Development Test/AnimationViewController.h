//
//  AnimationViewController.h
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/26/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AnimationViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UIImage *character;
@property (weak, nonatomic) IBOutlet UIImageView *characterView;
@property (weak, nonatomic) IBOutlet UILabel *textInstructionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *danceButton;

- (IBAction)danceStartStopPressed:(id)sender;

@end
