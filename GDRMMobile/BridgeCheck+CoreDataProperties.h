//
//  BridgeCheck+CoreDataProperties.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import "BridgeCheck+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BridgeCheck (CoreDataProperties)

+ (NSFetchRequest<BridgeCheck *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *myid;
@property (nullable, nonatomic, copy) NSNumber *isuploaded;
@property (nullable, nonatomic, copy) NSString *org_id;
@property (nullable, nonatomic, copy) NSDate *check_date;

@end

NS_ASSUME_NONNULL_END
