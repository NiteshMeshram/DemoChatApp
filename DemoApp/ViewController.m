//
//  ViewController.m
//  DemoApp
//
//  Created by Nitesh Meshram on 10/13/17.
//  Copyright © 2017 Nitesh M. All rights reserved.
//

#import "ViewController.h"
#import "ChatTableViewCell.h"
#include <stdlib.h>
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *allMessageArray;

@end

@implementation ViewController
NSArray *tableData;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.allMessageArray = [[NSMutableArray alloc] init];
    
        tableData = [NSArray arrayWithObjects:@"Hi",
                     @" How are you?",
                     @"What's going on.",
                     @"I am good",
                     @"Weekend started",
                     @"I am going to wath FIFA",
                     @"White Chocolate Donut",
                     @"Starbucks Coffee",
                     @"Vegetable Curry",
                     @"Instant Noodle with Egg",
                     @"Noodle with BBQ Pork",
                     @"Japanese Noodle with Pork",
                     @"Green Tea",
                     @"Thai Shrimp Cake",
                     @"Angry Birds Cake",
                     @"Ham and Cheese Panini", nil];
    
    self.title = @"Chat Demo App";
    
    [self.chatTableView registerNib:[UINib nibWithNibName:@"ChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChatTableViewCell"];
    
    self.chatTableView.rowHeight = UITableViewAutomaticDimension;
    self.chatTableView.estimatedRowHeight = 50;
    
//    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.chatTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[DataManager sharedInstance] saveUserId:@"1" userName:@"System"];
    [[DataManager sharedInstance] saveUserId:@"1" userName:@"Nitesh"];
    
    [self.allMessageArray addObjectsFromArray:[[DataManager sharedInstance] getAllMessages]];
    
    self.messageTextView.layer.borderWidth = 3.0f;
    self.messageTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.postButton.layer.borderWidth = 2.0f;
    self.postButton.layer.borderColor = [[UIColor grayColor] CGColor];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [tableData count];
    return [self.allMessageArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

//    return 1;
    
    NSInteger numOfSections = 1;
    if (self.allMessageArray.count>0)
    {
        self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        self.chatTableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.chatTableView.bounds.size.width, self.chatTableView.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.chatTableView.backgroundView = noDataLabel;
        self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    }
    
    Message *currentMessage = [self.allMessageArray objectAtIndex:indexPath.row];
    
    if ([currentMessage.senderId isEqualToString:@"2"]) {
        [cell setUserStyle:userStyleSender];

    }
    else{
    
        [cell setUserStyle:userStyleReceiver];
    }
    
    cell.messageDesc.text = currentMessage.messageDescription;

    
     return cell;
}

-(int)getRandomNumber{
    
    NSUInteger randomNumber = arc4random_uniform((int)tableData.count);
    
    NSLog(@"randomNumber => %lu",(unsigned long)randomNumber);
    
    return (int)randomNumber;
}

- (IBAction)postMessage:(id)sender {
    
    [self.messageTextView resignFirstResponder];
    
    
    NSMutableArray *activeMessage = [[NSMutableArray alloc] init];
    [[DataManager sharedInstance] saveMessage:self.messageTextView.text userID:@"2" completion:^(BOOL b, Message *message) {
         NSLog(@"Message Saved in DB");
        [activeMessage addObject:message];
        self.messageTextView.text = @"";
        
//        [self performSelector:@selector(randomMessageFromSystem) withObject:self afterDelay:5.0 ];
    }];
    
    NSLog(@"self.allMessageArray => %lu", (unsigned long)self.allMessageArray.count);
    [self.allMessageArray addObject:[activeMessage objectAtIndex:0]];
    
    NSLog(@"self.allMessageArray => %lu", (unsigned long)self.allMessageArray.count);
    
//    [self.chatTableView reloadData];

    [self.chatTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.allMessageArray indexOfObject:[activeMessage objectAtIndex:0]] inSection:0];
    
    [self.chatTableView
     insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.chatTableView endUpdates];
    
    [self performSelector:@selector(randomMessageFromSystem) withObject:self afterDelay:5.0 ];


    
}

-(void)randomMessageFromSystem{

    NSMutableArray *activeMessage = [[NSMutableArray alloc] init];
    [[DataManager sharedInstance] saveMessage:[tableData objectAtIndex:[self getRandomNumber]] userID:@"1" completion:^(BOOL b, Message *message) {
        NSLog(@"Message Saved in DB");
        
        [activeMessage addObject:message];

        
    }];
    
    NSLog(@"self.allMessageArray => %lu", (unsigned long)self.allMessageArray.count);
    [self.allMessageArray addObject:[activeMessage objectAtIndex:0]];
    
    NSLog(@"self.allMessageArray => %lu", (unsigned long)self.allMessageArray.count);
    
    [self.chatTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.allMessageArray indexOfObject:[activeMessage objectAtIndex:0]] inSection:0];
    
    [self.chatTableView
     insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.chatTableView endUpdates];

}

-(void)getMsg{

    NSLog(@"self.allMessageArray => %@",self.allMessageArray);
    self.allMessageArray = (NSMutableArray*) [[DataManager sharedInstance] getAllMessages];
    
    NSLog(@"self.allMessageArray => %@",self.allMessageArray);
    
    for (Message *msg in self.allMessageArray) {
        NSLog(@"msg ==> %@, msg.dateTime = %@",msg.messageDescription,msg.dateTime);
    }
    

}

////



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}



@end
