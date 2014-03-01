//
//  ServerPingViewController.m
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/26/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import "ServerPingViewController.h"

@interface ServerPingViewController ()

@property (nonatomic) NSMutableData *receivedData;
@property (nonatomic) NSURLConnection *theConnection;
@property (nonatomic) NSTimeInterval pingTime;

- (void)pingServer;

@end

@implementation ServerPingViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animation

- (void)animatePingViewInWithTime:(NSTimeInterval)time
{
    // Set new ping time in text label
    _pingTimeLabel.text = [NSString stringWithFormat:@"Ping Time: %.2fms", _pingTime];
    
    // Animate in frame_popup
    _pingResponseView.hidden = false;
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         _pingResponseView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(animatePingViewOut) withObject:nil afterDelay:1.0];
                     }];
}

- (void)animatePingViewOut
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         _pingResponseView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         _pingResponseView.hidden = true;
                     }];
}

#pragma mark - UIButton Actions

- (IBAction)serverPingButtonPressed:(id)sender
{
    [self pingServer];
}

#pragma mark - NSURLRequest

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release the connection and the data object by setting the properties
    // (declared elsewhere) to nil.  Note that a real-world app usually requires
    // the delegate to manage more than one connection at a time, so these lines
    // would typically be replaced by code to iterate through whatever data
    // structures you are using.
    _theConnection = nil;
    _receivedData = nil;
    
    // Inform the user
    UIAlertView *connectionFailureAlert = [[UIAlertView alloc] initWithTitle:@"Connection failed!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [connectionFailureAlert show];
    
    // Log the error
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Do something with the data. receivedData is declared as a property
    // elsewhere
    if ([[[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding] isEqualToString:@"Success!"]) {
        // Show time taken in miliseconds
        [self animatePingViewInWithTime:_pingTime];
    } else {
        // Inform the user that the ping was not successful
        UIAlertView *pingUnsuccessfulAlert = [[UIAlertView alloc] initWithTitle:@"Ping Unsuccessful" message:@"The connection data was invalid." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [pingUnsuccessfulAlert show];
    }
    
    // Release the connection and the data object by setting the properties
    // (declared elsewhere) to nil.  Note that a real-world app usually requires
    // the delegate to manage more than one connection at a time, so these lines
    // would typically be replaced by code to iterate through whatever data
    // structures you are using.
    _theConnection = nil;
    _receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Stop the timer
    _pingTime = ([[NSDate date] timeIntervalSince1970] - _pingTime) * 100;
    
    // This method is called when the server has determined that it has enough
    // information to create the NSURLResponse object. It can be called multiple
    // times, for example in the case of a redirect, so each time we reset the
    // data. receivedData is an instance variable declared elsewhere.
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.  receivedData is an instance
    // variable declared elsewhere.
    [_receivedData appendData:data];
}

- (void)pingServer
{
    // In body data for the 'application/x-www-form-urlencoded' content type,
    // form fields are separated by an ampersand. Note the absence of a leading
    // ampersand.
    NSString *bodyData = @"Password=EGOT";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-54-243-205-92.compute-1.amazonaws.com/Tests/ping.php"]];
    
    // Set the request's content type to application/x-www-form-urlencoded
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    // Create the NSMutableData to hold the received data. receivedData is an
    // instance variable declared elsewhere.
    _receivedData = [NSMutableData dataWithCapacity: 0];
    
    // Start the timer
    _pingTime = [[NSDate date] timeIntervalSince1970];
    
    // Create the connection with the request and start loading the data
    _theConnection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
    if (!_theConnection) {
        // Release the receivedData object.
        _receivedData = nil;
        
        // Inform the user that the connection failed.
        UIAlertView *pingFailureAlert = [[UIAlertView alloc] initWithTitle:@"Ping Error" message:@"The connection was not able to be opened." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [pingFailureAlert show];
    }
}

@end
