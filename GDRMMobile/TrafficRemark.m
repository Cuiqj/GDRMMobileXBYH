//
//  Remark.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/7/5.
//

#import "TrafficRemark.h"

@implementation TrafficRemark

+ (void)createTrafficWithRemark:(TrafficRecord *)trafficRecord{
    NSString* stationString         = [NSString stringWithFormat:@"K%d+%dM", trafficRecord.station.integerValue/1000, trafficRecord.station.integerValue%1000];
    InspectionRecord *inspectionRecord = [InspectionRecord lastRecordsForInspection:trafficRecord.myid];
    NSString *remark                = @"";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *timeStr = [dateFormatter stringFromDate:inspectionRecord.start_time];
    if ([trafficRecord.infocome isEqualToString:@"交警"]) {
        //        remark = [NSString stringWithFormat:@"%@接交警报%@K%@路段有交通事故，路政人员立即前往。", timeStr, inspectionRecord.fix, trafficRecord.station];
        remark = [NSString stringWithFormat:@"%@ 接交警报方向%@发现交通事故", timeStr, stationString];
    }else if ([trafficRecord.infocome isEqualToString:@"监控"]) {
        remark = [NSString stringWithFormat:@"%@ 接监控中心报方向%@发现交通事故，", timeStr, stationString];
    }else if ([trafficRecord.infocome isEqualToString:@"路政"]) {
        //        remark = [NSString stringWithFormat:@"%@巡查至%@K%@路段发现有交通事故。", timeStr, inspectionRecord.fix, trafficRecord.station];
        remark = [NSString stringWithFormat:@"%@ 巡查至方向%@发现交通事故，", timeStr, stationString];
    }
    
    if (trafficRecord.car) {
        remark = [remark stringByAppendingFormat:@"，肇事车辆：%@", trafficRecord.car];
    }
    
    if (trafficRecord.infocome) {
        remark = [remark stringByAppendingFormat:@"，事故消息来源：%@", trafficRecord.infocome];
    }
    
    if (trafficRecord.fix) {
        remark = [remark stringByAppendingFormat:@"，事故方向：%@", trafficRecord.fix];
    }
    
    if (stationString) {
        remark = [remark stringByAppendingFormat:@"，事故发生地点（桩号）：%@", stationString];
    }
    
    if (trafficRecord.property) {
        remark = [remark stringByAppendingFormat:@"，事故性质：%@", trafficRecord.property];
    }
    
    if (trafficRecord.type) {
        remark = [remark stringByAppendingFormat:@"，事故分类：%@", trafficRecord.type];
    }
    
    if (trafficRecord.roadsituation) {
        remark = [remark stringByAppendingFormat:@"，事故封道情况：%@", trafficRecord.roadsituation];
    }
    
    if (trafficRecord.wdsituation) {
        remark = [remark stringByAppendingFormat:@"，事故伤亡情况：%@", trafficRecord.wdsituation];
    }
    
    if (trafficRecord.lost) {
        remark = [remark stringByAppendingFormat:@"，路产损失金额：%@", trafficRecord.lost];
    }
    
    if (trafficRecord.isend) {
        remark = [remark stringByAppendingFormat:@"，是否结案：%@", trafficRecord.isend];
    }
    
    if (trafficRecord.paytype) {
        remark = [remark stringByAppendingFormat:@"，索赔方式：%@", trafficRecord.paytype];
    }
    
    if (trafficRecord.zjstart) {
        remark = [remark stringByAppendingFormat:@"，拯救处理开始时间：%@", [dateFormatter stringFromDate:trafficRecord.zjstart]];
    }
    
    if (trafficRecord.zjend) {
        remark = [remark stringByAppendingFormat:@"，拯救处理结束时间：%@", [dateFormatter stringFromDate:trafficRecord.zjend]];
    }
    
    if (trafficRecord.zjend) {
        remark = [remark stringByAppendingFormat:@"，拯救处理结束时间：%@", [dateFormatter stringFromDate:trafficRecord.zjend]];
    }
    
    if (trafficRecord.clstart) {
        remark = [remark stringByAppendingFormat:@"，事故处理开始时间：%@", [dateFormatter stringFromDate:trafficRecord.clstart]];
    }
    
    if (trafficRecord.clend ) {
        remark = [remark stringByAppendingFormat:@"，事故处理结束时间：%@", [dateFormatter stringFromDate:trafficRecord.clend]];
    }
    
    if (trafficRecord.remark) {
        remark = [remark stringByAppendingFormat:@"，备注：%@", trafficRecord.remark];
    }
    
    remark                  = [remark stringByAppendingFormat:@"。"];
    inspectionRecord.remark = remark;
    [[AppDelegate App] saveContext];
}

