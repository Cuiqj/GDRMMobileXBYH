
//案件信息页面
//  CaseViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "IQKeyboardManager.h"

#import "CaseViewController.h"
#import "CaseServiceFiles.h"
#import "FileCode.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "OrgInfo.h"
#import "Zd.h"
#import "Sfz.h"
#import "Masonry.h"
#import "Times+CoreDataClass.h"
#import <AipOcrSdk/AipOcrSdk.h>
//#import "OrgSyncViewController.m"
#define PHOTO(index) [self cachePhotoForIndex:index]

//载入对应照片，若有多张照片，则显示一个小序列文字标签，并在数秒后消失
#define LOADPHOTOS  if (self.photoArray.count>0) {\
self.labelPhotoIndex.hidden = NO;\
self.labelPhotoIndex.text=[[NSString alloc] initWithFormat:@"%d/%d",self.imageIndex+1,self.photoArray.count];\
self.labelPhotoIndex.alpha  = 1.0;\
}\



#define WIDTH_OFF_SET     654.0
#define HEIGHT_OFF_SET    0
#define SCROLLVIEW_WIDTH  654.0
#define SCROLLVIEW_HEIGHT 580.0


//所有信息子页面名称
//static NSString *infoPageName[5]={@"AccidentBriefInfo",@"CitizenBriefInfo",@"DeformBriefInfo",@"InquireBriefInfo",@"PaintBriefInfo"};

@interface CaseViewController(){
    NSString *currentFileName;
    //弹窗标识，为0弹出天气选择，为1弹出车型选择，为2弹出损坏程度选择
    NSInteger touchedTag;
    NSDate *proveDate;
}
- (void)loadCaseDocList:(NSString *)caseID;
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect;              //1
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect;
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;

//案件照片路径
@property (nonatomic,retain) NSString *photoPath;

//案由数组
@property (nonatomic,retain) NSArray *caseDescArray;
//车辆外观数组
@property (nonatomic,retain) NSArray *carLooksArray;
//已有文书数组
@property (nonatomic,retain) NSArray *docListArray;
@property (nonatomic,retain) NSArray *docTmplArray;
//案件照片数组
@property (nonatomic,retain) NSMutableArray *photoArray;

@property (nonatomic,retain) UIPopoverController *caseInfoPickerpopover;
@property (nonatomic,retain) UIPopoverController *caseListpopover;
//设定文书查看状态，编辑模式或者PDF查看模式
@property (nonatomic,assign) DocPrinterState docPrinterState;

//路段ID
@property (nonatomic,copy) NSString *roadSegmentID;

@property (nonatomic,assign) RoadSegmentPickerState roadSegmentPickerState;

@property (nonatomic,assign) NSInteger   imageIndex;
@property (nonatomic,retain) UIImageView *leftImageView;
@property (nonatomic,retain) UIImageView *midImageView;
@property (nonatomic,retain) UIImageView *rightImageView;
@property  NSInteger Moveinteger;

@end



@implementation CaseViewController
BOOL _wasKeyboardManagerEnabled;
    
@synthesize infoView                = _infoView;
@synthesize caseID                  = _caseID;
@synthesize textCasemark2           = _textCasemark2;
@synthesize textCasemark3           = _textCasemark3;
@synthesize textWeatheer            = _textWeatheer;
@synthesize textSide                = _textSide;
@synthesize textPlace               = _textPlace;
@synthesize textRoadSegment         = _textRoadSegment;
@synthesize textStationStartKM      = _textStationStartKM;
@synthesize textStationStartM       = _textStationStartM;
@synthesize textStationEndKM        = _textStationEndKM;
@synthesize textStationEndM         = _textStationEndM;
@synthesize textHappenDate          = _textHappenDate;
@synthesize textAutoPattern         = _textAutoPattern;
@synthesize textBadDesc             = _textBadDesc;
@synthesize textAutoNumber          = _textAutoNumber;
@synthesize labelPhotoIndex         = _labelPhotoIndex;
@synthesize textCaseDesc            = _textCaseDesc;
@synthesize segInfoPage             = _segInfoPage;
@synthesize uiButtonEdit            = _uiButtonEdit;
@synthesize uiButtonNewCase         = _uiButtonNewCase;
@synthesize uiButtonSave            = _uiButtonSave;
@synthesize uiButtonCamera          = _uiButtonCamera;
@synthesize uiButtonPickFromLibrary = _uiButtonPickFromLibrary;
@synthesize docListView             = _docListView;
@synthesize docTemplatesView        = _docTemplatesView;
@synthesize caseInfo                = _caseInfo;
@synthesize citizenInfo             = _citizenInfo;
@synthesize accInfoBriefVC          = _accInfoBriefVC;
@synthesize citizenInfoBriefVC      = _citizenInfoBriefVC;
@synthesize inquireInfoBriefVC      = _inquireInfoBriefVC;
@synthesize deformInfoVC            = _deformInfoVC;
@synthesize paintBriefVC            = _paintBriefVC;
@synthesize needsMove               = _needsMove;
@synthesize caseListpopover         = _caseListpopover;
@synthesize caseInfoPickerpopover   = _caseInfoPickerpopover;
@synthesize caseDescArray           = _caseDescArray;
@synthesize carLooksArray           = _carLooksArray;
@synthesize docListArray            = _docListArray;
@synthesize docTmplArray            = _docTmplArray;
@synthesize docPrinterState         = _docPrinterState;
@synthesize roadSegmentID           = _roadSegmentID;
@synthesize roadSegmentPickerState  = _roadSegmentPickerState;

@synthesize sfzID         = _sfzID;
@synthesize inspectionID  = _inspectionID;
@synthesize roadInspectVC = _roadInspectVC;

#pragma mark - init
- (NSString *)caseID{
    if (_caseID==nil) {
        _caseID=@"";
    }
    return _caseID;
}
-(NSMutableArray*)times{
    if(_times==nil){
        _times=[NSMutableArray arrayWithCapacity:1];
    }
    return _times;
}
-(NSArray *)caseDescArray{
    if (_caseDescArray==nil) {
        _caseDescArray=[NSArray newCaseDescArray];
    }
    return _caseDescArray;
}
-(NSArray *)carLooksArray{
    if (_carLooksArray==nil) {
        _carLooksArray=[NSArray newCarLookDescArray];
    }
    return _carLooksArray;
}

-(NSArray*)docTmplArray{
    if (_docTmplArray == nil) {
        _docTmplArray = DOC_TEMPLATES_NAME_ARRAY;
    }
    return _docTmplArray;
}

- (NSMutableArray *)photoArray{
    if (_photoArray==nil) {
        _photoArray=[[NSMutableArray alloc] initWithCapacity:1];
    }
    return _photoArray;
}

- (UIImageView *)leftImageView{
    if (_leftImageView==nil) {
        _leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)midImageView{
    if (_midImageView==nil) {
        _midImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _midImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _midImageView;
}

- (UIImageView *)rightImageView{
    if (_rightImageView==nil) {
        _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH*2, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}
- (void)viewDidLoad{
//    [self initWithControl];
    [self.docListView setHidden:YES];
    [[AipOcrService shardService] authWithAK:@"tHCvUMcIvtGzc3S6jPVbDXcv" andSK:@"Cif4vhWMz6s7T2ELVe4tEoEbLKTuQtsG"];
    
    _Moveinteger = 50;
    self.textRoadSegment.font = [UIFont systemFontOfSize:10];
    [super viewDidLoad];
//    [self setUpForDismissKeyboard];
    // Do any additional setup after loading the view.
    
    currentFileName=@"";
    self.caseInfo    = nil;
    self.citizenInfo = nil;
    self.sfzID=@"0";
    proveDate        = nil;
    touchedTag=-1;
    
    FileCode *peiFileCode   = [FileCode fileCodeWithPredicateFormat:@"赔补偿案件编号"];
    NSString *orgNamePrefix = peiFileCode.organization_code;
    NSString *payTypePrefix = @"赔字";
    [self.payLabel setText:[NSString stringWithFormat:@"%@%@",orgNamePrefix,payTypePrefix]];
    UILabel *casemarkPaddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
    [casemarkPaddingView setText:peiFileCode.lochus_code];
    [self.textCasemark3 setLeftView:casemarkPaddingView];
    [self.textCasemark3 setLeftViewMode:UITextFieldViewModeAlways];
    //删除无用的案件数据
    [CaseInfo deleteEmptyCaseInfo];
    
    //界面初始化
    self.labelPhotoIndex.alpha  = 0.0;
    self.labelPhotoIndex.hidden = YES;
    
    UIFont *segFont          = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:segFont
                                                           forKey:UITextAttributeFont];
    [self.segInfoPage setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    self.infoView.layer.cornerRadius  = 4;
    self.infoView.layer.masksToBounds = YES;
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"案件信息-bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底按钮" ofType:@"png"];
    UIImage *btnBlueImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonNewCase setBackgroundImage:btnBlueImage forState:UIControlStateNormal];
    
    //小按钮进入图片缓存，否则在旋转之后，显示将不正常
    UIImage *btnWhiteImage=[[UIImage imageNamed:@"小按钮.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonEdit setBackgroundImage:btnWhiteImage forState:UIControlStateNormal];
    [self.uiButtonEdit setAlpha:0.0];
    [self.uiButtonEdit setHidden:YES];
    
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底主按钮" ofType:@"png"];
    UIImage *btnYelloImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonSave setBackgroundImage:btnYelloImage forState:UIControlStateNormal];
    
    //事故信息页面初始化
    self.accInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AccidentBriefInfo"];
    self.accInfoBriefVC.delegate   = self;
    self.accInfoBriefVC.view.frame = CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
    [self.infoView addSubview:self.accInfoBriefVC.view];
    self.infoView.contentMode   = UIViewContentModeLeft;
    self.infoView.bounces       = NO;
    self.infoView.contentSize   = CGSizeMake(SCROLLVIEW_WIDTH, 580);
    self.infoView.contentInset  = UIEdgeInsetsZero;
    self.infoView.scrollEnabled = YES;
   
//    self.infoView.delegate = self;
    
    //当事人信息页面初始化  案件信息当事人信息页面初始化
    self.citizenInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CitizenBriefInfo"];
    self.citizenInfoBriefVC.delegate   = self;
    self.citizenInfoBriefVC.view.frame = CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, 500.0);
    //勘验草图显示页面初始化
    self.paintBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PaintBriefInfo"];
    self.paintBriefVC.view.frame = CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    
    //询问笔录页面初始化
    self.inquireInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"InquireBriefInfo"];
    self.inquireInfoBriefVC.view.frame = CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
    
    //赔补偿清单页面初始化
    self.deformInfoVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DeformBriefInfo"];
    self.deformInfoVC.delegate   = self;
    self.deformInfoVC.viewLocal  = 0;
    self.deformInfoVC.view.frame = CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
    //默认选中事故信息页面
    self.segInfoPage.selectedSegmentIndex = 0;
    
    [self.uiButtonCamera setHidden:YES];
    [self.uiButtonPickFromLibrary setHidden:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.needsMove = NO;
    
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy"];
    self.textCasemark2.text =[dateformat stringFromDate:newDate];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadFileTableView) name:@"UPDATE_CASE_FILE" object:nil];
    
    [self addGestureRecognizer];
}


