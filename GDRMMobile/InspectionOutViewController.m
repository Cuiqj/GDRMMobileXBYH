//
//  InspectionOutViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-13.
//
//{540,620}

#import "InspectionOutViewController.h"
#import "InspectionPath.h"
#import "Global.h"
#import  "ListSelectViewController.h"
#import "Systype.h"

#import "RoadSegmentPickerViewController.h"

@interface InspectionOutViewController ()
@property (nonatomic,retain) NSArray             *itemArray;
@property (nonatomic,retain) NSArray             *detailArray;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
- (NSString *)resultTextFromPickerView:(UIPickerView *)pickerView selectedRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@implementation InspectionOutViewController
@synthesize itemArray;
@synthesize detailArray;
@synthesize inputView;
@synthesize tableCheckItems;
@synthesize pickerCheckItemDetails;
@synthesize textDetail;
@synthesize textDeliver;
@synthesize textEndDate;
@synthesize textMile;
@synthesize pickerPopover;
@synthesize delegate;

- (void)awakeFromNib{
    [super awakeFromNib];
    self.preferredContentSize = CGSizeMake(540.0, 620.0);
}

- (void)viewDidLoad
{
    NSArray *checkItems=[CheckItems allCheckItemsForType:2];
    NSMutableArray *tempMutableArray=[[NSMutableArray alloc] initWithCapacity:checkItems.count];
    for (CheckItems *checkItem in checkItems) {
        TempCheckItem *tempItem=[[TempCheckItem alloc] init];
        tempItem.checkText   = checkItem.checktext;
        tempItem.remarkText  = checkItem.remark;
        tempItem.checkResult = checkItem.remark;
        tempItem.itemID      = checkItem.myid;
        [tempMutableArray addObject:tempItem];
    }
    self.itemArray=[NSArray arrayWithArray:tempMutableArray];
    [super viewDidLoad];
    
    [self.textroad addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view.
//    [self addGestureRecognizer];//给路段添加长按手势
    self.textroad.placeholder = @"";
    [self createUIforstoryboard];
}
- (void)createUIforstoryboard{
    [self.Labelroadsegment setHidden:YES];
    [self.roadsegmentText setHidden:YES];
    self.Labeltime.frame = CGRectMake(20, self.roadsegmentText.frame.origin.y, 42, self.Labeltime.frame.size.height);
    self.textEndDate.frame = CGRectMake(60, self.roadsegmentText.frame.origin.y, self.textEndDate.frame.size.width, self.textEndDate.frame.size.height);
    self.LabelMile.frame = CGRectMake(250, self.roadsegmentText.frame.origin.y, 60, self.LabelMile.frame.size.height);
    self.textMile.frame = CGRectMake(290, self.roadsegmentText.frame.origin.y, 80, self.textMile.frame.size.height);
}
- (void)viewDidUnload
{
    [self setTextDeliver:nil];
    [self setTextEndDate:nil];
    [self setTextMile:nil];
    [self setItemArray:nil];
    [self setDetailArray:nil];
    [self setPickerPopover:nil];
    [self setInputView:nil];
    [self setTableCheckItems:nil];
    [self setPickerCheckItemDetails:nil];
    [self setTextDetail:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer=@"CheckItemCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    id obj=[self.itemArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[obj checkText];
    cell.detailTextLabel.text=[obj remarkText];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *checkItemID=[[self.itemArray objectAtIndex:indexPath.row] valueForKey:@"itemID"];
    self.detailArray=[CheckItemDetails detailsForItem:checkItemID];
    if ([self.inputView isHidden]) {
        [UIView beginAnimations:@"inputViewShow" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        [self.inputView setHidden:NO];
        [self.inputView setAlpha:1.0];
        [self.view bringSubviewToFront:self.inputView];
        CGFloat height      = self.inputView.frame.origin.y-self.tableCheckItems.frame.origin.y-5;
        CGRect newRect      = self.tableCheckItems.frame;
        newRect.size.height = height;
        [self.tableCheckItems setFrame:newRect];
        [UIView commitAnimations];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    self.textDetail.text=[tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
    [self.pickerCheckItemDetails reloadAllComponents];
    //[self.pickerCheckItemDetails selectRow:0 inComponent:0 animated:NO];
    //self.textDetail.text=[self resultTextFromPickerView:self.pickerCheckItemDetails selectedRow:0 inComponent:0];
}

#pragma mark - pickerview delegate & datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.detailArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id obj=[self.detailArray objectAtIndex:row];
    return [obj caption];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.textDetail.text=[self resultTextFromPickerView:pickerView selectedRow:row inComponent:component];
}

#pragma mark - IBActions
- (IBAction)btnCancel:(UIBarButtonItem *)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnSave:(UIBarButtonItem *)sender {
    BOOL isBlank = NO;
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if ([textField.text isEmpty]) {
                isBlank = YES;
            }
            if (textField == self.roadsegmentText) {
                isBlank = NO;
            }
        }
    }
    if (!isBlank) {
        NSString * inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
        NSArray * temp=[Inspection inspectionForID:inspectionID];
        if (temp.count>0) {
            Inspection *inspection=[temp objectAtIndex:0];
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [formatter setLocale:[NSLocale currentLocale]];
            //[formatter setTimeZone:[NSTimeZone systemTimeZone]];
            inspection.time_end=[formatter dateFromString:self.textEndDate.text];
            if (!inspection.yjsj) {
                inspection.yjsj = [Inspection inspectionfortime_endsettingtimeyjsj:inspection.time_end andtime_start:inspection.time_start andclasse:inspection.classe];
                inspection.time_end = inspection.yjsj;
                //如果是机动班或其他班不改变 巡查开始时间
                if ([inspection.classe isEqualToString:@"早班"] || [inspection.classe isEqualToString:@"中班"] || [inspection.classe isEqualToString:@"晚班"]){
                    inspection.time_start =[NSDate dateWithTimeInterval:-8*60*60 sinceDate:inspection.time_end];
                }else{
                    
                }
                
//                inspection.yjsj = inspection.time_end;
            }
            inspection.inspection_milimetres=@(self.textMile.text.floatValue);
            inspection.isdeliver=@(YES);
            inspection.delivertext = self.textDeliver.text;
            NSString *description=@"";
            NSArray *recordArray=[InspectionRecord recordsForInspection:inspectionID];
            for (int i  = 0; i<recordArray.count; i++) {
                InspectionRecord *record=[recordArray objectAtIndex:i];
                //description=[description stringByAppendingFormat:@"（%d）%@\r\n",i+1,record.remark];
                description=[description stringByAppendingFormat:@"%@\n", record.remark];
            }
            inspection.inspection_description = description;
            NSString *pathString              = @"";
            NSArray *pathArray                = [InspectionPath pathsForInspection:inspectionID];
            for (InspectionPath *path in pathArray) {
                if ([pathString isEmpty]) {
                    pathString = path.stationname;
                } else {
                    pathString = [pathString stringByAppendingFormat:@"--%@",path.stationname];
                }
            }
            if (![pathString isEmpty]) {
                pathString = [[NSString alloc] initWithFormat:@"，途经：%@",pathString];
            }
            [formatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
            pathString                  = [[NSString alloc] initWithFormat:@"%@出发%@，%@结束巡查",[formatter stringFromDate:inspection.time_start],pathString,[formatter stringFromDate:inspection.time_end]];
            inspection.inspection_place = pathString;
            inspection.inspection_place = [NSString stringWithFormat:@"%@",self.textroad.text];
            [[AppDelegate App] saveContext];
        }
        for (TempCheckItem *checkItem in self.itemArray) {
            InspectionOutCheck *outCheck=[InspectionOutCheck newDataObjectWithEntityName:@"InspectionOutCheck"];
            outCheck.inspectionid = inspectionID;
            outCheck.checktext    = checkItem.checkText;
            outCheck.remark       = checkItem.remarkText;
            outCheck.checkresult  = checkItem.checkResult;
            [[AppDelegate App] saveContext];
        }
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:INSPECTIONKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate popBackToMainView];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)SelectroadsegmentnameClick:(id)sender {
    [self roadSegmentPickerfromRect:self.roadsegmentText.frame];
}
- (void)roadSegmentPickerfromRect:(CGRect)rect{
    RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
    icPicker.tableView.frame    = CGRectMake(0, 0, 200, 250);
    icPicker.pickerState        = 0;
    icPicker.delegate           = self;
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
    [self.pickerPopover setPopoverContentSize:CGSizeMake(200, 250)];
    [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    icPicker.pickerPopover = self.pickerPopover;
}
- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
//    self.roadSegmentID        = aRoadSegmentID;
    NSArray * array = [RoadSegment allRoadSegmentsForCaseView];
    for(int i = 0 ; i < [array count]; i++){
        @try {
            NSString * name = [array[i] objectForKey:@"name"];
            if ([name isEqualToString:@"收费站"]) {
                return;
            }
            //执行的代码，如果异常,就会抛出，程序不继续执行啦
        } @catch (NSException *exception) {
            //                                捕获异常
            NSLog(@"error");
        } @finally {
            //这里一定执行，无论你异常与否
        }
        
        RoadSegment *  obj = (RoadSegment *)array[i];
        if ([obj.myid isEqualToString:aRoadSegmentID]) {
            self.roadsegmentText.text = obj.place_prefix1;
            return;
        }
    }
//    self.roadsegmentText.text = roadName;
}

- (IBAction)btnOK:(UIBarButtonItem *)sender {
    NSIndexPath *index=[self.tableCheckItems indexPathForSelectedRow];
    TempCheckItem *item=[self.itemArray objectAtIndex:index.row];
    item.remarkText = self.textDetail.text;
    [self.tableCheckItems beginUpdates];
    [self.tableCheckItems reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableCheckItems endUpdates];
    [self.tableCheckItems selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self.inputView setAlpha:0.0];
                        [self.view sendSubviewToBack:self.inputView];
                        CGRect newRect      = self.tableCheckItems.frame;
                        newRect.size.height = 440;
                        [self.tableCheckItems setFrame:newRect];
                    }
                    completion:^(BOOL finished){
                        [self.inputView setHidden:YES];
                    }];
}

- (IBAction)textTouch:(UITextField *)sender {
    //时间选择
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        if([sender isEqual: self.textEndDate]){
            DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
            datePicker.delegate   = self;
            datePicker.pickerType = 1;
            [datePicker showdate:self.textEndDate.text];
            self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
            [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            datePicker.dateselectPopover = self.pickerPopover;
        }
        else if ([sender isEqual: self.textroad]){
            ListSelectViewController *listselectPop=[[ListSelectViewController alloc] init];
            NSMutableArray * nsmuarray = [[Systype typeValueForCodeName:@"巡查日常路线"] mutableCopy];
//            if ([self InspectionPathStationRoadline].length >0) {
//                 [nsmuarray addObject:[self InspectionPathStationRoadline]];
//            }
             listselectPop.data = [NSArray arrayWithArray:nsmuarray];
//            listselectPop.preferredContentSize = CGSizeMake(250, 320);
            listselectPop.delegate = self;
            CGRect frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width-200, sender.frame.size.height);
            self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:listselectPop];
            [self.pickerPopover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            listselectPop.pickerPopover = self.pickerPopover;
            
        }
    }
}

