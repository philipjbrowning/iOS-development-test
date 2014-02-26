//
//  FacebookViewController.h
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/26/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *facebookTableView;

- (IBAction)addButtonPressed:(id)sender;

@end