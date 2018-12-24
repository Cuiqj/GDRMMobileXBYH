//
//  ServiceCheckItems.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import "ServiceCheckItems.h"


@implementation ServiceCheckItems

@dynamic myid;
@dynamic target;
@dynamic item;
@dynamic standard;
@dynamic score;
@dynamic sorts;

+(NSArray*)allServiceCheckItemsTarget{
    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServiceCheckItems" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ServiceCheckItems"];
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServiceCheckItems" inManagedObjectContext:context];
    
    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
    // Since you only want distinct names, only ask for the 'name' property.
     
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"target"]];
    fetchRequest.returnsDistinctResults = YES;
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return  nil;
    }
    return  [fetchedObjects valueForKeyPath:@"target"]  ;
}
+(NSArray*)serviceCheckItemsItemForTarget:(NSString*)target{
    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServiceCheckItems" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"target=%@",target];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return  nil;
    }
    return [fetchedObjects valueForKeyPath:@"item"];
}
+(ServiceCheckItems*)serviceCheckItemsItemForTarget:(NSString*)target andItems:(NSString*)item{
    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServiceCheckItems" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"target=%@ and item=%@",target,item];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return  nil;
    }
    return [fetchedObjects objectAtIndex:0];
}

@end
