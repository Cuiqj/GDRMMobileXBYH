//
//  Times+CoreDataClass.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/2/28.
//
//

#import "Times+CoreDataClass.h"

@implementation Times
+(NSArray*)TimesByParent_id:(NSString *)parent_id{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"Times" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id=%@", parent_id];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error          = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return  fetchedObjects;
}
@end
