//
//  AnimationViewController.m
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/26/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()

@property BOOL dancingIsOccuring;

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
    
    // Set the background image for the navigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header"] forBarMetrics:UIBarMetricsDefault];
    
    // Set the color of the titleText to be white
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
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

- (void)startDancing
{
    // Start dancing
    
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
