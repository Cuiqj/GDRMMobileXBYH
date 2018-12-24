//
//  UIButton+myButton.m
//  GDRMMobile
//
//  Created by admin on 2017/11/27.
//
//

#import "UIButton+myButton.h"

@implementation UIButton (myButton)
-(void) setTitleUnderImage{
    self.titleLabel.backgroundColor = self.backgroundColor;
    self.imageView.backgroundColor  = self.backgroundColor;
    
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    CGFloat interval = 1.0;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width + interval))];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0)];
}
@end
