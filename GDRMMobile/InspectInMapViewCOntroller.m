#import "InspectInMapViewCOntroller.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import <Masonry.h>
@interface InspectInMapViewCOntroller ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic,strong) BMKMapView *mapView;//地图视图
@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property(nonatomic,strong) BMKUserLocation *userLocation;
@end

@implementation InspectInMapViewCOntroller

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化地图
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate =self;
    //设置地图的显示样式
    self.mapView.mapType = 1;//卫星地图
    
    //设定地图是否打开路况图层
    self.mapView.trafficEnabled = YES;
    
    //底图poi标注
    self.mapView.showMapPoi = YES;
    
    //在手机上当前可使用的级别为3-21级
    self.mapView.zoomLevel = 10;
    
    //设定地图View能否支持旋转
    self.mapView.rotateEnabled = YES;
    _mapView.baiduHeatMapEnabled=YES;
    _mapView.trafficEnabled=YES;
    //设定地图View能否支持用户移动地图
    self.mapView.scrollEnabled = YES;
    _mapView.forceTouchEnabled=YES;
    //添加到view上
    [self.view addSubview:self.mapView];
    NSArray * names=@[@"无",@"标准",@"卫星",@"3D"];
    UISegmentedControl *seg=[[UISegmentedControl alloc]initWithItems:names];
    [seg addTarget:self action:@selector(segChanged:) forControlEvents:UIControlEventValueChanged];
    seg.frame=CGRectMake(20, 100, 300, 40);
    seg.selectedSegmentIndex=1;
    [_mapView addSubview:seg];
    [seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mapView);
        make.top.mas_equalTo(50);
        make.width.mas_equalTo(_mapView.frame.size.width/2);
    }];
    self.service=[[BMKLocationService alloc]init];
    _service.delegate=self;
    [_service startUserLocationService];
    UIButton *locatButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [locatButton setTitle:@"定位" forState:UIControlStateNormal];
    [ locatButton addTarget:self action:@selector(btnLocat:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locatButton];
    
    [locatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.left.mas_equalTo(50);
       // make.bottom.equalTo(_mapView).width-30;
        make.bottom.equalTo(_mapView).with.offset(-200);
    }];
    [locatButton.layer setMasksToBounds:YES];
    [locatButton.layer setCornerRadius:50.0]; //设置矩形四个圆角半径
    [locatButton.layer setBorderWidth:11.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [locatButton.layer setBorderColor:colorref];//边框颜色
    locatButton.backgroundColor = [UIColor whiteColor];
    
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.915, 116.404);
    annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    //还有很多属性,根据需求查看API
}
/**
 *3DTouch 按地图时会回调此接口（仅在支持3D Touch，且fouchTouchEnabled属性为YES时，会回调此接口）
 *@param mapview 地图View
 *@param coordinate 触摸点的经纬度
 *@param force 触摸该点的力度(参考UITouch的force属性)
 *@param maximumPossibleForce 当前输入机制下的最大可能力度(参考UITouch的maximumPossibleForce属性)
 */
- (void)mapview:(BMKMapView *)mapView onForceTouch:(CLLocationCoordinate2D)coordinate force:(CGFloat)force maximumPossibleForce:(CGFloat)maximumPossibleForce{
    NSLog(@"经纬度：%f,%f :力度 %f 到 %f",coordinate.latitude,coordinate.longitude,force,maximumPossibleForce);
}
-(void)btnLocat:(UIButton*)btn{
    [UIView animateWithDuration:2 animations:^(){
        //更新位置数据
        [self.mapView updateLocationData:_userLocation  ];
        //[_mapView setCenterCoordinate:_userLocation.location animated:YES];
        //获取用户的坐标
        self.mapView.centerCoordinate = _userLocation.location.coordinate;
        //NSLog( [NSString stringWithFormat:@"%@,%@",_userLocation.location.coordinate.latitude,_userLocation.location.coordinate.latitude get] );
        NSLog(@"当前方向： %@",_userLocation.heading);
        NSLog(@"当前经纬度： lat %f,long %f",_userLocation.location.coordinate.latitude,_userLocation.location.coordinate.longitude);
        self.mapView.zoomLevel =18;
        
        
    }];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    _userLocation=userLocation;
    //展示定位
    self.mapView.showsUserLocation = YES;
    
    //更新位置数据
    [self.mapView updateLocationData:userLocation];
    
    //获取用户的坐标
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    self.mapView.zoomLevel =18;
    
}

-(void) segChanged:(UISegmentedControl*)seg{
    _mapView.mapType=seg.selectedSegmentIndex;
}
@end