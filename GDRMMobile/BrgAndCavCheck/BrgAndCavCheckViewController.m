//
//  ZLYHRoadAssetCheckViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/12.
//
//

#import "BrgAndCavCheckViewController.h"
#import "RoadAsset_Check_Main.h"
#import "RoadAsset_Check_detail.h"
#import "Roadasset_checkitem.h"
#import "Systype.h"
#import "OrgInfo.h"
#import "BridgeCheck+CoreDataClass.h"
#import "BridgeCheckDetail+CoreDataClass.h"
#import "BridgeCheckItem+CoreDataClass.h"
@interface BrgAndCavCheckViewController (){
    NSInteger leng;
    NSInteger currentSeg;
}
@property (nonatomic,strong) NSMutableArray         *mainCheckListData;
@property (nonatomic,strong) RoadAsset_Check_Main   *currentMainCheckData;
@property (nonatomic,strong) RoadAsset_Check_detail *currentCheckDetail;
@property (nonatomic,strong) NSMutableArray         *currentCheckDetailListData;
@property (nonatomic,strong) NSMutableArray         *currentCheckDetailListDataDone;
@property (nonatomic,strong) NSMutableArray         *currentCheckDetailListDataUnDone;
@property (nonatomic,strong) NSMutableArray         *CheckItemListData;
@property (nonatomic,strong) NSMutableArray         *CurrentBanciListData;
////////
@property(nonatomic,strong)NSMutableArray * mainListArray;
@property(nonatomic,strong)NSMutableArray * detailListArray;
@property(nonatomic,strong)BridgeCheck * mainModelData;
@property(nonatomic,strong)BridgeCheckDetail * detailModelData;
@end

@implementation BrgAndCavCheckViewController
NSInteger currentTag;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *image      = self.saveBtn.currentBackgroundImage ;
    CGFloat top         = 25;// 顶端盖高度
    CGFloat bottom      = 25 ;// 底端盖高度
    CGFloat left        = 10;// 左端盖宽度
    CGFloat right       = 10;// 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.saveBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.saveBtn setBackgroundImage:image forState:UIControlStateFocused];
    [self.saveBtn setBackgroundImage:image forState:UIControlEventTouchDown];
}

- (void) viewWillDisappear:(BOOL)animated{
    if (self.currentMainCheckData !=nil&&
        self.roadinspectVC ) {
        if (self.currentMainCheckData !=nil) {
            [self.roadinspectVC createRecodeByServicesCheck:self.currentMainCheckData];
            
        }
    }
    self.roadinspectVC = nil;
}
-(NSMutableArray*)mainListArray{
    if(_mainListArray==nil){
        _mainListArray= [BridgeCheck allBridgeCheck]  ;
    }
    return _mainListArray;
}
-(NSMutableArray*)CheckItemListData{
    if(_CheckItemListData==nil){
        _CheckItemListData=[ BridgeCheckItem allBridgeCheckItem]  ;
    }
    return _CheckItemListData;
}
-(void)setup{
    self.navigationItem.title=@"桥涵检查";
    self.currentCheckDetailListDataDone=[[NSMutableArray alloc]init];
    self.currentCheckDetailListDataUnDone=[[NSMutableArray alloc]init];
    self.CurrentBanciListData=[ [Systype typeValueForCodeName:@"丈量沿海班次" ] mutableCopy];
    [self.banciPicker selectRow:0 inComponent:0 animated:YES];
    //[self.editView setHidden:YES];
    currentSeg = 0;
    //[self getNewCurrentCheckDetailListData];
    [self.saveBtn.layer setMasksToBounds:YES];
    [self.saveBtn.layer  setCornerRadius:10.0];
    [self.doneorNotSeg addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.startTimeLabel setHidden:YES];
    self.detailTableView.backgroundColor=[UIColor clearColor];
    self.detailTableView.backgroundView.backgroundColor=[UIColor clearColor];
}
-(void)segChange:(UISegmentedControl*)sender{
    currentSeg = sender.selectedSegmentIndex;
    [self.detailTableView reloadData];
}
//新增的时候 从标准表拷贝到detail表
-(void)getNewCurrentCheckDetailListData{
    [self.detailListArray removeAllObjects];
    for(int i           = 0;i<self.CheckItemListData.count;i++){
        BridgeCheckItem *item=[self.CheckItemListData objectAtIndex:i];
        BridgeCheckDetail*record=[BridgeCheckDetail newDataObjectWithEntityName:@"BridgeCheckDetail"];
        //record.parent_id=self.currentMainCheckData.myid;
        record.myid=[NSString randomID];
        record.parent_id    = self.mainModelData.myid;
        record.isuploaded=@(0);
        record.status=@"0";
        record.name         = item.name;
        record.project           = item.project;
        record.east           = item.east;
        record.west         = item.west;
        record.classes      = item.classes;
        record.item_id = item.myid;
        [self.detailListArray insertObject:record atIndex:i];
    }
    
    [[AppDelegate App]saveContext];
}
#pragma mark - 处理键盘
//软键盘隐藏，恢复左下scrollview位置

- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect    = [aValue CGRectValue];
    int height             = keyboardRect.size.height;
    [self.editView setContentSize: CGSizeMake(self.editView.frame.size.width, self.editView.frame.size.height-height) ];
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect    = [aValue CGRectValue];
    int height             = keyboardRect.size.height;
    [self.editView setContentSize: CGSizeMake(self.editView.frame.size.width, self.editView.frame.size.height+height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uitextfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag==3||textField.tag==5)
        return NO;
    else
        return YES;
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.leftTableview]){
        //return  self.mainCheckListData.count  ;
        return self.mainListArray.count;
    }else if ([tableView isEqual:self.detailTableView]&&currentSeg==0){
        //return self.currentCheckDetailListData.count;
        return self.currentCheckDetailListDataUnDone.count;
    }
    else if ([tableView isEqual:self.detailTableView]&&currentSeg==1){
        //return self.currentCheckDetailListData.count;
        return self.currentCheckDetailListDataDone.count;
    }
    return 10;
}
-(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identit1=@"cell1";
    static NSString *identit2=@"cell2";
    
    
    if([tableView isEqual:self.leftTableview]){
        BridgeCheck *mainModel=[self.mainListArray objectAtIndex:indexPath.row];
        UITableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:identit1];
        if(cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identit1 ];
            
        }
        NSDateFormatter *formator =[[NSDateFormatter alloc]init];
        [formator setLocale:[NSLocale currentLocale]];
        [formator setDateFormat:@"yyyy年MM月dd日"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@", [formator stringFromDate:mainModel.check_date]];
        //cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ ",[[self.mainCheckListData objectAtIndex:indexPath.row] valueForKey:@"check_person"]];
        if (mainModel.isuploaded.boolValue) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else if ([tableView isEqual:self.detailTableView]){
        if(currentSeg==0){
            BridgeCheckDetail *detaildata=[self.currentCheckDetailListDataUnDone objectAtIndex:indexPath.row];
            UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:identit2];
            if(cell2==nil){
                cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identit2];
            }
            cell2.textLabel.text=[NSString stringWithFormat:@"%@ %@",detaildata.project,detaildata.name];
            cell2.detailTextLabel.text = detaildata.east;
            if (detaildata.isuploaded.boolValue) {
                cell2.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell2.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell2;
        }
        else if (currentSeg==1){
            BridgeCheckDetail *detaildata=[self.currentCheckDetailListDataDone objectAtIndex:indexPath.row];
            UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:identit2];
            if(cell2==nil){
                cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identit2];
            }
            cell2.textLabel.text=[NSString stringWithFormat:@"%@ %@",detaildata.project,detaildata.name];
            cell2.detailTextLabel.text = detaildata.east;
            if (detaildata.isuploaded.boolValue) {
                cell2.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell2.accessoryType = UITableViewCellAccessoryNone;
                
            }
            return cell2;
        }
    }
    return nil;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if([self.leftTableview isEqual:tableView]){
            NSLog(@"点击了删除");
            BridgeCheck *maincheck=[self.mainListArray objectAtIndex:indexPath.row];
            [self.mainListArray removeObjectAtIndex:indexPath.row];
            [self.leftTableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
            [BridgeCheckDetail deleteBridgeCheckDetailForPatentID:maincheck.myid];
            [self.CheckItemListData removeAllObjects];
            [self.currentCheckDetailListDataDone removeAllObjects];
            [self.currentCheckDetailListDataUnDone removeAllObjects];
            [[[AppDelegate App] managedObjectContext] deleteObject:maincheck];
            [[AppDelegate App]  saveContext];          //  [self getNewCurrentCheckDetailListData];
            [self.detailTableView reloadData];
        }
    }];
    // 删除一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    
    topRowAction.backgroundColor        = [UIColor blueColor];
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"无异常"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"无异常");
        if([self.detailTableView isEqual:tableView]){
            BridgeCheckDetail *detail=[self.currentCheckDetailListDataUnDone objectAtIndex:indexPath.row];
            [detail setValue:@"1" forKey:@"status"];
            [detail setValue:[NSDate date] forKey:@"recordtime"];
            [detail setValue:@"无" forKey:@"handle"];
            [detail setValue:@"" forKey:@"remark"];
            [self.currentCheckDetailListDataDone insertObject:detail atIndex:self.currentCheckDetailListDataDone.count];
            [self.currentCheckDetailListDataUnDone  removeObjectAtIndex:indexPath.row];
            //[[AppDelegate App]saveContext];
            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    moreRowAction.backgroundColor=[UIColor blueColor];
    // 将设置好的按钮放到数组中返回
    if([self.leftTableview isEqual:tableView])
        return @[deleteRowAction];
    else if([self.detailTableView isEqual:tableView]&&currentSeg==0){
        return @[moreRowAction];
    }
    else
        return nil;
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"删除");
    /*
     if ([self.leftTableview isEqual:tableView]) {
     if( [self.currentMainCheckData isEqual:[self.mainCheckListData objectAtIndex:indexPath.row]] )
     {
     self.textcarno.text=@"";
     self.textcheck_person.text=@"";
     self.textrecheck_person.text=@"";
     self.textcheck_time.text           = @"";
     self.textrecheck_time.text=@"";
     self.currentCaeCheckRecordListData = nil;
     for(int i                          = 0;i<self.currentCarCheckItemListData.count;i++){
     CarCheckItems *item=[self.currentCarCheckItemListData objectAtIndex:i];
     CarCheckRecords*record=[CarCheckRecords newDataObjectWithEntityName:@"CarCheckRecords"];
     //record.parent_id=self.currentMainCheckData.myid;
     record.myid=[NSString randomID];
     record.isuploaded=@(0);
     record.checkdesc                   = item.checkdesc;
     record.checktext                   = item.checktext;
     record.defaultvalue                = item.defaultvalue;
     record.list                        = item.list;
     [self.currentCaeCheckRecordListData insertObject:record atIndex:i];
     }
     [self.carCheckRecordsTableView reloadData];
     
     }
     [CarCheckRecords DeleteCarCheckRecordsForParent_ID:[[self.mainCheckListData objectAtIndex:indexPath.row] valueForKey:@"myid"]];
     [[[AppDelegate App] managedObjectContext] deleteObject:[self.mainCheckListData objectAtIndex:indexPath.row]];
     
     [self.mainCheckListData removeObject:[self.mainCheckListData objectAtIndex:indexPath.row]];
     [self.leftTableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
     [[AppDelegate App] saveContext];
     }
     */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.leftTableview isEqual:tableView]){
        self.mainModelData=[self.mainListArray objectAtIndex:indexPath.row];
        [self loadMainModelData:self.mainModelData];
        [self.detailTableView reloadData];
    }
    else if ([self.detailTableView isEqual:tableView]){
        if(currentSeg==0){
            self.detailModelData=[self.currentCheckDetailListDataUnDone objectAtIndex:indexPath.row];
            [self LoadDetailModelData:self.detailModelData];
        }
        else if (currentSeg==1){
            self.detailModelData=[self.currentCheckDetailListDataDone objectAtIndex:indexPath.row];
            [self LoadDetailModelData:self.detailModelData];
        }
        
    }
}
#pragma mark - UIPickerView delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.CurrentBanciListData.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return   [self.CurrentBanciListData objectAtIndex:row];// [NSString stringWithFormat:@"第%d排%d个标题",component,row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* banci=[self.CurrentBanciListData objectAtIndex:row];
    [self.currentCheckDetailListDataDone removeAllObjects];
    [self.currentCheckDetailListDataUnDone removeAllObjects];
    int j     = 0; int k=0;
    for(int i = 0;i<self.detailListArray.count;i++){
        BridgeCheckDetail *record=[self.detailListArray objectAtIndex:i];
        if([record.classes isEqualToString:banci]){
            if([record.status isEqualToString:@"1"]){
                [self.currentCheckDetailListDataDone insertObject:record atIndex:j++];
            }
            else if ([record.status isEqualToString:@"0"]){
                [self.currentCheckDetailListDataUnDone insertObject:record atIndex:k++];
            }
        }
    }
    [self.detailTableView reloadData];
}

