//
//  AdminstrativePenaltyMapTableViewController.h
//  GDRMXBYHMobile
//
//  Created by admin on 2019/6/21.
//

#import "CasePrintViewController.h"

@interface AdminstrativePenaltyMapTableViewController : CasePrintViewController

//案由
@property (weak, nonatomic) IBOutlet UILabel *caseDesclabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *datetimelabel;
//地点
@property (weak, nonatomic) IBOutlet UILabel *placeadresslabel;
//天气
@property (weak, nonatomic) IBOutlet UILabel *weatherlabel;
//勘查图
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
//说明
@property (weak, nonatomic) IBOutlet UITextView *remarktextview;


@end
