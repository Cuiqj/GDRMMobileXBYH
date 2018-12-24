//
//  SelectTypeResultController.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/6/6.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CaseIDHandler.h"

@interface SelectTypeResultController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic)  UIPopoverController *myPopover;

@property (nonatomic,weak) id <CaseIDHandler> delegate;
@property (retain,nonatomic) NSMutableArray * SelectList;

@property (weak, nonatomic) IBOutlet UITableView * SelectTypeResult;
@property (nonatomic, nonatomic) NSNumber * textfieldtag;
@property (weak, nonatomic) IBOutlet UINavigationBar *NavigationShow;




- (IBAction)btnClickEdit:(id)sender;


@end
