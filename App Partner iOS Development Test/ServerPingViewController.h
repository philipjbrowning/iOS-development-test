//
//  ServerPingViewController.h
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/26/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerPingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *pingResponseView;
@property (weak, nonatomic) IBOutlet UILabel *pingTimeLabel;

- (IBAction)serverPingButtonPressed:(id)sender;

@end
