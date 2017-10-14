//
//  ChatTableViewCell.h
//  DemoApp
//
//  Created by Nitesh Meshram on 10/13/17.
//  Copyright © 2017 Nitesh M. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, TextColorStyle) {
    TextColorStyleBlue,
    TextColorStyleOrange
};

typedef NS_ENUM(NSUInteger, TextAlighmentStyle) {
    TextAlighmentStyleLeft,
    TextAlighmentRight,
};

typedef NS_ENUM(NSUInteger, userStyle) {
    userStyleSender,
    userStyleReceiver,
};


@interface ChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageDesc;

@property (nonatomic, assign) TextColorStyle colorStyle;
@property (nonatomic, assign) TextAlighmentStyle alighmentStyle;
@property (nonatomic, assign) userStyle userStyle;

@end
