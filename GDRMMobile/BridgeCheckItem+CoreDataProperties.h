//
//  BridgeCheckItem+CoreDataProperties.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import "BridgeCheckItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BridgeCheckItem (CoreDataProperties)

+ (NSFetchRequest<BridgeCheckItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *myid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *project;
@property (nullable, nonatomic, copy) NSString *east;
@property (nullable, nonatomic, copy) NSString *west;
@property (nullable, nonatomic, copy) NSString *classes;
@property (nullable, nonatomic, copy) NSString *org_id;

@end

NS_ASSUME_NONNULL_END
