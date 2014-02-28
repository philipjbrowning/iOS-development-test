//
//  AnimationViewController.m
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/26/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import "AnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimationViewController ()

@property BOOL dancingIsOccuring;

- (void)addJumpingAnimationForLayer:(CALayer*)layer;
// - (void)removeJumpingAnimationForLayer:(CALayer*)layer;
- (void)playAudio;
- (void)stopAudio;

@end

@implementation AnimationViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _dancingIsOccuring = NO;
    _textInstructionsLabel.numberOfLines = 0;
    _textInstructionsLabel.text = @"Animate the images of the character. Make the character move up and down while tilting left and right. Bonus points if you add music and more characters.";
    [_textInstructionsLabel sizeToFit];
    
    // Set the background image for the navigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header"] forBarMetrics:UIBarMetricsDefault];
    
    // Set the color of the titleText to be white
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Link character UIImage
    _character = _characterView.image;
    
    // Set up the audio player
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Linus and Lucy" ofType:@"mp3"]];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"Error in audio player: %@", [error localizedDescription]);
    } else {
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Audio

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if (_dancingIsOccuring) {
        [self stopDancing];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if (_dancingIsOccuring) {
        [self stopDancing];
    }
    NSLog(@"Error in audio player: %@", [error localizedDescription]);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_dancingIsOccuring) {
        [self stopDancing];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if (!_dancingIsOccuring) {
        [self startDancing];
    }
}

- (void)playAudio
{
    [_audioPlayer play];
}

- (void)stopAudio
{
    [_audioPlayer stop];
}

#pragma mark - Dancing Animation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_dancingIsOccuring) {
        [self addJumpingAnimationForLayer:_characterView.layer];
    }
}

- (void)addJumpingAnimationForLayer:(CALayer*)layer
{
    // The keyPath to animate
    NSString *keyPath = @"transform.translation.y";
    
    // Allocate a CAKeyFrameAnimation for the specified keyPath
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    // Set animation duration and repeat
    translation.duration = 0.75f;
    translation.repeatCount = 0.0;
    translation.autoreverses = YES;
    
    // Allocate array to hold the values to interpolate
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    // Add the start value. The animation starts at a y offset 0.0.
    [values addObject:[NSNumber numberWithFloat:0.0]];
    
    // Add the end value.
    // CGFloat height = _textInstructions.frame.origin.y + _textInstructions.frame.size.height;
    CGFloat height = _textInstructionsLabel.frame.origin.y + _textInstructionsLabel.frame.size.height + _character.size.height - _danceButton.frame.origin.y;
    [values addObject:[NSNumber numberWithFloat:height]];
    
    // Set the values that should be interpolated during the animation
    translation.values = values;
    
    // Allocate array to hold the timing functions
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    
    // Add a timing function for the first animation to step to ease in the
    // animation. This step crudely simulates graviy by easing in the effect of
    // y offset
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    // Set the timing functions that should be used to calculate interpolation
    // between the first two keyframes
    translation.timingFunctions = timingFunctions;
    
    [translation setDelegate:self];
    [layer addAnimation:translation forKey:keyPath];
}

- (void)startDancing
{
    // Start dancing
    [self addJumpingAnimationForLayer:_characterView.layer];
    _dancingIsOccuring = YES;
}

- (void)stopDancing
{
    // Stop dancing
    // [self removeJumpingAnimationForLayer:_characterView.layer];
    _dancingIsOccuring = NO;
}

#pragma mark - UIButton Actions

- (IBAction)danceStartStopPressed:(id)sender {
    if (_dancingIsOccuring) {
        [self stopAudio];
        [self stopDancing];
    } else {
        [self playAudio];
        [self startDancing];
    }
}

@end