-(void)refreshDetailTableVIewDataSource{
    NSInteger row =[self.banciPicker selectedRowInComponent:0];
    NSString* banci=[self.CurrentBanciListData objectAtIndex:row];
    [self.currentCheckDetailListDataDone removeAllObjects];
    [self.currentCheckDetailListDataUnDone removeAllObjects];
    int j     = 0; int k=0;
    for(int i = 0;i<self.detailListArray.count;i++){
        BridgeCheckDetail *record=[self.detailListArray objectAtIndex:i];
        if([record.classes isEqualToString:banci]){
            if([record.status isEqualToString:@"1"]){
                [self.currentCheckDetailListDataDone insertObject:record atIndex:j++];
            }
            else if ([record.status isEqualToString:@"0"]){
                [self.currentCheckDetailListDataUnDone insertObject:record atIndex:k++];
            }
        }
    }
    
}
-(void)LoadDetailModelData:(BridgeCheckDetail*)data{
    self.textProject.text=[NSString stringWithFormat:@"%@%@",data.name,data.project];
    self.texteast.text=data.east;
    self.textwest.text=data.west;
    self.texthandle.text=data.handle;
    self.textremark.text=data.remark;
}
-(void)loadMainModelData:(BridgeCheck*)Data{
    self.detailListArray=[BridgeCheckDetail bridgeCheckDetailForParent_id:Data.myid];
    [self refreshDetailTableVIewDataSource];
    [self.detailTableView reloadData];
}


