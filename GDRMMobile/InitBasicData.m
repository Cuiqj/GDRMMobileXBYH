//
//  InitBasicData.m
//  GDRMXBYHMobile
//
//  Created by admin on 2017/12/8.
//
//

#import "InitBasicData.h"
#import "AlertViewWithProgressbar.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "MJExtension.h"
static NSString *dataNameArray[34]={@"Project",@"Task",@"AtonementNotice",@"CaseDeformation",@"CaseInfo",@"CaseInquire",@"CaseProveInfo",@"CaseServiceFiles",@"CaseServiceReceipt",@"Citizen",@"RoadWayClosed",@"Inspection",@"InspectionCheck",@"InspectionOutCheck",@"InspectionPath",@"InspectionRecord",@"ParkingNode",@"CaseMap",@"ConstructionChangeBack",@"TrafficRecord",@"InspectionConstruction",@"CasePhoto",@"MaintainPlanCheck",@"RectificationNotice",@"StopNotice",@"RoadWayClosed",@"CaseLawInfo",@"ServiceCheck",@"ServiceCheckDetail",@"HelpWork",@"CarCheckRecords",@"CheckInstitutions",@"RoadAsset_Check_Main",@"RoadAsset_Check_detail"};
@interface InitBasicData()
@property (nonatomic,retain) AlertViewWithProgressbar *progressView;
@property (nonatomic,assign) NSInteger                parserCount;
@property (nonatomic,assign) NSInteger                currentParserCount;
@end
@implementation InitBasicData

-(void)start{
    self.progressView=[[AlertViewWithProgressbar alloc] initWithTitle:@"同步基础数据" message:@"正在下载，请稍候……" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [self.progressView show];
    [self.progressView setProgress:0];
    NSMutableDictionary  *param = @{@"Command":@"GetItems", @"sql":@"select * from userinfo"};
    // 创建请求类
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    
    for(int i = 0;i<34;i++){
        //[param setObject:[NSString stringWithFormat:@"select * from %@",dataNameArray[i]] forKey:@"sql"];
        
        NSMutableDictionary  *param = @{@"Command":@"GetItems", @"sql":[NSString stringWithFormat:@"select * from %@",dataNameArray[i]]};
        [manager GET:@"http://124.172.189.177:81/xbyh/Framework/DataBase.ashx" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            // 这里可以获取到目前数据请求的进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功
            if(responseObject){
                [self.progressView setProgress:(int)((float)((i+1)/34)*100)];
                
                NSString * name = responseObject[0][@"name"];
                NSLog(@"名字：%@",name);
                /*
                 NSManagedObjectContext *context=[[AppDelegate sharedApp] managedObjectContext];
                 NSEntityDescription *entity=[NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
                 UserInfo *auser=[[UserInfo alloc ] initWithEntity:entity insertIntoManagedObjectContext:context];
                 auser.username = name;
                 */
                NSArray* users=[ NSClassFromString(dataNameArray[i] ) mj_objectArrayWithKeyValuesArray:responseObject context:context];
                [[AppDelegate App] saveContext];
                //success(dict,YES);
            } else {
                //success(@{@"msg":@"暂无数据"}, NO);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            //fail(error);
        }];
    }
    [manager GET:@"http://124.172.189.177:81/xbyh/Framework/DataBase.ashx" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            
            NSString * name = responseObject[0][@"name"];
            NSLog(@"名字：%@",name);
            /*
             NSManagedObjectContext *context=[[AppDelegate sharedApp] managedObjectContext];
             NSEntityDescription *entity=[NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
             UserInfo *auser=[[UserInfo alloc ] initWithEntity:entity insertIntoManagedObjectContext:context];
             auser.username = name;
             */
            NSArray* users=[UserInfo mj_objectArrayWithKeyValuesArray:responseObject context:context];
            [[AppDelegate App] saveContext];
            //success(dict,YES);
        } else {
            //success(@{@"msg":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        //fail(error);
    }];
}
@end