- (void)setSelectData:(NSString *)data{
    //巡查路线
    self.textroad.text = data;
}
- (NSString *)resultTextFromPickerView:(UIPickerView *)pickerView selectedRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *resultText=[pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component];
    if (resultText.integerValue>0) {
        NSString *temp  = self.textDetail.text;
        NSCharacterSet *leftCharSet=[NSCharacterSet characterSetWithCharactersInString:@"（("];
        NSRange range=[temp rangeOfCharacterFromSet:leftCharSet options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            NSInteger index = range.location+1;
            NSString *header=[temp substringToIndex:index];
            NSCharacterSet *rightCharSet=[NSCharacterSet characterSetWithCharactersInString:@")）"];
            range=[temp rangeOfCharacterFromSet:rightCharSet];
            NSString *tail;
            if (range.location != NSNotFound) {
                tail=[temp substringFromIndex:range.location];
            } else {
                tail=[temp substringFromIndex:index];
            }
            resultText=[NSString stringWithFormat:@"%@%d%@",header,resultText.integerValue,tail];
        }
    }
    return resultText;
}


- (void)setDate:(NSString *)date{
    self.textEndDate.text = date;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

//给路线添加长按手势
- (void)addGestureRecognizer{
    UITapGestureRecognizer * sideclick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sideclickAction)];
    UILongPressGestureRecognizer * sidelongPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(sideLongPress)];
    sidelongPressGesture.minimumPressDuration= 0.5f;
//    CGRect sideframe = self.textroad.frame;
//    UIView * sideview = [[UIView alloc] initWithFrame:sideframe];
//    sideview.tag = 1111;
//    [self.view addSubview:sideview];
    //    sideview.backgroundColor = [UIColor blackColor];
    [self.textroad addGestureRecognizer:sideclick];
    [self.textroad addGestureRecognizer:sidelongPressGesture];
    UITapGestureRecognizer * roadsegmentnameClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roadsegmentnameClickAction)];
    CGRect roadsegmentnameframe = self.roadsegmentText.frame;
    UIView * roadsegmentview = [[UIView alloc] initWithFrame:roadsegmentnameframe];
    [self.view addSubview:roadsegmentview];
    [roadsegmentview addGestureRecognizer:roadsegmentnameClick];
}
- (void)roadsegmentnameClickAction{
    [self SelectroadsegmentnameClick:self.roadsegmentText];
}
- (void)sideclickAction{
    if (![self.textroad isFirstResponder]) {
        [self textTouch:self.textroad];
    }
}

- (void)sideLongPress{
    [self.textroad becomeFirstResponder];
}

@end
