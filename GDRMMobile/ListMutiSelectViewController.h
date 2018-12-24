//
//  ListMutiSelectViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/6.
//
//

#import <UIKit/UIKit.h>
@protocol ListMutiSelectPopoverDelegate;
@interface ListMutiSelectViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIBarButtonItem *cancle;
@property(nonatomic,strong)UIBarButtonItem *conform;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *conformBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancleBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,weak)UIPopoverController *pickerPopover;
//@property (strong, nonatomic) UITableView * ListView;

@property(nonatomic,weak)id<ListMutiSelectPopoverDelegate> delegate;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) NSMutableArray *tempdata;
@property(nonatomic,strong) NSString*selectedData;
@property (nonatomic,copy) void (^setDataCallback)(NSArray*);

//-(void(^)(NSArray*dataArray))setDataCallback;

@end