- (IBAction)btnSave:(id)sender {
    if(self.detailModelData ==nil)
        return;
    
    self.detailModelData.east=self.texteast.text;
    self.detailModelData.west=self.textwest.text;
    self.detailModelData.handle=self.texthandle.text;
    self.detailModelData.remark=self.textremark.text;
    self.detailModelData.recordtime=[NSDate date];
    self.detailModelData.status=@"1";
    if (currentSeg==0){
        [self.currentCheckDetailListDataDone insertObject:self.detailModelData atIndex:0];
        NSIndexPath *selectedIndexPath=[self.detailTableView indexPathForSelectedRow];
        [self.currentCheckDetailListDataUnDone removeObjectAtIndex:selectedIndexPath.row];
        NSArray* indeAray=[NSArray arrayWithObjects:selectedIndexPath, nil] ;
        [self.detailTableView deleteRowsAtIndexPaths:indeAray withRowAnimation:UITableViewRowAnimationLeft];
        self.texteast.text=@"";
        self.textwest.text=@"";
        self.texthandle.text=@"";
        self.textremark.text=@"";
    }
    [[AppDelegate App]saveContext];
}
- (IBAction)btnNewZhangliang:(UIButton *)sender {
    //[[AppDelegate App] saveContext];
    BridgeCheck *mainRecord=[BridgeCheck newDataObjectWithEntityName:@"BridgeCheck"];
    mainRecord.myid=[NSString randomID];
    mainRecord.check_date=[NSDate date];
    mainRecord.org_id=[[OrgInfo orgInfoForSelected] valueForKey:@"myid"];
    self.mainModelData = mainRecord;
    [[AppDelegate App] saveContext];
    [self getNewCurrentCheckDetailListData];
    [self.mainListArray insertObject:mainRecord atIndex:0];
    [self.leftTableview reloadData];
    [self.detailTableView reloadData];
    //[self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathWithIndex:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    //[self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathWithIndex:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}
@end