-(void)reloadFileTableView{
    [self loadCaseDocList:self.caseID];
}
-(void)viewWillAppear:(BOOL)animated{
    
    /*
     UIButton * aibtn=[UIButton buttonWithType:UIButtonTypeSystem];
     [aibtn setTitle:@"识别" forState:UIControlStateNormal];
     [aibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [aibtn setImage:[UIImage imageNamed:@"识别.png"] forState:UIControlStateNormal];
     [self.view addSubview:aibtn];
     [aibtn mas_makeConstraints:^(MASConstraintMaker *make) {
     make.leading.equalTo(self.uiButtonNewCase);
     make.size.equalTo(self.uiButtonNewCase).width;
     make.bottom.equalTo(self.uiButtonNewCase.mas_bottom);
     make.right.equalTo(self.uiButtonNewCase.mas_left);
     }];
     aibtn.imageView.image = self.uiButtonNewCase.imageView.image;
     
     [aibtn setTitleUnderImage];
     [aibtn setBackgroundColor:[UIColor clearColor]];
     [aibtn addTarget:self action:@selector(aifun:) forControlEvents:UIControlEventTouchUpInside];
     */
}
- (void)viewDidAppear:(BOOL)animated{
  
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];

}
    
- (void)viewWillDisappear:(BOOL)animated{
    //生成巡查记录
    if (self.roadInspectVC && [[self.navigationController visibleViewController] isEqual:self.roadInspectVC]) {
        if (![self.inspectionID isEmpty]) {
            [self.roadInspectVC createRecodeByCaseID:self.caseID];
            [self setInspectionID:nil];
            [self setRoadInspectVC:nil];
        }
    }
    if ([self.caseListpopover isPopoverVisible]) {
        [self.caseListpopover dismissPopoverAnimated:NO];
    }
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}
- (void)viewDidUnload{
    [[self.infoView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setInfoView:nil];
    [self setCaseID:nil];
    [self setTextCasemark2:nil];
    [self setTextCasemark3:nil];
    [self setTextWeatheer:nil];
    [self setTextSide:nil];
    [self setTextPlace:nil];
    [self setTextRoadSegment:nil];
    [self setTextStationStartKM:nil];
    [self setTextStationStartM:nil];
    [self setTextStationEndKM:nil];
    [self setTextStationEndM:nil];
    [self setTextHappenDate:nil];
    [self setTextAutoPattern:nil];
    [self setTextBadDesc:nil];
    [self setTextAutoNumber:nil];
    [self setTextCaseDesc:nil];
    [self setSegInfoPage:nil];
    
    [self setUiButtonEdit:nil];
    [self setUiButtonNewCase:nil];
    [self setUiButtonSave:nil];
    
    [self setCaseInfo:nil];
    [self setCitizenInfo:nil];
    
    [self setAccInfoBriefVC:nil];
    [self setCitizenInfoBriefVC:nil];
    [self setInquireInfoBriefVC:nil];
    [self setDeformInfoVC:nil];
    [self setPaintBriefVC:nil];
    
    [self setRoadSegmentID:nil];
    [self setCaseListpopover:nil];
    [self setCaseInfoPickerpopover:nil];
    [self setCaseDescArray:nil];
    [self setDocListArray:nil];
    [self setDocListView:nil];
    [self setDocTemplatesView:nil];
    [self setUiButtonCamera:nil];
    [self setUiButtonPickFromLibrary:nil];
    [self setLabelPhotoIndex:nil];
    [self setPayLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
-(void)aifun:(UIButton*)btn{
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextBasicFromImage:image withOptions:options successHandler:^(id result) {
            [self ocrOnGeneralSuccessful:result];
        } failHandler:^(NSError *err) {
            [self ocrOnFail:err];
        }];
        
    }];
    vc.modalPresentationStyle                      = UIModalPresentationPopover;
    vc.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;//rect参数是以view的左上角为坐标原点（0，0）
    //箭头方向,如果是baritem不设置方向，会默认up，up的效果也是最理想的
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    vc.popoverPresentationController.delegate                 = self;
    //[self presentViewController:vc animated:YES completion:nil];
    UIViewController *destVC=[AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andDelegate:self];
    //[self presentViewController:destVC animated:YES completion:nil];
    
    
    if([self.caseInfoPickerpopover isPopoverVisible]){
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
        self.caseInfoPickerpopover = nil;
    }else{
        self.caseInfoPickerpopover=[[UIPopoverController alloc]initWithContentViewController:destVC];
        self.caseInfoPickerpopover.delegate = self;
        [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(340, 564)];
        [self.caseInfoPickerpopover presentPopoverFromRect:self.segInfoPage.frame inView:self.view permittedArrowDirections:
         UIPopoverArrowDirectionLeft animated:YES];
    }
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    //no点击蒙版popover不消失， 默认yes
    return NO;
}
- (void)ocrOnGeneralSuccessful:(id)result {
    NSLog(@"%@", result);
    NSMutableString *message = [NSMutableString string];
    if(result[@"words_result"]){
        for(NSDictionary *obj in result[@"words_result"]){
            [message appendFormat:@"%@", obj[@"words"]];
        }
    }else{
        [message appendFormat:@"%@", result];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"识别结果" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        self.citizenInfo.org_name = message;
    }];
}
- (void)ocrOnFail:(NSError *)error {
    NSLog(@"%@", error);
    NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

#pragma aioDelege

#pragma mark - 回收任何空白区域键盘事件
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

#pragma mark - prepare for Segue
//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"toCaseDocument"]){
        CaseDocumentsViewController *documentsVC = segue.destinationViewController;
        documentsVC.fileName                     = currentFileName;
        documentsVC.caseID                       = self.caseID;
        documentsVC.docPrinterState              = self.docPrinterState;
        documentsVC.docReloadDelegate            = self;
    } else if ([segueIdentifier isEqualToString:@"toCitizenListView"]) {
        CitizenListViewController *clVC = segue.destinationViewController;
        clVC.delegate                   = self;
        clVC.caseID                     = self.caseID;
        clVC.citizenListPopover=[(UIStoryboardPopoverSegue *)segue popoverController];
    } else if ([segueIdentifier isEqualToString:@"toCaseDescList"]) {
        CaseDescListViewController *cdlVC = segue.destinationViewController;
        cdlVC.delegate                    = self;
        cdlVC.caseID                      = self.caseID;
        cdlVC.popOver=[(UIStoryboardPopoverSegue *)segue popoverController];
    } else if ([segueIdentifier isEqualToString:@"toDateTimePicker"]) {
        DateSelectController *dsVC = segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate              = self;
        dsVC.pickerType            = 1;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showdate:self.textHappenDate.text];
    } else if ([segueIdentifier isEqualToString:@"toDeformInfoEditor"]) {
        DeformationInfoViewController *diVC = segue.destinationViewController;
        diVC.caseID                         = self.caseID;
    } else if ([segueIdentifier isEqualToString:@"toInquireInfoEditor"]) {
        InquireInfoViewController *iiVC = segue.destinationViewController;
        iiVC.caseID                     = self.caseID;
        iiVC.delegate                   = self;
        iiVC.answererName               = self.inquireInfoBriefVC.textParty.text;
    } else if ([segueIdentifier isEqualToString:@"toPaintEditor"]) {
        CasePaintViewController *cpVC = segue.destinationViewController;
        cpVC.delegate                 = self;
        cpVC.caseID                   = self.caseID;
    }
}


