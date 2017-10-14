//
//  ViewController.h
//  DemoApp
//
//  Created by Nitesh Meshram on 10/13/17.
//  Copyright © 2017 Nitesh M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Message+CoreDataClass.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

- (IBAction)postMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;


@end

