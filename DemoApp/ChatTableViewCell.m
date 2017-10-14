//
//  ChatTableViewCell.m
//  DemoApp
//
//  Created by Nitesh Meshram on 10/13/17.
//  Copyright © 2017 Nitesh M. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self updateStyle];
    
    self.messageDesc.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageDesc.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setColorStyle:(TextColorStyle)colorStyle{

    if (colorStyle != _colorStyle) {
    
        _colorStyle = colorStyle;
    }
    [self updateStyle];
    
}

-(void)setAlighmentStyle:(TextAlighmentStyle)alighmentStyle{

    if (alighmentStyle != _alighmentStyle) {
        
        _alighmentStyle = alighmentStyle;
    }
    [self updateStyle];
}

-(void)setUserStyle:(userStyle)userStyle{

    if (userStyle != _userStyle) {
        
        _userStyle = userStyle;
    }
    [self updateStyle];
}

- (void)updateStyle
{
    
    __weak typeof(self) weakSelf = self;
    switch (weakSelf.userStyle) {
        case userStyleSender:
            
            [self.messageDesc setTextAlignment:NSTextAlignmentRight];
            [self.messageDesc setTextColor:[UIColor blueColor]];
            
            break;
            
        case userStyleReceiver:

            [self.messageDesc setTextAlignment:NSTextAlignmentLeft];
            [self.messageDesc setTextColor:[UIColor blackColor]];

            break;
            
        default:
            break;
    }
}

@end
