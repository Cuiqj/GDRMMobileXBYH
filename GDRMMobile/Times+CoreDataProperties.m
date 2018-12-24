//
//  Times+CoreDataProperties.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/2/28.
//
//

#import "Times+CoreDataProperties.h"

@implementation Times (CoreDataProperties)

+ (NSFetchRequest<Times *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Times"];
}

@dynamic myid;
@dynamic parent_id;
@dynamic name;
@dynamic time;

@end
