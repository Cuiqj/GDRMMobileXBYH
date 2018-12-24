//
//  ZLYHRoadAssetCheckViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/12.
//
//

#import "ZLYHRoadAssetCheckViewController.h"
#import "RoadAsset_Check_Main.h"
#import "RoadAsset_Check_detail.h"
#import "Roadasset_checkitem.h"
#import "Systype.h"
#import "OrgInfo.h"
@interface ZLYHRoadAssetCheckViewController (){
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
@end

@implementation ZLYHRoadAssetCheckViewController
NSInteger currentTag;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"丈量沿海";
    self.mainCheckListData=[[RoadAsset_Check_Main allRoadAsset_Check_Main] mutableCopy];;
    // self.CheckItemListData=[[Roadasset_checkitem allRoadasset_checkitem] mutableCopy];
    self.CheckItemListData=[[NSMutableArray alloc]init];
    self.currentCheckDetailListData=[[NSMutableArray alloc]init];
    self.currentCheckDetailListDataDone=[[NSMutableArray alloc]init];
    self.currentCheckDetailListDataUnDone=[[NSMutableArray alloc]init];
    self.CurrentBanciListData=[ [Systype typeValueForCodeName:@"丈量沿海班次" ] mutableCopy];
    [self.banciPicker selectRow:0 inComponent:0 animated:YES];
    //[self.editView setHidden:YES];
    currentSeg = 0;
    [self getNewCurrentCheckDetailListData];
    [self.saveBtn.layer setMasksToBounds:YES];
    [self.saveBtn.layer  setCornerRadius:10.0];
    [self.doneorNotSeg addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.startTimeLabel setHidden:YES];
    self.detailTableView.backgroundColor=[UIColor clearColor];
    self.detailTableView.backgroundView.backgroundColor=[UIColor clearColor];
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
-(void)segChange:(UISegmentedControl*)sender{
    currentSeg = sender.selectedSegmentIndex;
    [self.detailTableView reloadData];
}
-(void)getNewCurrentCheckDetailListData{
    self.currentCheckDetailListDataDone=[[NSMutableArray alloc]init];
    for(id object in self.currentCheckDetailListData ){
        // [[[AppDelegate App] managedObjectContext] deleteObject:object];
    }
    [[AppDelegate App]saveContext];
    int j               = 0;
    for(int i           = 0;i<self.CheckItemListData.count;i++){
        Roadasset_checkitem *item=[self.CheckItemListData objectAtIndex:i];
        RoadAsset_Check_detail*record=[RoadAsset_Check_detail newDataObjectWithEntityName:@"RoadAsset_Check_detail"];
        //record.parent_id=self.currentMainCheckData.myid;
        record.myid=[NSString randomID];
        record.parent_id    = self.currentMainCheckData.myid;
        record.isuploaded=@(0);
        record.status=@"0";
        record.name         = item.name;
        record.zh           = item.zh;
        record.fw           = item.fw;
        record.side         = item.side;
        record.project      = item.project;
        record.checkitem_id = item.myid;
        record.banci        = item.banci;
        record.order_number=item.order_number;
        [self.currentCheckDetailListData insertObject:record atIndex:i];
        NSString* defaultbanci=[self.CurrentBanciListData objectAtIndex:0];
        if([record.banci isEqualToString:defaultbanci] ){
            [self.currentCheckDetailListDataUnDone insertObject:record atIndex:j++];
        }
    }
}
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
/*
 -(void)texttouch:(UITextField*)sender{
 currentTag = sender.tag;
 if([self.pickPopover isPopoverVisible]){
 [self.pickPopover dismissPopoverAnimated:YES];
 self.pickPopover = nil;
 }
 else{
 switch (currentTag ){
 case 1:{
 ListSelectViewController *listVC=[[ListSelectViewController alloc]init];
 listVC.delegate = self;
 listVC.data=[Systype typeValueForCodeName:@"巡查车号"];
 self.pickPopover =[[UIPopoverController alloc] initWithContentViewController:listVC];
 [self.pickPopover setPopoverContentSize:CGSizeMake(140, 200)];
 listVC.pickerPopover = self.pickPopover;
 [self.pickPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
 }
 break;
 case 2:{
 ListSelectViewController *listVC=[[ListSelectViewController alloc]init];
 listVC.delegate = self;
 listVC.data=[[UserInfo allUserInfo] valueForKeyPath:@"username"];
 self.pickPopover =[[UIPopoverController alloc] initWithContentViewController:listVC];
 [self.pickPopover setPopoverContentSize:CGSizeMake(140, 200)];
 listVC.pickerPopover = self.pickPopover;
 [self.pickPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
 }
 break;
 case 3:
 case 5:{
 UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
 DateSelectController *datePicker=[mainstoryboard instantiateViewControllerWithIdentifier:@"datePicker"];
 datePicker.delegate   = self;
 datePicker.pickerType = 1;
 // [datePicker showdate:self.textDate.text];
 self.pickPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
 [self.pickPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
 datePicker.dateselectPopover = self.pickPopover;
 }
 break;
 case 4:{
 ListSelectViewController *listVC=[[ListSelectViewController alloc]init];
 listVC.delegate = self;
 listVC.data=[[UserInfo allUserInfo] valueForKeyPath:@"username"];
 self.pickPopover =[[UIPopoverController alloc] initWithContentViewController:listVC];
 [self.pickPopover setPopoverContentSize:CGSizeMake(140, 200)];
 listVC.pickerPopover = self.pickPopover;
 [self.pickPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
 }
 break;
 default:
 break;
 }
 }
 }
 -(void)setDate:(NSString *)date{
 NSDateFormatter *formator =[[NSDateFormatter alloc]init];
 [formator setLocale:[NSLocale currentLocale]];
 [formator setDateFormat:@"yyyy-MM-dd HH:mm"];
 switch (currentTag ){
 case 3:{
 self.textcheck_time.text = date;
 }
 break;
 case 5:{
 self.textrecheck_time.text = date;
 }
 break;
 default:
 break;
 }
 }
 - (void)setSelectData:(NSString *)data{
 switch (currentTag ){
 case 1:{
 self.textcarno.text = data;
 }
 break;
 case 2:{
 self.textcheck_person.text = data;
 }
 break;
 case 4:{
 self.textrecheck_person.text = data;
 }
 break;
 default:
 break;
 }
 }
 */


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
        return  self.mainCheckListData.count  ;
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
        RoadAsset_Check_Main *maindata =[self.mainCheckListData objectAtIndex:indexPath.row];
        UITableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:identit1];
        if(cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identit1 ];
            
        }
        NSDateFormatter *formator =[[NSDateFormatter alloc]init];
        [formator setLocale:[NSLocale currentLocale]];
        [formator setDateFormat:@"yyyy年MM月dd日"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@", [formator stringFromDate:maindata.start_date]];
        //cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ ",[[self.mainCheckListData objectAtIndex:indexPath.row] valueForKey:@"check_person"]];
        if (maindata.isuploaded.boolValue) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else if ([tableView isEqual:self.detailTableView]){
        if(currentSeg==0){
            RoadAsset_Check_detail *detaildata=[self.currentCheckDetailListDataUnDone objectAtIndex:indexPath.row];
            UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:identit2];
            if(cell2==nil){
                cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identit2];
            }
            cell2.textLabel.text=[NSString stringWithFormat:@"%@ %@",detaildata.project,detaildata.name];
            cell2.detailTextLabel.text = detaildata.zh;
            if (detaildata.isuploaded.boolValue) {
                cell2.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell2.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell2;
        }
        else if (currentSeg==1){
            RoadAsset_Check_detail *detaildata=[self.currentCheckDetailListDataDone objectAtIndex:indexPath.row];
            UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:identit2];
            if(cell2==nil){
                cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identit2];
            }
            cell2.textLabel.text=[NSString stringWithFormat:@"%@ %@",detaildata.project,detaildata.name];
            cell2.detailTextLabel.text = detaildata.zh;
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
            RoadAsset_Check_Main *maincheck=[self.mainCheckListData objectAtIndex:indexPath.row];
            [self.mainCheckListData removeObjectAtIndex:indexPath.row];
            [self.leftTableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
            [RoadAsset_Check_detail ideleteRoadAsset_Check_detailWithPatentID:maincheck.myid];
            [self.CheckItemListData removeAllObjects];
            [self.currentCheckDetailListDataDone removeAllObjects];
            [self.currentCheckDetailListDataUnDone removeAllObjects];
            [[[AppDelegate App] managedObjectContext] deleteObject:maincheck];
            [[AppDelegate App]  saveContext];            [self getNewCurrentCheckDetailListData];
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
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"丈量"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"丈量");
        if([self.detailTableView isEqual:tableView]){
            RoadAsset_Check_detail *detail=[self.currentCheckDetailListDataUnDone objectAtIndex:indexPath.row];
            [detail setValue:@"1" forKey:@"status"];
            [detail setValue:[NSDate date] forKey:@"recordtime"];
            [detail setValue:@"无" forKey:@"problem"];
            [detail setValue:@"无" forKey:@"redline"];
            [self.currentCheckDetailListDataDone insertObject:detail atIndex:self.currentCheckDetailListDataDone.count];
            [self.currentCheckDetailListDataUnDone  removeObjectAtIndex:indexPath.row];
            //[[AppDelegate App]saveContext];
            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
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
        self.currentMainCheckData=[self.mainCheckListData objectAtIndex:indexPath.row];
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        for (RoadAsset_Check_detail *reco in self.currentCheckDetailListData) {
            if(reco.parent_id == nil||[reco.parent_id isEqualToString: @"" ])
                ;// [context deleteObject:reco];
        }
        [[AppDelegate App]saveContext];
        self.currentCheckDetailListData=[[RoadAsset_Check_detail roadAsset_Check_detailForParent_id:self.currentMainCheckData.myid] mutableCopy];
        [self refreshDetailTableVIewDataSource];
        [self.detailTableView reloadData];
        NSDateFormatter *formator =[[NSDateFormatter alloc]init];
        [formator setLocale:[NSLocale currentLocale]];
        [formator setDateFormat:@"yyyy年MM月dd日"];
        self.startTimeLabel.text = [formator stringFromDate: self.currentMainCheckData.start_date];
    }
    else if ([self.detailTableView isEqual:tableView]){
        if(currentSeg==0){
            self.currentCheckDetail=[self.currentCheckDetailListDataUnDone objectAtIndex:indexPath.row];
            [self iLoadDetailItem];
        }
        else if (currentSeg==1){
            self.currentCheckDetail=[self.currentCheckDetailListDataDone objectAtIndex:indexPath.row];
            [self iLoadDetailItem];
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
    for(int i = 0;i<self.currentCheckDetailListData.count;i++){
        RoadAsset_Check_detail *record=[self.currentCheckDetailListData objectAtIndex:i];
        if([record.banci isEqualToString:banci]){
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
    for(int i = 0;i<self.currentCheckDetailListData.count;i++){
        RoadAsset_Check_detail *record=[self.currentCheckDetailListData objectAtIndex:i];
        if([record.banci isEqualToString:banci]){
            if([record.status isEqualToString:@"1"]){
                [self.currentCheckDetailListDataDone insertObject:record atIndex:j++];
            }
            else if ([record.status isEqualToString:@"0"]){
                [self.currentCheckDetailListDataUnDone insertObject:record atIndex:k++];
            }
        }
    }
    
}
-(void)iLoadDetailItem{
    self.textProblem.text  = self.currentCheckDetail.problem;
    self.textSolution.text = self.currentCheckDetail.handle;
    self.textHongxian.text = self.currentCheckDetail.redline;
    self.textRemark.text   = self.currentCheckDetail.remark;
}



- (IBAction)btnSave:(id)sender {
    if(self.currentCheckDetail ==nil)
        return;
    self.currentCheckDetail.problem = self.textProblem.text;
    self.currentCheckDetail.handle  = self.textSolution.text;
    self.currentCheckDetail.redline = self.textHongxian.text ;
    self.currentCheckDetail.remark  = self.textRemark.text;
    self.currentCheckDetail.status=@"1";
    self.currentCheckDetail.recordtime=[NSDate date];
    if (currentSeg==0){
        [self.currentCheckDetailListDataDone insertObject:self.currentCheckDetail atIndex:0];
        NSIndexPath *selectedIndexPath=[self.detailTableView indexPathForSelectedRow];
        [self.currentCheckDetailListDataUnDone removeObjectAtIndex:selectedIndexPath.row];
        NSArray* indeAray=[NSArray arrayWithObjects:selectedIndexPath, nil] ;
        [self.detailTableView deleteRowsAtIndexPaths:indeAray withRowAnimation:UITableViewRowAnimationLeft];
    }
    //self.currentCheckDetail=nil;
    self.textProblem.text=@"";
    self.textSolution.text=@"";
    self.textHongxian.text=@"";
    self.textRemark.text=@"";
    [[AppDelegate App]saveContext];
}

- (IBAction)btnNewZhangliang:(UIButton *)sender {
    //[[AppDelegate App] saveContext];
    RoadAsset_Check_Main *mainRecord=[RoadAsset_Check_Main newDataObjectWithEntityName:@"RoadAsset_Check_Main"];
    mainRecord.myid=[NSString randomID];
    mainRecord.start_date=[NSDate date];
    mainRecord.org_id=[[OrgInfo orgInfoForSelected] valueForKey:@"myid"];
    self.currentMainCheckData = mainRecord;
    self.CheckItemListData=[[Roadasset_checkitem allRoadasset_checkitem] mutableCopy];
    [self getNewCurrentCheckDetailListData];
    [[AppDelegate App] saveContext];
    [self.mainCheckListData insertObject:mainRecord atIndex:0];
    [self.leftTableview reloadData];
    [self.detailTableView reloadData];
    //[self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathWithIndex:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}
@end