+ (NSString * )createTrafficRecordForRemark:(TrafficRecord *)trafficRecord{
    NSArray * array = [[NSUserDefaults standardUserDefaults]objectForKey:trafficRecord.myid];
    NSString* stationString         = [NSString stringWithFormat:@"K%ld+%ldM", trafficRecord.station.integerValue/1000, trafficRecord.station.integerValue%1000];
    InspectionRecord * inspectionRecord = [InspectionRecord RecordsForInspection:trafficRecord.myid];
    NSString *remark                = @"";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString * timeStr = [dateFormatter stringFromDate:trafficRecord.happentime];
    NSString * timefirst = [dateFormatter stringFromDate:trafficRecord.zjstart];
    NSString * timeSecond = [dateFormatter stringFromDate:trafficRecord.zjend];
    NSString * timeThird = [dateFormatter stringFromDate:trafficRecord.clstart];
    NSString * timeFour = [dateFormatter stringFromDate:trafficRecord.clend];
   if ([trafficRecord.infocome isEqualToString:@"路政"]) {
        //        remark = [NSString stringWithFormat:@"%@巡查至%@K%@路段发现有交通事故。", timeStr, inspectionRecord.fix, trafficRecord.station];
        remark = [NSString stringWithFormat:@"   %@  巡查中发现%@方向%@处%@%@因%@发生交通事故，", timeStr,trafficRecord.fix, stationString,trafficRecord.car,array[0],trafficRecord.type];
    }
    //交警或监控
    if ([trafficRecord.infocome isEqualToString:@"交警"]) {
        //        remark = [NSString stringWithFormat:@"%@接交警报%@K%@路段有交通事故，路政人员立即前往。", timeStr, inspectionRecord.fix, trafficRecord.station];
        remark = [NSString stringWithFormat:@"   %@  接交警报%@方向%@发现交通事故。", timeStr, trafficRecord.fix,stationString];
        remark = [NSString stringWithFormat:@"%@\n   %@  路政人员出发前往现场。",remark,timefirst];
        remark = [NSString stringWithFormat:@"%@\n   %@  到达现场，证实%@%@因%@发生交通事故，",remark,timeSecond,trafficRecord.car,array[0],trafficRecord.type];
        
    }else if ([trafficRecord.infocome isEqualToString:@"监控"]) {
        remark = [NSString stringWithFormat:@"   %@  接监控中心%@报方向%@发现交通事故。", timeStr, trafficRecord.fix,stationString];
        remark = [NSString stringWithFormat:@"%@\n   %@  路政人员出发前往现场。",remark,timefirst];
        remark = [NSString stringWithFormat:@"%@\n   %@  到达现场，证实%@%@因%@发生交通事故，",remark,timeSecond,trafficRecord.car,array[0],trafficRecord.type];
    }
    remark = [NSString stringWithFormat:@"%@造成",remark];
    if([trafficRecord.fleshwound_sum integerValue] == 0 && [trafficRecord.badwound_sum integerValue] == 0 && [trafficRecord.death_sum integerValue] == 0){
        remark = [remark stringByReplacingOccurrencesOfString:@"造成" withString:@"未造成人员伤亡,"];
    }else {
        if([trafficRecord.fleshwound_sum integerValue] != 0){
            remark = [NSString stringWithFormat:@"%@%ld人轻伤,",remark,[trafficRecord.fleshwound_sum integerValue]];
        }
        if([trafficRecord.badwound_sum integerValue] != 0){
            remark = [NSString stringWithFormat:@"%@%ld人重伤,",remark,[trafficRecord.badwound_sum integerValue]];
        }
        if([trafficRecord.death_sum integerValue] != 0){
            remark = [NSString stringWithFormat:@"%@%ld人死亡,",remark,[trafficRecord.death_sum integerValue]];
        }
    }
    if ([trafficRecord.infocome isEqualToString:@"路政"]) {
        if([array count]>2){
            if(![array[2] isEqualToString:@""]){
                remark = [NSString stringWithFormat:@"%@%@现场临交通中断，堵塞车龙约%@公里，临时封闭%@所有车道，%@方向车辆%@起在%@分流，关闭%@。",remark,timefirst,array[4],trafficRecord.fix,trafficRecord.fix,timeThird,array[2],array[3]];
            }
            //        else if(![array[1] isEqualToString:@"无"]){
            else{
                remark = [NSString stringWithFormat:@"%@现场临时封闭%@、%@可通行，未出现交通中断现象。",remark,trafficRecord.roadsituation,array[1]];
            }
        }
        if (![array[2] isEqualToString:@""]) {
            remark = [NSString stringWithFormat:@"%@\n   %@  现场道路解封,%@分流结束，%@方向%@通行、%@继续封闭。",remark,timeSecond,array[2],trafficRecord.fix,array[1],trafficRecord.roadsituation];
        }else{
            remark = [NSString stringWithFormat:@"%@\n   %@  现场道路解封。",remark,timeSecond];
        }
        
        remark = [NSString stringWithFormat:@"%@\n   %@  事故处理完毕，交通秩序恢复正常。事故未造成路产损失，按%@程序处理。",remark,timeFour,trafficRecord.property];
    }else{
         remark = [NSString stringWithFormat:@"%@现场临时封闭%@、%@可通行，未出现交通中断现象,按%@程序处理。",remark,trafficRecord.roadsituation,array[1],trafficRecord.property];
        remark = [NSString stringWithFormat:@"%@\n   %@  事故处理完毕，交通秩序恢复正常。",remark,timeFour];
    }
    
    return remark;
}
@end