#pragma mark - textField Delegate
//使日期选择框不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==3) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // 车号自动转换大写字母
    if (textField == self.textAutoNumber) {
        textField.text             = [textField.text uppercaseString];
    }else if (textField ==self.textStationStartKM) {
        self.textStationEndKM.text = textField.text;
    }
    else if (textField ==self.textStationStartM) {
        self.textStationEndM.text = textField.text;
    }else if (textField == self.textSide){
        if([self.roadSegmentID isEqualToString:@"666666666"]){
            Sfz *iShoufz = [Sfz aSfzForID:self.sfzID];
            self.textStationStartKM.text=[NSString stringWithFormat:@"%d", iShoufz.station_start.integerValue/1000];
            self.textStationStartM.text=[NSString stringWithFormat:@"%d",iShoufz.station_start.integerValue%1000];
            self.textStationEndKM.text=[NSString stringWithFormat:@"%d",iShoufz.station_end.integerValue/1000];
            self.textStationEndM.text=[NSString stringWithFormat:@"%d",iShoufz.station_end.integerValue%1000];
        }
    }
    return YES;
}

#pragma mark - TableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (tableView.tag==1000) {
        number           = self.docListArray.count;
    } else if (tableView.tag==1001) {
        number           = self.docTmplArray.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag==1001) {
        static NSString *CellIdentifier = @"DocTemplatesCell";
        cell                            = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text             = self.docTmplArray[indexPath.row];
        NSString *name                  = self.docTmplArray[indexPath.row];
        int  a                          = [self.docListArray indexOfObject:name];
        if(self.docListArray.count>0&& a >=0&& a<7){
            cell.accessoryType              = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (tableView.tag==1000) {
        static NSString *CellIdentifier = @"DocListCell";
        cell                            = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text=[self.docListArray objectAtIndex:indexPath.row];
        //        int *a=[self.docTmplArray indexOfObject:[self.docListArray objectAtIndex:indexPath.row]];
        //        if(a>=0){
        //            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        //        } else {
        //            cell.accessoryType=UITableViewCellAccessoryNone;
        //        }
    }
    return cell;
}

//点击进入文书编辑和打印页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self checkCaseBaseInfo] == NO){
        return;
    }
    if (tableView.tag==1001) {
        self.docPrinterState = 1;
    } else if (tableView.tag==1000) {
        self.docPrinterState = kPDFView;
    }
    UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPath];
    currentFileName = myCell.textLabel.text;
    if (![self.caseID isEmpty]) {
        [self saveCaseInfoForCase:self.caseID];
    }
    [self performSegueWithIdentifier:@"toCaseDocument" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - IBActions

//各信息页面切换
- (IBAction)changeInfoPage:(UISegmentedControl *)sender {
    for(UIView *subview in [self.infoView subviews]) {
        [subview removeFromSuperview];
    }
    
    //删除infoView上的所有手势，防止在非照片页面误操作
    for (UIGestureRecognizer *gesture in [self.infoView gestureRecognizers]) {
        [gesture removeTarget:self action:@selector(showDeleteMenu:)];
    }
    
    [self.labelPhotoIndex setAlpha:0.0];
    [self.labelPhotoIndex setHidden:YES];
    if (sender.selectedSegmentIndex!=5) {
        self.infoView.pagingEnabled = NO;
        self.infoView.delegate      = nil;
        if (sender.selectedSegmentIndex==1||sender.selectedSegmentIndex==0) {
            // self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 500.0);
            self.infoView.contentSize   = CGSizeMake(SCROLLVIEW_WIDTH, 500);
            if (sender.selectedSegmentIndex==0){
                self.infoView.contentSize   = CGSizeMake(SCROLLVIEW_WIDTH, 150);
            }
        } else {
            self.infoView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        [self.infoView setContentOffset:CGPointZero animated:NO];
        self.infoView.scrollEnabled = YES;
    } else {
        [self.infoView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
        self.infoView.delegate      = self;
        self.infoView.pagingEnabled = YES;
        self.infoView.contentSize   = CGSizeMake(self.infoView.bounds.size.width*3, self.infoView.bounds.size.height);
        [self.infoView setContentOffset:CGPointMake(self.infoView.bounds.size.width, 0) animated:NO];
    }
    switch (sender.selectedSegmentIndex) {
            //事故信息
        case 0:{
            if (![self.accInfoBriefVC.caseID isEqualToString:self.caseID]) {
                [self.accInfoBriefVC loadDataForCase:self.caseID];
            }
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.accInfoBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //当事人信息
        case 1:{
            if (![self.citizenInfoBriefVC.caseID isEqualToString:self.caseID]  && [self.textAutoNumber.text isEmpty]) {
                [self.citizenInfoBriefVC newDataForCase:self.caseID];
            } else {
                [self.citizenInfoBriefVC loadCitizenInfoForCase:self.caseID autoNumber:self.textAutoNumber.text andNexus:@"当事人"];
            }
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.citizenInfoBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //赔补偿清单
        case 2:{
            self.deformInfoVC.caseID = self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setHidden:NO];
                                [self.uiButtonEdit setAlpha:1.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.deformInfoVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //询问笔录
        case 3:{
            self.inquireInfoBriefVC.caseID = self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setHidden:NO];
                                [self.uiButtonEdit setAlpha:1.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.inquireInfoBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //现场勘验图
        case 4:{
            self.paintBriefVC.caseID = self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setHidden:NO];
                                [self.uiButtonEdit setAlpha:1.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.paintBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //现场照片
        case 5:{
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.infoView addSubview:self.leftImageView];
                                [self.infoView addSubview:self.midImageView];
                                [self.infoView addSubview:self.rightImageView];
                                LOADPHOTOS;
                                self.leftImageView.image  = [self cachePhotoForIndex:self.imageIndex-1];
                                self.midImageView.image   = [self cachePhotoForIndex:self.imageIndex];
                                self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.uiButtonCamera setHidden:NO];
                                [self.uiButtonCamera setAlpha:1.0];
                                [self.uiButtonPickFromLibrary setHidden:NO];
                                [self.uiButtonPickFromLibrary setAlpha:1.0];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteMenu:)];
                                [self.infoView addGestureRecognizer:longPressGesture];
                            }];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        }
            break;
        default:
            break;
    }
}


//显示各信息详细编辑页面按钮
- (IBAction)btnClickToEditor:(id)sender {
    [[AppDelegate App]saveContext];
    switch ([self.segInfoPage selectedSegmentIndex]) {
        case 2:
            [self performSegueWithIdentifier:@"toDeformInfoEditor" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"toInquireInfoEditor" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"toPaintEditor" sender:self];
        default:
            break;
    }
}

//新增案件按钮
- (IBAction)btnNewCase:(id)sender{
    self.SwitchNumber.on = YES;
    self.caseInfo      = nil;
    self.citizenInfo   = nil;
    self.caseDescArray = nil;
    [self.photoArray removeAllObjects];
    self.roadSegmentID=@"";
    self.caseInfo=[CaseInfo newDataObjectWithEntityName:@"CaseInfo"];
    self.caseInfo.case_type_id = CaseTypeIDDefault;
    NSString *caseIDString     = self.caseInfo.myid;
    self.caseID                = caseIDString;
    
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text=@"";
        }
    }
    
    proveDate=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateString=[dateFormatter stringFromDate:proveDate];
    NSString *yearString=[dateString substringToIndex:4];
    self.textCasemark2.text  = yearString;
    self.textHappenDate.text = dateString;
    
    NSInteger caseMark3InCoreData = [CaseInfo maxCaseMark3];
    NSInteger caseMark3InDefaults=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark3"].integerValue;
    NSString *caseMark3           = [[NSString alloc] initWithFormat:@"%d",MAX(caseMark3InDefaults, caseMark3InCoreData)+1];
    NSString *oldCaseMark2=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark2"];
    if (yearString.integerValue>oldCaseMark2.integerValue) {
        caseMark3=@"1";
        [[NSUserDefaults standardUserDefaults] setObject:yearString forKey:@"CaseMark2"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:yearString forKey:@"CaseMark2"];
    [[NSUserDefaults standardUserDefaults] setObject:caseMark3 forKey:@"CaseMark3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.textCasemark3.text = caseMark3;
    
    [self.accInfoBriefVC newDataForCase:caseIDString];
    [self.citizenInfoBriefVC newDataForCase:caseIDString];
    [self.inquireInfoBriefVC newDataForCase:caseIDString];
    [self.paintBriefVC.Image setImage:nil];
    
    [self.segInfoPage setSelectedSegmentIndex:0];
    [self changeInfoPage:self.segInfoPage];
    
    _docListArray = [NSArray array];
    [_docListView beginUpdates];
    [_docListView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [_docListView insertSections:[NSIndexSet indexSetWithIndex:0]  withRowAnimation:UITableViewRowAnimationFade];
    [_docListView endUpdates];
    
    [self.textStationStartKM setEnabled:YES];
    [self.textStationStartM setEnabled:YES];
    [self.textStationEndKM setEnabled:YES];
    [self.textStationEndM setEnabled:YES];
    [self.textStationEndM setBackgroundColor:[UIColor whiteColor]];
    [self.textStationEndKM setBackgroundColor:[UIColor whiteColor]];
    [self.textStationStartM setBackgroundColor:[UIColor whiteColor]];
    [self.textStationStartKM setBackgroundColor:[UIColor whiteColor]];
}

//弹出以往案件选择框
- (IBAction)btnPreviousCase:(id)sender {
    if ([self.caseListpopover isPopoverVisible]) {
        [self.caseListpopover dismissPopoverAnimated:YES];
    } else {
        CaseListViewController *caseListVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseListView"];
        caseListVC.caseType  = CaseTypeIDDefault;
        self.caseListpopover=[[UIPopoverController alloc] initWithContentViewController:caseListVC];
        caseListVC.delegate  = self;
        caseListVC.myPopover = self.caseListpopover;
        [self.caseListpopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)SwitchOnOrOff:(id)sender {
    if(self.SwitchNumber.on){
        [self.textStationStartKM setEnabled:YES];
        [self.textStationStartM setEnabled:YES];
        [self.textStationEndKM setEnabled:YES];
        [self.textStationEndM setEnabled:YES];
        [self.textStationEndM setBackgroundColor:[UIColor whiteColor]];
        [self.textStationEndKM setBackgroundColor:[UIColor whiteColor]];
        [self.textStationStartM setBackgroundColor:[UIColor whiteColor]];
        [self.textStationStartKM setBackgroundColor:[UIColor whiteColor]];
    }else{
        self.textStationEndM.text = @"";
        self.textStationEndKM.text = @"";
        self.textStationStartM.text = @"";
        self.textStationStartKM.text = @"";
        [self.textStationStartKM setEnabled:NO];
        [self.textStationStartM setEnabled:NO];
        [self.textStationEndKM setEnabled:NO];
        [self.textStationEndM setEnabled:NO];
        [self.textStationEndM setBackgroundColor:[UIColor lightGrayColor]];
        [self.textStationEndKM setBackgroundColor:[UIColor lightGrayColor]];
        [self.textStationStartM setBackgroundColor:[UIColor lightGrayColor]];
        [self.textStationStartKM setBackgroundColor:[UIColor lightGrayColor]];
    }
}

//弹窗
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect{
    if ((iIndex==touchedTag) && ([self.caseInfoPickerpopover isPopoverVisible])) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        touchedTag          = iIndex;
        CaseInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseInfoPicker"];
        acPicker.pickerType = iIndex;
        acPicker.delegate   = self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        switch (iIndex) {
            case 0:{    //天气
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(140, 264)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 140, 264)];
            }
                break;
            case 1:{ //车型
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(170,308)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 170, 308)];
            }
                break;
            case 2:{    //损坏程度
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(100, 176)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 100, 176)];
            }
                break;
            default:
                break;
        }
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover = self.caseInfoPickerpopover;
    }
}


