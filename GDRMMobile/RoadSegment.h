//
//  RoadSegment.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RoadSegment : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * delflag;
@property (nonatomic, retain) NSString * driveway_count;
@property (nonatomic, retain) NSNumber * group_flag;
@property (nonatomic, retain) NSString * group_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * place_end;
@property (nonatomic, retain) NSString * place_start;
@property (nonatomic, retain) NSString * place_prefix1;
@property (nonatomic, retain) NSString * place_prefix2;
@property (nonatomic, retain) NSString * road_grade;
@property (nonatomic, retain) NSString * road_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSNumber * station_start;

//根据路段ID返回路段名称   现在不显示名称显示place_prefix1;
+ (NSString *)roadNameFromSegment:(NSString *)segmentID;
+ (NSString *)roadNameForCaseFileFromSegment:(NSString *)segmentID;

//重写显示place_prefix1和name
+ (NSString *)roadNameAndroadFromSegment:(NSString *)segmentID;


//案发地点的名称显示roadsegment.place_prefix1，原来是显示roadsegment.name的
//案件路段显示为：roadsegment.code+roadsegment.name 案发地点组话的时候，显示roadsegment.place_prefix1
//案件路段显示为：roadsegment.place_prefix1+roadsegment.name 案发地点组话的时候，显示roadsegment.place_prefix1
//路段ID
//地点的路段在数据库中保存的是id，但是在界面上显示的文本


//返回所有的路段名称和路段号
+ (NSArray *)allRoadSegments;
+ (NSArray *)allRoadSegmentsForCaseView;
-(void)setName:(NSString *)name;
-(void)setMyid:(NSString *)myid;
@end
