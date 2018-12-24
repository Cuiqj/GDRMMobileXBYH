//
//  Sfz.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/10.
//
//

#import "Sfz.h"


@implementation Sfz

@dynamic myid;
@dynamic sfz_name;
@dynamic roadsegment_id;
@dynamic station_start;
@dynamic station_end;
@dynamic remark;
+(NSArray*) allShoufzName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sfz" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
   
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error] ;
    
    return fetchedObjects;
}
+(Sfz*)aSfzForID:(NSString*)ID{
    NSManagedObjectContext *context =[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sfz" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"myid==%@", ID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return nil;
    }
    if(fetchedObjects.count>0)
    return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}
@end
