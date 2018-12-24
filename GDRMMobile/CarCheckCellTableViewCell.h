//
//  CarCheckCellTableViewCell.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import <UIKit/UIKit.h>

@interface CarCheckCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
+(instancetype)cellWithTableView:(UITableView*)tableView;
@end
