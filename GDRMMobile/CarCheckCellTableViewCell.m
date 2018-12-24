//
//  CarCheckCellTableViewCell.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import "CarCheckCellTableViewCell.h"

@implementation CarCheckCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView*)tableView{
 static NSString* ident=@"CarCheckCellTableViewCell";
    CarCheckCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if(cell==nil){
        UIStoryboard *second=[UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
        cell=[second instantiateViewControllerWithIdentifier:ident];
    }
    return cell;
}
@end