//弹出天气选择框
- (IBAction)selectWeather:(id)sender {
    [self pickerPresentForIndex:0 fromRect:[(UITextField*)sender frame]];
}



//弹出车辆类型选择框
- (IBAction)selectAutoMobilePattern:(id)sender {
    [self pickerPresentForIndex:1 fromRect:[(UITextField*)sender frame]];
}

//弹出损坏程度选择框
- (IBAction)selectBadDesc:(id)sender {
    [self pickerPresentForIndex:2 fromRect:[(UITextField*)sender frame]];
}

//弹出车号选择框
- (IBAction)selectCitizen:(id)sender {
    if (![self.caseID isEmpty]) {
        [self performSegueWithIdentifier:@"toCitizenListView" sender:self];
    }
}
//弹出案由选择
- (IBAction)selectCaseDesc:(id)sender {
    [self performSegueWithIdentifier:@"toCaseDescList" sender:self];
}

//时间选择
- (IBAction)selectDateAndTime:(id)sender {
    [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
}

//保存案件信息按钮
- (IBAction)btnSaveCaseInfo:(id)sender {
    
    if([self checkCaseBaseInfo] == NO){
        return;
    }
    
    if (![self.textCasemark2.text isEmpty] && ![self.textCasemark3.text isEmpty]) {
        if ([self.caseID isEmpty]) {
            //            NSString *caseIDString=[NSString randomID];
            //            self.caseID=caseIDString;
            //            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            //            NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInfo" inManagedObjectContext:context];
            self.caseInfo=[CaseInfo newDataObjectWithEntityName:@"CaseInfo"];
            self.caseID = self.caseInfo.myid;
            Times *atime=[Times newDataObjectWithEntityName:@"Times"];
            [atime setValue:@"jiebaoTime" forKey:@"name"];
            [atime setValue:self.caseInfo.myid forKey:@"parent_id"];
            [self.times addObject:atime];
            atime=[Times newDataObjectWithEntityName:@"Times"];
            [atime setValue:@"daochangTime" forKey:@"name"];
            [atime setValue:self.caseInfo.myid forKey:@"parent_id"];
            [self.times addObject:atime];
            atime=[Times newDataObjectWithEntityName:@"Times"];
            [atime setValue:@"tuocheTime" forKey:@"name"];
            [atime setValue:self.caseInfo.myid forKey:@"parent_id"];
            [self.times addObject:atime];
            atime=[Times newDataObjectWithEntityName:@"Times"];
            [atime setValue:@"jiaojingTime" forKey:@"name"];
            [atime setValue:self.caseInfo.myid forKey:@"parent_id"];
            [self.times addObject:atime];
            atime=[Times newDataObjectWithEntityName:@"Times"];
            [atime setValue:@"overTime" forKey:@"name"];
            [atime setValue:self.caseInfo.myid forKey:@"parent_id"];
            [self.times addObject:atime];
        }
        [self saveCaseInfoForCase:self.caseID];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCaseID" object:self userInfo:[NSDictionary dictionaryWithObject:self.caseID forKey:@"caseID"]];
    }
}

//选择路段级路段号
- (IBAction)selectRoadSegmet:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:sender.frame];
}

//选择方向
- (IBAction)selectRoadSide:(UITextField *)sender {
    if([self.roadSegmentID isEqualToString:@"666666666"]){
        [self roadSegmentPickerPresentPickerState:kShoufz fromRect:sender.frame];
    }else{
        [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:sender.frame];
    }
}

//选择位置
- (IBAction)selectRoadPlace:(UITextField *)sender {
    if([self.roadSegmentID isEqualToString:@"666666666"]){
        [self roadSegmentPickerPresentPickerState:kZadao fromRect:sender.frame];
    }else{
        [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:sender.frame];
    }
}

//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.roadSegmentPickerState) && ([self.caseInfoPickerpopover isPopoverVisible])) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        self.roadSegmentPickerState = state;
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame    = CGRectMake(0, 0, 200, 250);
        icPicker.pickerState        = state;
        icPicker.delegate           = self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(200, 250)];
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover = self.caseInfoPickerpopover;
    }
}

#pragma mark - CaseID Handler Delegate
//新打印文档后，重新载入文书列表
- (void)reloadDocuments{
    [self loadCaseDocList:self.caseID];
}

- (void)loadInquireForAnswerer:(NSString *)answererName{
    [self.inquireInfoBriefVC loadInquireInfoForCase:self.caseID andAnswererName:answererName];
}

//显示所选天气
- (void)setWeather:(NSString *)textWeather{
    self.textWeatheer.text = textWeather;
}

//显示所选车型
- (void)setAuotMobilePattern:(NSString *)textPattern{
    self.textAutoPattern.text = textPattern;
}

//显示所选损坏程度
- (void)setBadDesc:(NSString *)textBadDesc{
    self.textBadDesc.text = textBadDesc;
}

//显示所选车号，并载入相关车辆信息
- (void)setAutoNumber:(NSString *)textAutoNumber{
    [self loadCitizenInfoForCase:self.caseID andAutoNumber:textAutoNumber];
}

//删除车辆信息时清空
- (void)clearAutoInfo{
    self.textAutoNumber.text=@"";
    self.textAutoPattern.text=@"";
    self.textBadDesc.text=@"";
    self.citizenInfo = nil;
    [self.citizenInfoBriefVC newDataForCase:self.caseID];
}

