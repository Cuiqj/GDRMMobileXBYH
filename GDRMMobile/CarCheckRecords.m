//
//  CarCheckRecords.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import "CarCheckRecords.h"


@implementation CarCheckRecords

@dynamic isuploaded;
@dynamic myid;
@dynamic parent_id;
@dynamic checktext;
@dynamic checkdesc;
@dynamic defaultvalue;
@dynamic reason;
@dynamic list;
+(NSArray*)allCarCheckRecords{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarCheckRecords" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"format string", <#arguments#>];
    //[fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return  fetchedObjects;
}
+(CarCheckRecords*) CarCheckRecordsForID:(NSString*)idString{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarCheckRecords" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"myid==%@", idString];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if(fetchedObjects==nil){
        return nil;
    }
    
    return  [fetchedObjects objectAtIndex:0];
}
+(NSArray*) CarCheckRecordsForParent_ID:(NSString*)PidString{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarCheckRecords" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id==%@", PidString];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if(fetchedObjects==nil){
        return nil;
    }
    
    return fetchedObjects;// [fetchedObjects objectAtIndex:0];
}
+(void) DeleteCarCheckRecordsForParent_ID:(NSString*)PidString{
    NSArray* dataArray=[self CarCheckRecordsForParent_ID:PidString];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    for (CarCheckRecords *record in dataArray) {
        [context deleteObject:record];
    }
}
@end
