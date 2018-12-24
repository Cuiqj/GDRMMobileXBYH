//
//  HelpWork.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/6.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HelpWork : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSDate * happen_date;
@property (nonatomic, retain) NSString * duty;
@property (nonatomic, retain) NSString * do_content;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isuploaded;

@end