//已立案件delegate，以设定所选案件的caseID，并载入相关数据，并切换到事故信息页面
- (void)setCaseIDdelegate:(NSString *)caseID{
    
    //FIXME lxm 2013.05.09 不需要再保存一次
    //    if (![self.caseID isEmpty]) {
    //        [self btnSaveCaseInfo:nil];
    //    }
    
    if (![self.caseID isEmpty]) {
        [self btnSaveCaseInfo:nil];
    }
    [self loadCaseInfoForCase:caseID];
    if (self.segInfoPage.selectedSegmentIndex!=0) {
        for (UIView *view in self.infoView.subviews) {
            [view removeFromSuperview];
        }
        [self.labelPhotoIndex setAlpha:0.0];
        [self.labelPhotoIndex setHidden:YES];
        self.infoView.pagingEnabled = NO;
        self.infoView.delegate      = nil;
        self.infoView.contentSize   = CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        [self.infoView setContentOffset:CGPointZero animated:NO];
        [UIView transitionWithView:self.infoView duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.uiButtonEdit setAlpha:0.0];
                            [self.infoView addSubview:self.accInfoBriefVC.view];
                            if (!self.uiButtonCamera.hidden) {
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                            }
                        }
                        completion:^(BOOL finished){
                            [self.uiButtonEdit setHidden:YES];
                            [self.uiButtonPickFromLibrary setHidden:YES];
                            [self.uiButtonCamera setHidden:YES];
                        }];
        [self.segInfoPage setSelectedSegmentIndex:0];
    }
}

- (void)setCaseIDdelegate2:(NSString *)caseID{
    [self loadCaseInfoForCase:caseID];
    if (self.segInfoPage.selectedSegmentIndex!=0) {
        for (UIView *view in self.infoView.subviews) {
            [view removeFromSuperview];
        }
        [self.labelPhotoIndex setAlpha:0.0];
        [self.labelPhotoIndex setHidden:YES];
        self.infoView.pagingEnabled = NO;
        self.infoView.delegate      = nil;
        self.infoView.contentSize   = CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        [self.infoView setContentOffset:CGPointZero animated:NO];
        [UIView transitionWithView:self.infoView duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.uiButtonEdit setAlpha:0.0];
                            [self.infoView addSubview:self.accInfoBriefVC.view];
                            if (!self.uiButtonCamera.hidden) {
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                            }
                        }
                        completion:^(BOOL finished){
                            [self.uiButtonEdit setHidden:YES];
                            [self.uiButtonPickFromLibrary setHidden:YES];
                            [self.uiButtonCamera setHidden:YES];
                        }];
        [self.segInfoPage setSelectedSegmentIndex:0];
    }
}

//显示所选时间
- (void)setDate:(NSString *)date{
    self.textHappenDate.text = date;
}

//为其他ViewController返回当前caseID
- (NSString *)getCaseIDdelegate{
    return self.caseID;
}

//返回当前选定的案由
- (NSArray *)getCaseDescArrayDelegate{
    return self.caseDescArray;
}

//返回当前选定车号
- (NSString *)getAutoNumberDelegate{
    if (self.textAutoNumber.text != nil) {
        return self.textAutoNumber.text;
    } else {
        return @"";
    }
}

//设定案由
- (void)setCaseDescArrayDelegate:(NSArray *)aCaseDescArray{
    self.caseDescArray = aCaseDescArray;
    NSString *caseFullDesc=@"";
    for (CaseDescString *temp in aCaseDescArray) {
        if (temp.isSelected) {
            if ([caseFullDesc isEmpty]) {
                caseFullDesc=[caseFullDesc stringByAppendingString:temp.caseDesc];
            } else {
                caseFullDesc=[caseFullDesc stringByAppendingFormat:@"，%@",temp.caseDesc];
            }
        }
    }
    self.textCaseDesc.text = caseFullDesc;
}

//根据caseID删除以往案件
- (void)deleteCaseAllDataForCase:(NSString *)caseID{
    if ([self.caseID isEqualToString:caseID]) {
        self.caseID=@"";
        self.roadSegmentID=@"";
        for (UITextField *text in [self.view subviews]) {
            if ([text isKindOfClass:[UITextField class]]) {
                text.text=@"";
            }
        }
        [self.accInfoBriefVC newDataForCase:@""];
        [self.citizenInfoBriefVC newDataForCase:@""];
        self.caseInfo      = nil;
        self.caseDescArray = nil;
        self.citizenInfo   = nil;
    }
    [self deleteDataForEntityName:@"CaseProveInfo" andCaseID:caseID];
    [self deleteDataForEntityName:@"Citizen" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseDeformation" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseInquire" andCaseID:caseID];
    [CaseInfo deleteCaseInfoForID:caseID];
    [self deleteDataForEntityName:@"ParkingNode" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseDocuments" andCaseID:caseID];
    [self deleteDataForEntityName:@"CasePhoto" andCaseID:caseID];
}

//根据案号删除对应表数据
- (void)deleteDataForEntityName:(NSString *)aEntiyName andCaseID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:aEntiyName inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate;
    if ([aEntiyName isEqualToString:@"Citizen"] || [aEntiyName isEqualToString:@"CaseDeformation"] || [aEntiyName isEqualToString:@"CaseInquire"]) {
        predicate=[NSPredicate predicateWithFormat:@"proveinfo_id == %@",caseID];
    }else if ([aEntiyName isEqualToString:@"CasePhoto"] ) {
        predicate=[NSPredicate predicateWithFormat:@"project_id == %@",caseID];
    } else {
        predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    }
    [fetchRequest setPredicate:predicate];
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        for (NSManagedObject *tableInfo in fetchResult) {
            [context deleteObject:tableInfo];
        }
    }
    [[AppDelegate App] saveContext];
}

#pragma mark - RoadPickerDelegate
- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
    self.roadSegmentID        = aRoadSegmentID;
    self.textRoadSegment.text = roadName;
}
-(NSArray*) getZadao{
    NSArray *data =[Zd ZdByShoufzID:self.sfzID];
    return data;
}
- (void)setRoadPlace:(NSString *)place{
    self.textPlace.text = place;
}

- (void)setRoadSide:(NSString *)side{
    self.sfzID=@"0";
    self.textSide.text = side;
}
- (void)setShoufz:(NSString*) sfzname sfzID:(NSString*)sfzID{
    self.sfzID                   = sfzID;
    Sfz *iShoufz                 = [Sfz aSfzForID:self.sfzID];
    self.textStationStartKM.text=[NSString stringWithFormat:@"%d", iShoufz.station_start.integerValue/1000];
    self.textStationStartM.text=[NSString stringWithFormat:@"%d",iShoufz.station_start.integerValue%1000];
    self.textStationEndKM.text=[NSString stringWithFormat:@"%d",iShoufz.station_end.integerValue/1000];
    self.textStationEndM.text=[NSString stringWithFormat:@"%d",iShoufz.station_end.integerValue%1000];
    self.caseInfo.roadsegment_id = iShoufz.roadsegment_id;
    self.textSide.text = sfzname;
}

#pragma mark - ReloadPaintDelegate
- (void)reloadPaint{
    if (self.segInfoPage.selectedSegmentIndex == 4) {
        [self.paintBriefVC loadCasePaint];
    }
}
////结束滑动调用
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"%@",scrollView.contentOffset);
//}

#pragma mark - keyboard show&hide events
//左下输入框delegate，设定scrollview需要上移
- (void)scrollViewNeedsMove{
    self.needsMove = YES;

}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.needsMove) {
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x,302,self.infoView.frame.size.width,self.infoView.frame.size.height)];
        if (self.segInfoPage.selectedSegmentIndex==1) {
            self.infoView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH, 500);
        } else {
            self.infoView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        [self.view bringSubviewToFront:self.infoView];
        [UIView commitAnimations];
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.needsMove) {
        self.navigationController.navigationBarHidden = NO;
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x,18,self.infoView.frame.size.width,self.infoView.frame.size.height)];
        CGSize tempSize;
        if (self.segInfoPage.selectedSegmentIndex==1) {
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, 500);
        } else {
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        tempSize=CGSizeMake(tempSize.width, keyboardEndFrame.size.width - (704 - 18 - self.infoView.frame.size.height) + tempSize.height);
        self.infoView.contentSize=tempSize;
        [self.view bringSubviewToFront:self.infoView];
        [UIView commitAnimations];
    }
}

//左上普通文本框点击时，scrollview不移动
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.needsMove = NO;
}


