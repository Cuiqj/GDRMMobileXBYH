//
//  CarCheckViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import "CarCheckViewController.h"
#import "CarCheckItems.h"
#import "CarCheckRecords.h"
#import "CheckInstitutions.h"
#import "CarCheckCellTableViewCell.h"
#import "ListSelectViewController.h"
#import "Systype.h"
#import "UserInfo.h"
#import "OrgInfo.h"
@interface CarCheckViewController ()
- (void)keyboardWillHide:(NSNotification *)aNotification;

- (void)keyboardWillShow:(NSNotification *)aNotification;
@property(nonatomic,strong) NSMutableArray *mainCheckListData;
@property(nonatomic,strong) CheckInstitutions *currentMainCheckData;
@property(nonatomic,strong) CarCheckRecords*currentCaeCheckRecord;
@property(nonatomic,strong) NSMutableArray*currentCarCheckItemListData;
@property(nonatomic,strong) NSMutableArray*currentCaeCheckRecordListData;
@property(nonatomic,strong) NSMutableArray*currentJieGuoListData;
@end

@implementation CarCheckViewController
NSInteger currentTag;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainCheckListData=[[CheckInstitutions allCheckInstitutions] mutableCopy];;
    self.currentCarCheckItemListData=[[CarCheckItems allCarCheckItems] mutableCopy];
    self.currentCaeCheckRecordListData=[[NSMutableArray alloc]init];
    self.textcarno.tag=1;
    self.textcheck_person.tag=2;
    self.textcheck_time.tag=3;
    self.textrecheck_person.tag=4;
    self.textrecheck_time.tag=5;
    [self.textcarno addTarget:self action:@selector(texttouch:) forControlEvents:UIControlEventTouchDown];
    [self.textcheck_person addTarget:self action:@selector(texttouch:) forControlEvents:UIControlEventTouchDown];
    [self.textcheck_time addTarget:self action:@selector(texttouch:) forControlEvents:UIControlEventTouchDown];
    [self.textrecheck_person addTarget:self action:@selector(texttouch:) forControlEvents:UIControlEventTouchDown];
    [self.textrecheck_time addTarget:self action:@selector(texttouch:) forControlEvents:UIControlEventTouchDown];
    
    for(int i=0;i<self.currentCarCheckItemListData.count;i++){
        CarCheckItems *item=[self.currentCarCheckItemListData objectAtIndex:i];
        CarCheckRecords*record=[CarCheckRecords newDataObjectWithEntityName:@"CarCheckRecords"];
        //record.parent_id=self.currentMainCheckData.myid;
        record.myid=[NSString randomID];
        record.isuploaded=@(0);
        record.checkdesc=item.checkdesc;
        record.checktext=item.checktext;
        record.defaultvalue=item.defaultvalue;
        record.list=item.list;
        [self.currentCaeCheckRecordListData insertObject:record atIndex:i];
    }
    self.currentJieGuoListData=[NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"正常", @"不正常",nil]];
    self.navigationItem.title=@"车辆检查";
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    
    
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UILabel class]]){
            UILabel *label=(UILabel*)view;
            label.adjustsFontSizeToFitWidth=YES;
        }
    }
}
//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
     NSLog([NSString stringWithFormat:@"消失前 原始原点  x:%d  y :%d",self.detailView.frame.origin.x,self.detailView.frame.origin.y]);
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [self.detailView setFrame: CGRectMake(self.detailView.frame.origin.x, self.detailView.frame.origin.y+height, self.detailView.frame.size.width, self.detailView.frame.size.height) ];
    [self.detailView updateConstraintsIfNeeded];
    
     NSLog([NSString stringWithFormat:@"新原点  gao:%d x:%d  y :%d",height,self.detailView.frame.origin.x,self.detailView.frame.origin.y]);
   
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSLog([NSString stringWithFormat:@"出现前原始原点  x:%d  y :%d",self.detailView.frame.origin.x,self.detailView.frame.origin.y]);
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [self.detailView setFrame: CGRectMake(self.detailView.frame.origin.x, self.detailView.frame.origin.y-height, self.detailView.frame.size.width, self.detailView.frame.size.height) ];
    NSLog([NSString stringWithFormat:@"新原点  gao:%d x:%d  y :%d",height,self.detailView.frame.origin.x,self.detailView.frame.origin.y]);
     [self.detailView updateConstraintsIfNeeded];
    [self.view bringSubviewToFront:self.detailView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)texttouch:(UITextField*)sender{
    currentTag=sender.tag;
    if([self.pickPopover isPopoverVisible]){
        [self.pickPopover dismissPopoverAnimated:YES];
        self.pickPopover=nil;
    }
    else{
       switch (currentTag ){
           case 1:{
               ListSelectViewController *listVC=[[ListSelectViewController alloc]init];
               listVC.delegate=self;
               listVC.data=[Systype typeValueForCodeName:@"巡查车号"];
               self.pickPopover =[[UIPopoverController alloc] initWithContentViewController:listVC];
               [self.pickPopover setPopoverContentSize:CGSizeMake(140, 200)];
               listVC.pickerPopover=self.pickPopover;
               [self.pickPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
           }
               break;
           case 2:{
               ListSelectViewController *listVC=[[ListSelectViewController alloc]init];
               listVC.delegate=self;
               listVC.data=[[UserInfo allUserInfo] valueForKeyPath:@"username"];
               self.pickPopover =[[UIPopoverController alloc] initWithContentViewController:listVC];
                [self.pickPopover setPopoverContentSize:CGSizeMake(140, 200)];
               listVC.pickerPopover=self.pickPopover;
               [self.pickPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
           }
               break;
           case 3:
           case 5:{
               UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
               DateSelectController *datePicker=[mainstoryboard instantiateViewControllerWithIdentifier:@"datePicker"];
               datePicker.delegate=self;
               datePicker.pickerType=1;
               // [datePicker showdate:self.textDate.text];
               self.pickPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
               [self.pickPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
               datePicker.dateselectPopover=self.pickPopover;
           }
               break;
           case 4:{
               ListSelectViewController *listVC=[[ListSelectViewController alloc]init];
               listVC.delegate=self;
               listVC.data=[[UserInfo allUserInfo] valueForKeyPath:@"username"];
               self.pickPopover =[[UIPopoverController alloc] initWithContentViewController:listVC];
                [self.pickPopover setPopoverContentSize:CGSizeMake(140, 200)];
               listVC.pickerPopover=self.pickPopover;
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
            self.textcheck_time.text=date;
        }
            break;
        case 5:{
            self.textrecheck_time.text=date;
        }
            break;
            default:
            break;
    }
}
- (void)setSelectData:(NSString *)data{
    switch (currentTag ){
        case 1:{
            self.textcarno.text=data;
        }
            break;
        case 2:{
            self.textcheck_person.text=data;
        }
            break;
        case 4:{
            self.textrecheck_person.text=data;
        }
            break;
            default:
            break;
    }
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
        return  self.mainCheckListData.count  ;
    }else if ([tableView isEqual:self.carCheckRecordsTableView]){
        return self.currentCaeCheckRecordListData.count;
    }
    return 10;
}
-(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identit1=@"cell1";
    static NSString *identit2=@"cell2";
    
    if([tableView isEqual:self.leftTableview]){
        UITableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:identit1];
        if(cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identit1 ];
            
        }
        NSDateFormatter *formator =[[NSDateFormatter alloc]init];
        [formator setLocale:[NSLocale currentLocale]];
        [formator setDateFormat:@"yyyy年MM月dd日"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",
                                    [formator stringFromDate: [[self.mainCheckListData objectAtIndex:indexPath.row]        valueForKey:@"check_time"]]
                                 ,[[self.mainCheckListData objectAtIndex:indexPath.row] valueForKey:@"carno"]];
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ ",[[self.mainCheckListData objectAtIndex:indexPath.row] valueForKey:@"check_person"]];
        CheckInstitutions *data=[self.mainCheckListData objectAtIndex:indexPath.row];
        if (data.isuploaded.boolValue) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }

        return cell;

    }else if ([tableView isEqual:self.carCheckRecordsTableView]){
//        CarCheckCellTableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:identit2];
//        if(cell==nil){
//            cell=[[CarCheckCellTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identit2 ];
//            
//        }
        CarCheckCellTableViewCell*cell=[CarCheckCellTableViewCell cellWithTableView:tableView];
        
        cell.leftLabel.text=[NSString stringWithFormat:@"%@",[[self.currentCaeCheckRecordListData objectAtIndex:indexPath.row] valueForKey:@"checktext"] ];
        
        cell.rightLabel.text=[NSString stringWithFormat:@"%@ ",[[self.currentCaeCheckRecordListData objectAtIndex:indexPath.row] valueForKey:@"defaultvalue"]];
        return cell;
    }
    UITableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:identit1];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identit1 ];

    }
    cell.textLabel.text=[NSString stringWithFormat:@"第%d个标题",indexPath.row];
     cell.detailTextLabel.text=[NSString stringWithFormat:@"第%d个内容",indexPath.row];
    return cell;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.leftTableview isEqual:tableView]){
        return UITableViewCellEditingStyleDelete;
    }
    return nil;
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.leftTableview isEqual:tableView]) {
        if( [self.currentMainCheckData isEqual:[self.mainCheckListData objectAtIndex:indexPath.row]] )
        {
            self.textcarno.text=@"";
            self.textcheck_person.text=@"";
            self.textrecheck_person.text=@"";
            self.textcheck_time.text= @"";
            self.textrecheck_time.text=@"";
            self.currentCaeCheckRecordListData=nil;
            for(int i=0;i<self.currentCarCheckItemListData.count;i++){
                CarCheckItems *item=[self.currentCarCheckItemListData objectAtIndex:i];
                CarCheckRecords*record=[CarCheckRecords newDataObjectWithEntityName:@"CarCheckRecords"];
                //record.parent_id=self.currentMainCheckData.myid;
                record.myid=[NSString randomID];
                record.isuploaded=@(0);
                record.checkdesc=item.checkdesc;
                record.checktext=item.checktext;
                record.defaultvalue=item.defaultvalue;
                record.list=item.list;
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
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.leftTableview isEqual:tableView]){
        self.currentMainCheckData=[self.mainCheckListData objectAtIndex:indexPath.row];
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        for (CarCheckRecords *reco in self.currentCaeCheckRecordListData) {
            if(reco.parent_id == nil||[reco.parent_id isEqualToString: @"" ])
               [context deleteObject:reco];
        }
        [[AppDelegate App]saveContext];
        self.currentCaeCheckRecordListData=[[NSMutableArray alloc]init];
        self.currentCaeCheckRecordListData=[[CarCheckRecords CarCheckRecordsForParent_ID:self.currentMainCheckData.myid] mutableCopy];
        [self.carCheckRecordsTableView reloadData];
        self.textcarno.text=self.currentMainCheckData.carno;
        self.textcheck_person.text=self.currentMainCheckData.check_person;
        self.textrecheck_person.text=self.currentMainCheckData.recheck_person;
        NSDateFormatter *formator =[[NSDateFormatter alloc]init];
        [formator setLocale:[NSLocale currentLocale]];
        [formator setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textcheck_time.text= [formator stringFromDate: self.currentMainCheckData.check_time];
        self.textrecheck_time.text= [formator stringFromDate: self.currentMainCheckData.recheck_time];
    }
    else if ([self.carCheckRecordsTableView isEqual:tableView]){
        
        self.currentCaeCheckRecord=[self.currentCaeCheckRecordListData objectAtIndex:indexPath.row];
        NSString *list=self.currentCaeCheckRecord.list ;
        NSMutableArray *aaa=[[list componentsSeparatedByString:@";"] mutableCopy];
        self.currentJieGuoListData=[NSMutableArray arrayWithArray:aaa];
        NSInteger  i=[aaa  indexOfObject: self.currentCaeCheckRecord.defaultvalue ];
        [self.jieguoPicker reloadAllComponents];
        self.requirementLabel.text=self.currentCaeCheckRecord.checkdesc;
        self.textremark.text=self.currentCaeCheckRecord.reason;
        // [self.jieguoPicker selectedRowInComponent:i];
		[self.jieguoPicker selectRow:i inComponent:0 animated:YES];
    }
}
#pragma mark - UIPickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.currentJieGuoListData.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return   [self.currentJieGuoListData objectAtIndex:row];// [NSString stringWithFormat:@"第%d排%d个标题",component,row];
}

