//
//  ServiceCheckDetail.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import "ServiceCheckDetail.h"


@implementation ServiceCheckDetail

@dynamic myid;
@dynamic parent_id;
@dynamic target;
@dynamic item;
@dynamic standard;
@dynamic score;
@dynamic sorts;
@dynamic grade;
@dynamic remark;
@dynamic isuploaded;
+(NSArray*)ServiceCheckDetailForID:(NSString *)ID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServiceCheckDetail" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id==%@", ID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sorts"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return  nil;
    }
    return  fetchedObjects;
}
@end