#pragma mark - methods save&load
//根据caseID载入相应案件数据
- (void)loadCaseInfoForCase:(NSString *)caseID{
    self.caseInfo = nil;
    self.caseID   = caseID;
    self.caseInfo = [CaseInfo caseInfoForID:caseID];
    if (self.caseInfo) {
        NSLog(@"%@",_caseInfo);
        self.textCasemark2.text = self.caseInfo.case_mark2;     //2018
        self.textCasemark3.text = self.caseInfo.case_mark3;      //23
        self.textWeatheer.text  = self.caseInfo.weater;         //阴
        if(self.caseInfo.sfz_id.integerValue!=0){
            self.textRoadSegment.text=@"收费站";
            self.roadSegmentID=@"666666666";
        }else{          //路段问题载入
            self.textRoadSegment.text=[RoadSegment roadNameAndroadFromSegment:self.caseInfo.roadsegment_id];//
            self.roadSegmentID = self.caseInfo.roadsegment_id;   //（国家高速）G4W   32284
        }
        self.sfzID          = self.caseInfo.sfz_id;     //0
        self.textPlace.text = self.caseInfo.place;      //右侧
        self.textSide.text  = self.caseInfo.side;       //往东
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textHappenDate.text=[formatter stringFromDate:self.caseInfo.happen_date];  //2018-05-31 11:05
        self.textStationStartKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];          //123
        self.textStationStartM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000]; //234
        self.textStationEndKM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];       //123
        self.textStationEndM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue%1000];       //234
        if ([self.caseInfo.station_start integerValue] == 0 && [self.caseInfo.station_end integerValue] == 0) {
            self.textStationEndM.text = @"";
            self.textStationEndKM.text = @"";
            self.textStationStartM.text = @"";
            self.textStationStartKM.text = @"";
            [self.textStationStartKM setEnabled:NO];
            [self.textStationStartM setEnabled:NO];
            [self.textStationEndKM setEnabled:NO];
            [self.textStationEndM setEnabled:NO];
            [self.textStationEndM setBackgroundColor:[UIColor lightGrayColor]];
            [self.textStationEndKM setBackgroundColor:[UIColor lightGrayColor]];
            [self.textStationStartM setBackgroundColor:[UIColor lightGrayColor]];
            [self.textStationStartKM setBackgroundColor:[UIColor lightGrayColor]];
            self.SwitchNumber.on =NO;
        }else{
            self.SwitchNumber.on = YES;
            [self.textStationStartKM setEnabled:YES];
            [self.textStationStartM setEnabled:YES];
            [self.textStationEndKM setEnabled:YES];
            [self.textStationEndM setEnabled:YES];
            [self.textStationEndM setBackgroundColor:[UIColor whiteColor]];
            [self.textStationEndKM setBackgroundColor:[UIColor whiteColor]];
            [self.textStationStartM setBackgroundColor:[UIColor whiteColor]];
            [self.textStationStartKM setBackgroundColor:[UIColor whiteColor]];
        }
    }
    [self loadCitizenInfoForCase:caseID andAutoNumber:@""];   //当事人信息和案件信息
    [self loadCaseProveInfoForCase:caseID];                     //勘验信息
    [self loadCaseDocList:caseID];                              ////载入案件已生成文书信息
    [self loadCasePhotoForCase:caseID];                         //载入案件对应的照片
    [self.accInfoBriefVC loadDataForCase:caseID];           //下面事故信息有着落了
/**
    *textCasemark2;
    *textCasemark3;
    *textWeatheer;
    *textSide;
    *textPlace;
    *textRoadSegment;
    *textStationStartKM
    *textStationStartM;
    *textStationEndKM;
    *textStationEndM;
    *textHappenDate;
    *textAutoPattern;
    *textBadDesc;
*textAutoNumber;
 */
}

//将当前页面显示数据保存至该caseID下
- (void)saveCaseInfoForCase:(NSString *)caseID{
    self.caseInfo.myid = caseID;
    //extern NSString *my_org_id;
    
    OrgInfo *selectedorg          = [OrgInfo orgInfoForSelected];
    self.caseInfo.organization_id = selectedorg.myid;
    self.caseInfo.case_type_id    = CaseTypeIDDefault;
    // self.caseInfo.peccancy_type=self.textRoadSegment.text;
    self.caseInfo.case_mark2      = self.textCasemark2.text;
    self.caseInfo.case_mark3      = self.textCasemark3.text;
    self.caseInfo.weater          = self.textWeatheer.text;
    self.caseInfo.side            = self.textSide.text;
    self.caseInfo.place           = self.textPlace.text;
    if([self.sfzID isEqualToString:@"0"])
        self.caseInfo.roadsegment_id = self.roadSegmentID ;
    else{
        Sfz *iShoufz                 = [Sfz aSfzForID:self.sfzID];
        self.caseInfo.roadsegment_id = iShoufz.roadsegment_id;
    }
    self.caseInfo.sfz_id      = self.sfzID;
    self.caseInfo.station_start=[NSNumber numberWithInteger:(self.textStationStartKM.text.integerValue*1000+self.textStationStartM.text.integerValue)];
    self.caseInfo.station_end=[NSNumber numberWithInteger:(self.textStationEndKM.text.integerValue*1000+self.textStationEndM.text.integerValue)];
    if (self.caseInfo.station_end.integerValue == 0) {
        self.caseInfo.station_end = [self.caseInfo.station_start copy];
    }
    self.textStationStartKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
    self.textStationStartM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000];
    self.textStationEndKM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];
    self.textStationEndM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue%1000];
    if([self.caseInfo.station_start integerValue] == 0 && [self.caseInfo.station_end integerValue] == 0){
        self.textStationStartKM.text = @"";
        self.textStationStartM.text = @"";
        self.textStationEndKM.text = @"";
        self.textStationEndM.text = @"";
    }
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (![self.textHappenDate.text isEmpty]) {
        self.caseInfo.happen_date=[formatter dateFromString:self.textHappenDate.text];
    }else{
        self.caseInfo.happen_date = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
        self.textHappenDate.text=[formatter stringFromDate:self.caseInfo.happen_date];
    }
    //    self.caseInfo.happen_date =
    NSLog(@"保存时间 == %@", self.caseInfo.happen_date);
    
    [[AppDelegate App] saveContext];
    
    [self saveCaseProveInfoForCase:caseID];
    [self saveCitizenInfoForCase:caseID andAutoNumber:self.textAutoNumber.text];
    switch (self.segInfoPage.selectedSegmentIndex) {
        case 0:
            [self.accInfoBriefVC saveDataForCase:caseID];
            break;
        case 1:
            [self.citizenInfoBriefVC saveCitizenInfoForCase:caseID];
            break;
        default:
            break;
    }
}






- (void)saveCaseProveInfoForCase:(NSString *)caseID{
    CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    if (!caseProveInfo) {
        caseProveInfo=[CaseProveInfo newDataObjectWithEntityName:@"CaseProveInfo"];
        caseProveInfo.caseinfo_id = caseID;
        if (proveDate == nil) {
            proveDate                 = [NSDate date];
        }
        caseProveInfo.start_date_time = proveDate;
    }
    
    NSString *caseDescID=@"";
    for (CaseDescString *temp in self.caseDescArray) {
        if (temp.isSelected) {
            if ([caseDescID isEmpty]) {
                caseDescID=[caseDescID stringByAppendingString:temp.caseDescID];
            } else {
                caseDescID=[caseDescID stringByAppendingFormat:@"#%@",temp.caseDescID];
            }
        }
    }
    caseProveInfo.case_desc_id = caseDescID;
    
    //add by lxm 2013.05.09
    //生成案号
    //caseProveInfo.case_mark2 = self.textCasemark2.text;
    //caseProveInfo.case_mark3 = self.textCasemark3.text;
    
    caseProveInfo.case_short_desc = self.textCaseDesc.text;
    //拼接事故详情
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",[CaseProveInfo generateEventDescForCase:caseID]];
    
    if (str==nil) {
        NSRange range = [str rangeOfString:@"损坏公路路产"];
        [str replaceCharactersInRange:range withString:self.textCaseDesc.text];
        caseProveInfo.event_desc = str;
    }
    //拼接事故详细
    //    caseProveInfo.event_desc=[CaseDescString stringByAppendingFormat:@"   %@于%@驾驶%@%@行至%@%@%@在公路%@由于%@发生交通事故损坏公路路产，%@，经与当事人现场勘查，",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString,caseInfo.place,caseInfo.case_reason,caseStatusString];
    
    //add by lxm 2013.05.03
    //在案件编辑页面传入参数
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    caseProveInfo.start_date_time=[formatter dateFromString:self.textHappenDate.text];
    if (caseProveInfo.end_date_time == nil) {
        caseProveInfo.end_date_time=[formatter dateFromString:self.textHappenDate.text];
    }
    NSNumber *station_start=[NSNumber numberWithInteger:(self.textStationStartKM.text.integerValue*1000+self.textStationStartM.text.integerValue)];
    NSNumber *station_end=[NSNumber numberWithInteger:(self.textStationEndKM.text.integerValue*1000+self.textStationEndM.text.integerValue)];
    NSString * stationString=@"";
    if ([self.caseInfo.station_end integerValue] == 0 && [self.caseInfo.station_start integerValue] == 0) {
        stationString = @"";
    } else if(station_start.integerValue == 0 || station_start.integerValue == station_end.integerValue){
        stationString=[NSString stringWithFormat:@"K%02d+%03d米",self.textStationStartKM.text.integerValue,self.textStationStartM.text.integerValue];
    } else{
        stationString=[NSString stringWithFormat:@"K%02d+%03d米至K%02d+%03d米",self.textStationStartKM.text.integerValue,self.textStationStartM.text.integerValue,self.textStationEndKM.text.integerValue,self.textStationEndM.text.integerValue];
    }
    //以前的勘验场所描述
    //caseProveInfo.remark = [NSString stringWithFormat:@"%@%@%@",self.textRoadSegment.text,self.textSide.text,self.textPlace.text];
    //现在的勘验场所描述
    if(self.sfzID.integerValue>0)
        caseProveInfo.remark = [NSString stringWithFormat:@"%@%@%@",[RoadSegment roadNameFromSegment:self.caseInfo.roadsegment_id],self.textSide.text,self.textPlace.text];
    else
        caseProveInfo.remark = [NSString stringWithFormat:@"%@%@%@%@",[RoadSegment roadNameFromSegment:self.caseInfo.roadsegment_id],self.textSide.text,stationString,self.textPlace.text];
    
    
    // 对案件文书打印初始化数据未完
    //FIXME 勘验人员的名字、单位职务获取？
    //caseProveInfo.prover1 = self;
    //caseProveInfo.prover1_org_duty = self;
    //caseProveInfo.prover2 = self ;
    //caseProveInfo.prover2_org_duty = self;
    
    //根据不同的nexus来获取名字、单位和职务
    Citizen *citizen1=[Citizen citizenForName:self.textAutoNumber.text nexus:@"当事人" case:caseID];
    caseProveInfo.citizen_name = citizen1.party;
    
    //caseProveInfo.citizen_org_duty = [NSString stringWithFormat:@"%@%@",[citizen1.org_name length]==0?@"":citizen1.org_name, [citizen1.org_principal_duty length]==0?@"":citizen1.org_principal_duty];
    
    Citizen *citizen2=[Citizen citizenForName:self.textAutoNumber.text nexus:@"当事人代表" case:caseID];
    if (citizen2) {
        caseProveInfo.organizer          = citizen2.party;
        caseProveInfo.organizer_org_duty = [NSString stringWithFormat:@"%@%@",[citizen2.org_name length]==0?@"":citizen2.org_name, [citizen2.org_principal_duty length]==0?@"":citizen2.org_principal_duty];
    }
    
    Citizen *citizen3=[Citizen citizenForName:self.textAutoNumber.text nexus:@"被邀请人" case:caseID];
    if(citizen3){
        caseProveInfo.invitee          = citizen3.party;
        caseProveInfo.invitee_org_duty = [NSString stringWithFormat:@"%@%@",[citizen3.org_name length]==0?@"":citizen3.org_name, [citizen3.org_principal_duty length]==0?@"":citizen3.org_principal_duty];
    }
    
    //FIXME 记录者的名字、单位职务获取？
    //caseProveInfo.recorder = self.;
    //caseProveInfo.recorder_org_duty = self;
    
    [[AppDelegate App] saveContext];
}


