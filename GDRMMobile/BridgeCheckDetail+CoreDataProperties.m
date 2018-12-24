//
//  BridgeCheckDetail+CoreDataProperties.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import "BridgeCheckDetail+CoreDataProperties.h"

@implementation BridgeCheckDetail (CoreDataProperties)

+ (NSFetchRequest<BridgeCheckDetail *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BridgeCheckDetail"];
}

@dynamic myid;
@dynamic isuploaded;
@dynamic item_id;
@dynamic name;
@dynamic project;
@dynamic east;
@dynamic west;
@dynamic classes;
@dynamic check_situation;
@dynamic cubic_m;
@dynamic handle;
@dynamic remark;
@dynamic status;
@dynamic recordtime;
@dynamic parent_id;
@end
