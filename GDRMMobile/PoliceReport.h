//
//  PoliceReport.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/2.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PoliceReport : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * report_desc;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSDate   * send_date;
+(PoliceReport*) policeReportForCaseID:(NSString*)ID;
@end