//根据caseID载入勘验信息
- (void)loadCaseProveInfoForCase:(NSString *)caseID{
    CaseProveInfo *info = [CaseProveInfo proveInfoForCase:caseID];
    if (info) {
        if ([info.case_short_desc containsString:@"交通事故造成"]) {
            info.case_short_desc = [info.case_short_desc stringByReplacingOccurrencesOfString:@"交通事故造成" withString:@""];
        }
        self.textCaseDesc.text = info.case_short_desc;
        for (CaseDescString *caseDescString in self.caseDescArray) {
            caseDescString.isSelected = NO;
        }
        NSString *temp = info.case_desc_id;
        if (![temp isEmpty]) {
            NSArray *descIDArray=[temp componentsSeparatedByString:@"#"];
            for (NSString *descID in descIDArray) {
                for (CaseDescString *caseDesc in self.caseDescArray) {
                    if ([descID isEqualToString:caseDesc.caseDescID]) {
                        caseDesc.isSelected = YES;
                    }
                }
            }
        }
    }
}

//根据案件号和车牌号载入车辆及车主信息
- (void)loadCitizenInfoForCase:(NSString *)caseID andAutoNumber:(NSString *)aAutoNumber{
    self.citizenInfo = nil;
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    if ([aAutoNumber isEmpty]) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id == %@",caseID];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id == %@) AND (automobile_number == %@)",caseID,aAutoNumber];
        [fetchRequest setPredicate:predicate];
    }
    NSError *error = nil;
    NSMutableArray *fetchResult=[[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (fetchResult.count>0) {
        self.citizenInfo=[fetchResult objectAtIndex:0];
        self.textBadDesc.text     = self.citizenInfo.bad_desc;
        self.textAutoNumber.text  = self.citizenInfo.automobile_number;
        self.textAutoPattern.text = self.citizenInfo.automobile_pattern;
        if (self.segInfoPage.selectedSegmentIndex==1) {
            //modify by 李晓明 不需要再保存一次 2013.05.09
            //[self.citizenInfoBriefVC saveCitizenInfoForCase:caseID];
            
            [self.citizenInfoBriefVC loadCitizenInfoForCase:caseID autoNumber:aAutoNumber andNexus:@"当事人"];
        }
    } else {
        self.textBadDesc.text=@"";
        self.textAutoNumber.text=@"";
        self.textAutoPattern.text=@"";
    }
}

//保存车辆及车主信息；
- (void)saveCitizenInfoForCase:(NSString *)caseID andAutoNumber:(NSString *)aAutoNumber{
    aAutoNumber=[aAutoNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.textAutoNumber.text = aAutoNumber;
    if (![aAutoNumber isEmpty] && aAutoNumber != nil) {
        if (!self.citizenInfo) {
            self.citizenInfo=[Citizen newDataObjectWithEntityName:@"Citizen"];
            self.citizenInfo.nexus=@"当事人";
        }
        self.citizenInfo.proveinfo_id       = caseID;
        self.citizenInfo.automobile_pattern = self.textAutoPattern.text;
        NSString *autoNumberNew             = self.textAutoNumber.text.uppercaseString;
        self.citizenInfo.automobile_number  = autoNumberNew;
        if ([autoNumberNew length]>1) {
            NSString *provinceNew=[autoNumberNew substringToIndex:1];
            NSString *cityCodeNew=[autoNumberNew substringWithRange:NSMakeRange(1, 1)];
            NSString *autoNumberOriginal = self.citizenInfo.automobile_number;
            NSString *provinceOriginal=[autoNumberOriginal substringToIndex:1];
            NSString *cityCodeOriginal=[autoNumberOriginal substringWithRange:NSMakeRange(1, 1)];
            
            if ((![provinceNew isEqualToString:provinceOriginal]) || (![cityCodeNew isEqualToString:cityCodeOriginal])) {
                self.citizenInfo.automobile_address=[self.citizenInfo.automobile_number autoAddressFromAutoNumber];
            }
        }
        self.citizenInfo.bad_desc = self.textBadDesc.text;
        [[AppDelegate App] saveContext];
    }
}

//载入案件已生成文书信息
- (void)loadCaseDocList:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",self.caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    self.docListArray=[temp valueForKeyPath:@"@distinctUnionOfObjects.document_name"];
    [self.docListView reloadData];
    [self.docTemplatesView reloadData];
}

//载入案件对应的照片
- (void)loadCasePhotoForCase:(NSString *)caseID{
    [self.photoArray removeAllObjects];
    NSArray *tempArray=[CasePhoto casePhotosForCase:caseID];
    self.photoArray=[(NSArray *)[tempArray valueForKeyPath:@"photo_name"] mutableCopy];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[pathArray objectAtIndex:0];
    NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",caseID];
    self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
    self.imageIndex    = 0;
}


#pragma mark - Photo
- (IBAction)btnImageFromCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
    }
}

- (IBAction)btnImageFromLibrary:(id)sender {
    [self pickPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)pickPhoto:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate                                               = self;
    picker.sourceType                                             = sourceType;
    picker.modalPresentationStyle                                 = UIModalPresentationFullScreen;;
    picker.preferredContentSize                                   = CGSizeMake(200, 300);
    picker.popoverPresentationController.sourceView               = self.uiButtonCamera;
    CGRect infoCenter                                             = CGRectMake(self.infoView.center.x-5, self.infoView.center.y-5, 10, 10);
    //picker.popoverPresentationController.sourceRect = infoCenter;
    picker.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;

    // 箭头方向
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self presentModalViewController:picker animated:YES];
    } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.caseInfoPickerpopover   = popover;
        CGRect infoCenter            = CGRectMake(self.infoView.center.x-5, self.infoView.center.y-5, 10, 10);
        [self.caseInfoPickerpopover presentPopoverFromRect:infoCenter  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}
