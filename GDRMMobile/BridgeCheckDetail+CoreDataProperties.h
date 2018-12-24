//
//  BridgeCheckDetail+CoreDataProperties.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import "BridgeCheckDetail+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BridgeCheckDetail (CoreDataProperties)

+ (NSFetchRequest<BridgeCheckDetail *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *myid;
@property (nullable, nonatomic, copy) NSNumber *isuploaded;
@property (nullable, nonatomic, copy) NSString *item_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *project;
@property (nullable, nonatomic, copy) NSString *east;
@property (nullable, nonatomic, copy) NSString *west;
@property (nullable, nonatomic, copy) NSString *classes;
@property (nullable, nonatomic, copy) NSString *check_situation;
@property (nullable, nonatomic, copy) NSString *cubic_m;
@property (nullable, nonatomic, copy) NSString *handle;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *parent_id;
@property (nullable, nonatomic, copy) NSDate *recordtime;

@end

NS_ASSUME_NONNULL_END
