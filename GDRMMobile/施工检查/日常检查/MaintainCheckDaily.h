//
//  MaintainCheckDaily.h
//  YUNWUMobile
//
//  Created by admin on 2018/11/2.
//

#import <CoreData/CoreData.h>

@interface MaintainCheckDaily : NSManagedObject
//主键id
@property (nonatomic,retain) NSString *myid;
//受检单位
@property (nonatomic,strong) NSString * org;
//施工现场负责人及电话
@property (nonatomic,strong) NSString * tel;
//检查时间
@property (nonatomic,strong) NSDate * date;
//方向
@property (nonatomic,strong) NSString * direction;
//施工单位
@property (nonatomic,strong) NSString * constr_org;
//检查桩号
@property (nonatomic,strong) NSString * check_station;
//施工证号
@property (nonatomic,strong) NSString * project_code;
//施工性质
@property (nonatomic,strong) NSString * constr_nature;
//施工区域
@property (nonatomic,strong) NSString * constr_are;
//施工内容;
@property (nonatomic,strong) NSString * constr_content;
//施工人员是否穿着安全标志服  0为否  1为是
@property (nonatomic,strong) NSNumber * person_saft_mark;
//作业区长度是否符合要求
@property (nonatomic,strong) NSNumber * work_length_require;
//施工车辆是否开启危险警示灯
@property (nonatomic,strong) NSNumber * constr_car_light;
//(夜间)是否布设照明设备和警示频闪灯
@property (nonatomic,strong) NSNumber * night_light;
//是否开具《施工整改通知书》
@property (nonatomic,strong) NSNumber * notice;
//办理施工审批
@property (nonatomic,strong) NSNumber * approval;
//交通锥摆放是否规范
@property (nonatomic,strong) NSNumber * traffic_cone;
//标志牌布设是否规范
@property (nonatomic,strong) NSNumber * sign_lay;
//施工材料堆放是否规范
@property (nonatomic,strong) NSNumber * material_stack;
//是否配备安全管理员
@property (nonatomic,strong) NSNumber * have_safe_person;
//施工区域是否渠化
@property (nonatomic,strong) NSNumber * canalization;
//是否配合路政现场监督检查
@property (nonatomic,strong) NSNumber * have_supervise;
//是否有其他违规行为
@property (nonatomic,strong) NSNumber * have_against;
//检查小结
@property (nonatomic,strong) NSString * summary;
//检查人员
@property (nonatomic,strong) NSString * inspector;
//关联施工项目主表
@property (nonatomic,strong) NSString * maintain_plan_id;

@property (nonatomic,retain) NSNumber * isuploaded;


+(NSArray *)allMaintainCheckDailyforMaintain_planid:(NSString *)planID;
+(MaintainCheckDaily *)maintainCheckDailyForMyid:(NSString *)myid;


    
  
@end