- (IBAction)BtnSaveDetail:(id)sender {
	NSIndexPath* indexPath = [self.carCheckRecordsTableView indexPathForSelectedRow];
    CarCheckRecords *record=[self.currentCaeCheckRecordListData objectAtIndex:indexPath.row];
    NSString *defauttext=  [self.currentJieGuoListData objectAtIndex:  [self.jieguoPicker selectedRowInComponent:0]];
    [ self.currentCaeCheckRecordListData[indexPath.row] setValue:defauttext forKey:@"defaultvalue"];
    [ self.currentCaeCheckRecordListData[indexPath.row] setValue:self.textremark.text forKey:@"reason"];
    CarCheckCellTableViewCell*cell= [self.carCheckRecordsTableView cellForRowAtIndexPath: [self.carCheckRecordsTableView indexPathForSelectedRow]];
    cell.rightLabel.text=defauttext;
    //[self.carCheckRecordsTableView reloadData];
    if(self.currentMainCheckData != nil){
        [[AppDelegate App]saveContext];
    }
}

- (IBAction)BtnSaveMain:(id)sender {
    NSDateFormatter *formator =[[NSDateFormatter alloc]init];
    [formator setLocale:[NSLocale currentLocale]];
    [formator setDateFormat:@"yyyy-MM-dd HH:mm"];
    BOOL isnew=NO;
    if(self.currentMainCheckData==nil){
        isnew=YES;
        self.currentMainCheckData=[CheckInstitutions newDataObjectWithEntityName:@"CheckInstitutions"];
        self.currentMainCheckData.myid=[NSString randomID];
        for(id Record in  self.currentCaeCheckRecordListData ){
            [Record setValue: self.currentMainCheckData.myid forKey:@"parent_id"];
        }
        
    }
    self.currentMainCheckData.carno=self.textcarno.text;
    self.currentMainCheckData.org_id=[[OrgInfo orgInfoForSelected] valueForKey:@"myid"];
    self.currentMainCheckData.check_person=self.textcheck_person.text;
    //NSDate * da=[formator dateFromString:self.textcheck_time.text];
    self.currentMainCheckData.check_time= [formator dateFromString:self.textcheck_time.text];
    self.currentMainCheckData.recheck_person=self.textrecheck_person.text;
    self.currentMainCheckData.recheck_time=[formator dateFromString:self.textrecheck_time.text];
    [[AppDelegate App] saveContext];
    if(isnew){
     [self.mainCheckListData addObject:self.currentMainCheckData];
    }
    
    [self.leftTableview reloadData];
    //[self.leftTableview insertRowsAtIndexPaths:[NSArray arrayWithObjects:self.currentMainCheckData, nil] withRowAnimation:UITableViewRowAnimationFade];
    //[self.leftTableview addObject:self.currentMainCheckData];
    NSIndexPath *indexpath=[NSIndexPath indexPathWithIndex:0];
    //[self.leftTableview insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
}
-(void)clean{
    self.textcarno.text=@"";
    self.textcheck_person.text=@"";
    self.textrecheck_person.text=@"";
    self.textcheck_time.text= @"";
    self.textrecheck_time.text=@"";
    self.currentCaeCheckRecordListData=[[NSMutableArray alloc]init];
    for(int i=0;i<self.currentCarCheckItemListData.count;i++){
        CarCheckItems *item=[self.currentCarCheckItemListData objectAtIndex:i];
        CarCheckRecords*record=[CarCheckRecords newDataObjectWithEntityName:@"CarCheckRecords"];
        //record.parent_id=self.currentMainCheckData.myid;
        record.myid=[NSString randomID];
        record.isuploaded=@(0);
        record.checkdesc=item.checkdesc;
        record.checktext=item.checktext;
        record.defaultvalue=item.defaultvalue;
        record.list=item.list;
        [self.currentCaeCheckRecordListData insertObject:record atIndex:i];
    }
    self.currentMainCheckData=nil;
    [self.carCheckRecordsTableView reloadData];
    self.currentJieGuoListData=[NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"正常", @"不正常",nil]];
    self.textremark.text=@"";
    self.requirementLabel.text=@"";
}
- (IBAction)BtnNewMain:(UIButton *)sender {
    [self BtnSaveMain:nil];
    [self clean];
    
}
@end
