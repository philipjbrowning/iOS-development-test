//
//  AnimationViewController.m
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/26/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import "AnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

const float BORDER_X = 20.0;
const float SPEED_X = 5.0;

@interface AnimationViewController ()
{
    double accelerationX;
    double offsetX;
}

@property BOOL dancingIsOccuring;
@property (nonatomic) NSTimer *accelerometerDataInterval;

- (void)addJumpingAnimationForLayer:(CALayer*)layer;
// - (void)pullAccelerationWithX:(double*)x andY:(double*)y andZ:(double*)z;
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
    offsetX = 0.0;
    
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
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.05; // 20 Hz
    [self.motionManager startAccelerometerUpdates];
    
    _accelerometerDataInterval = [[NSTimer alloc] init];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.motionManager stopAccelerometerUpdates];
    [_audioPlayer stop];
    _audioPlayer.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accelerometer

- (void)getAccelerometerValues:(NSTimer*)timer
{
    accelerationX = self.motionManager.accelerometerData.acceleration.x;
    [self addLeftAndRightMovement];
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
    } else {
        // Stop x movement
        [_accelerometerDataInterval invalidate];
        _accelerometerDataInterval = nil;
    }
}

- (void)addJumpingAnimationForLayer:(CALayer*)layer
{
    // The keyPath to animate
    NSString *keyPathY = @"transform.translation.y";
    
    // Allocate a CAKeyFrameAnimation for the specified keyPath
    CAKeyframeAnimation *translationY = [CAKeyframeAnimation animationWithKeyPath:keyPathY];
    // [translationY setValue:@"Vertical" forKey:@"AnimationType"];
    
    // Set animation duration and repeat
    translationY.duration = 0.75f;
    translationY.repeatCount = 0.0;
    translationY.autoreverses = YES;
    
    // Allocate array to hold the values to interpolate
    NSMutableArray *valuesY = [[NSMutableArray alloc] init];
    
    // Add the start value. The animation starts at a y offset 0.0.
    [valuesY addObject:[NSNumber numberWithFloat:0.0]];
    
    // Add the end value.
    CGFloat height = _textInstructionsLabel.frame.origin.y + _textInstructionsLabel.frame.size.height + _character.size.height - _danceButton.frame.origin.y;
    [valuesY addObject:[NSNumber numberWithFloat:height]];
    
    // Set the values that should be interpolated during the animation
    translationY.values = valuesY;
    
    // Allocate array to hold the timing functions
    NSMutableArray *timingFunctionsY = [[NSMutableArray alloc] init];
    
    // Add a timing function for the first animation to step to ease in the
    // animation. This step crudely simulates graviy by easing in the effect of
    // y offset
    [timingFunctionsY addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    // Set the timing functions that should be used to calculate interpolation
    // between the first two keyframes
    translationY.timingFunctions = timingFunctionsY;
    
    // Monitor translation to determine when it finishes
    [translationY setDelegate:self];
    
    // Begin translation
    [layer addAnimation:translationY forKey:keyPathY];
}

- (void)addLeftAndRightMovement
{
    NSLog(@"asdf");
    CGRect frame = _characterView.frame;
    if ((frame.origin.x + accelerationX * SPEED_X) < BORDER_X) {
        frame.origin.x = BORDER_X;
    }
    else if ((frame.origin.x + accelerationX * SPEED_X) > ([[UIScreen mainScreen] applicationFrame].size.width - _characterView.frame.size.width - BORDER_X))
    {
        frame.origin.x = [[UIScreen mainScreen] applicationFrame].size.width - _characterView.frame.size.width - BORDER_X;
    }
    else
    {
        frame.origin.x = frame.origin.x + accelerationX * SPEED_X;
    }
    _characterView.frame = frame;
}

- (void)startDancing
{
    // Start dancing
    _accelerometerDataInterval = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getAccelerometerValues:) userInfo:nil repeats:YES];
    [self addJumpingAnimationForLayer:_characterView.layer];
    // [self addLeftAndRightMovementForLayer:_characterView.layer];
    _dancingIsOccuring = YES;
}

- (void)stopDancing
{
    // Stop dancing
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