#pragma uipop代理


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (![self.caseID isEmpty]) {
        dispatch_queue_t myqueue = dispatch_queue_create("PhotoSave", nil);
        dispatch_async(myqueue, ^(void){
            UIImage *photo=[info objectForKey:UIImagePickerControllerOriginalImage];
            if ([self.photoPath isEmpty] || self.photoPath == nil) {
                NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentPath=[pathArray objectAtIndex:0];
                NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",self.caseID];
                self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:self.photoPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:self.photoPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *photoName;
            if (self.photoArray.count==0) {
                photoName=@"1.jpg";
            } else {
                NSInteger photoNumber=[[self.photoArray valueForKeyPath:@"@max.integerValue"] integerValue]+1;
                photoName=[[NSString alloc] initWithFormat:@"%d.jpg",photoNumber];
            }
            NSString *filePath=[self.photoPath stringByAppendingPathComponent:photoName];
            NSData *photoData = UIImageJPEGRepresentation(photo, 0.8);
            if ([photoData writeToFile:filePath atomically:YES]) {
                CasePhoto *newPhoto=[CasePhoto newDataObjectWithEntityName:@"CasePhoto"];
                newPhoto.project_id = self.caseID;
                newPhoto.photo_name = photoName;
                [[AppDelegate App] saveContext];
                [self.photoArray insertObject:photoName atIndex:self.imageIndex];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    LOADPHOTOS;
                    self.leftImageView.image  = [self cachePhotoForIndex:self.imageIndex-1];
                    self.midImageView.image   = [self cachePhotoForIndex:self.imageIndex];
                    self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
                });
            }
        });
        //dispatch_release(myqueue);
    }
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

//显示删除标签
- (void)showDeleteMenu:(UILongPressGestureRecognizer *)gestureRecognizer{
    // 案件中图片的   删除标签
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.photoArray.count > 0) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            UIMenuItem *deleteMenuItem       = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deletePiece:)];
            UIMenuItem *saveMenuItem       = [[UIMenuItem alloc] initWithTitle:@"保存图片" action:@selector(savePiece:)];
            [self becomeFirstResponder];
            [menuController setMenuItems:@[deleteMenuItem,saveMenuItem]];
//            [menuController setMenuItems:@[saveMenuItem]];
            [menuController setTargetRect:CGRectMake(self.infoView.frame.origin.x + SCROLLVIEW_WIDTH/2, self.infoView.frame.origin.y + SCROLLVIEW_HEIGHT/2, 0, 0) inView:self.view];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}
//保存案件的图片到相册       保存到相册 
- (void)savePiece:(UIMenuController *)controller{
    UIImage * saveimage = [self cachePhotoForIndex:self.imageIndex];
    UIImageWriteToSavedPhotosAlbum(saveimage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
//#pragma mark 系统的完成保存图片的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = nil ;
    if (error != NULL) {
        msg = @"失败" ;
    } else {
        msg = @"成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片到相册" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//删除对应照片
- (void)deletePiece:(UIMenuController *)controller{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (!caseInfo.isuploaded.boolValue) {
        NSString *photoName = [self.photoArray objectAtIndex:self.imageIndex];
        [CasePhoto deletePhotoForCase:self.caseID photoName:photoName];
        NSString *photoPath = [self.photoPath stringByAppendingPathComponent:photoName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
        }
        [self.photoArray removeObjectAtIndex:self.imageIndex];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            LOADPHOTOS;
            self.leftImageView.image  = [self cachePhotoForIndex:self.imageIndex-1];
            self.midImageView.image   = [self cachePhotoForIndex:self.imageIndex];
            self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        });
    }
}

- (UIImage *)cachePhotoForIndex:(NSInteger)index{
    if (self.photoArray.count>0) {
        NSString *photoPath;
        if (index<0) {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray lastObject]];
        } else if (index>(self.photoArray.count-1)) {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray objectAtIndex:0]];
        } else {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray objectAtIndex:index]];
        }
        
        UIImage *image             = [[UIImage alloc] initWithContentsOfFile:photoPath];
        CGImageRef imageRef        = [image CGImage];
        CGRect rect                = CGRectMake(0.f, 0.f, SCROLLVIEW_HEIGHT/3*4, SCROLLVIEW_HEIGHT);
        CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                           rect.size.width,
                                                           rect.size.height,
                                                           CGImageGetBitsPerComponent(imageRef),
                                                           CGImageGetBytesPerRow(imageRef),
                                                           CGImageGetColorSpace(imageRef),
                                                           kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
                                                           );
        
        CGContextDrawImage(bitmapContext, rect, imageRef);
        CGImageRef compressedImageRef = CGBitmapContextCreateImage(bitmapContext);
        UIImage* compressedImage      = [[UIImage alloc] initWithCGImage: compressedImageRef];
        CGImageRelease(compressedImageRef);
        CGContextRelease(bitmapContext);
        return compressedImage;
    } else {
        return nil;
    }
}


#pragma mark -UIScrollViewDelegate

#define SET_FRAME(IMAGE) x = IMAGE.frame.origin.x + increase;\
if(x < 0) x                = pageWidth * 2;\
if(x > pageWidth * 2) x    = 0.0f;\
[IMAGE setFrame:CGRectMake(x, \
IMAGE.frame.origin.y,\
IMAGE.frame.size.width,\
IMAGE.frame.size.height)]
//将三个view都向右移动，并更新三个指针的指向
- (void)allImagesMoveRight:(CGFloat)pageWidth {
    //上一篇
    self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex - 1];
    
    float increase = pageWidth;
    CGFloat x      = 0.0f;
    SET_FRAME(self.rightImageView);
    SET_FRAME(self.leftImageView);
    SET_FRAME(self.midImageView);
    
    UIImageView *tempView = self.rightImageView;
    self.rightImageView   = self.midImageView;
    self.midImageView     = self.leftImageView;
    self.leftImageView    = tempView;
}

- (void)allImagesMoveLeft:(CGFloat)pageWidth {
    self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex + 1];
    
    float increase = -pageWidth;
    CGFloat x      = 0.0f;
    SET_FRAME(self.midImageView);
    SET_FRAME(self.rightImageView);
    SET_FRAME(self.leftImageView);
    
    UIImageView *tempView = self.leftImageView;
    self.leftImageView    = self.midImageView;
    self.midImageView     = self.rightImageView;
    self.rightImageView   = tempView;
}


//实现照片的循环和载入
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.infoView]) {
        CGFloat pageWidth = WIDTH_OFF_SET;
        // 0 1 2
        int page = floor((self.infoView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(page == 1) {
            //用户拖动了，但是滚动事件没有生效
        } else if (page == 0) {
            [self allImagesMoveRight:pageWidth];
            self.imageIndex--;
        } else {
            [self allImagesMoveLeft:pageWidth];
            self.imageIndex++;
        }
        if (self.imageIndex<0) {
            self.imageIndex = self.photoArray.count-1;
        } else if (self.imageIndex>(self.photoArray.count-1)) {
            self.imageIndex = 0;
        }
        [UIView transitionWithView:self.infoView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            LOADPHOTOS;
                        }
                        completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        [scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
        self.leftImageView.image  = [self cachePhotoForIndex:self.imageIndex - 1];
        self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex + 1];
    }
}

//照片序号标签的消失动画
- (void)hideLabelWithAnimation {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         [self.labelPhotoIndex setAlpha:0.0];
                     }
                     completion:^(BOOL finished){ self.labelPhotoIndex.hidden = YES;}];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

//检查案件基本信息是否为空
-(BOOL)checkCaseBaseInfo{
    NSString * message = nil;
    //检查案号
    if([_textCasemark2.text isEmpty] || [_textCasemark3.text isEmpty]){
        message = @"请填写完整案号信息";
    }else if([_textHappenDate.text isEmpty]){
        message = @"请选择时间";
    }else if([_textRoadSegment.text isEmpty] ){
        message = @"请选择高速公路";
    }else if([_textAutoNumber.text isEmpty]){
        message = @"请填写车号";
    }else if([_textCaseDesc.text isEmpty]){
        message = @"请选择案由";
    }
    
    if(message != nil){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return NO;
    }
    return  YES;
}
- (void)sideclickAction{
    //方向及收费站
    [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:self.textSide.frame];
}
- (void)placeclickAction{
    //行车道及左右侧等等
    [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:self.textPlace.frame];
}
- (void)sideLongPress{
    [self.textSide becomeFirstResponder];
}
- (void)placeLongPress{
    [self.textPlace becomeFirstResponder];
}
//添加手势
- (void)addGestureRecognizer{
    UITapGestureRecognizer *sideclick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sideclickAction)];
    UILongPressGestureRecognizer * sidelongPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(sideLongPress)];
    sidelongPressGesture.minimumPressDuration= 0.5f;
    CGRect sideframe = self.textSide.frame;
    UIView * sideview = [[UIView alloc] initWithFrame:sideframe];
    sideview.tag = 1111;
    [self.view addSubview:sideview];
    //    sideview.backgroundColor = [UIColor blackColor];
    [sideview addGestureRecognizer:sideclick];
    [sideview addGestureRecognizer:sidelongPressGesture];
    UITapGestureRecognizer *placeclick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeclickAction)];
    UILongPressGestureRecognizer * placelongPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(placeLongPress)];
    placelongPressGesture.minimumPressDuration=0.5f;
    CGRect placeframe = self.textPlace.frame;
    UIView * placeview = [[UIView alloc] initWithFrame:placeframe];
    [self.view addSubview:placeview];
    placeview.tag = 1112;
    [placeview addGestureRecognizer:placeclick];
    [placeview addGestureRecognizer:placelongPressGesture];
}

@end
