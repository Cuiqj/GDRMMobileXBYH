//
//  PoliceReport.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/2.
//
//

#import "PoliceReport.h"


@implementation PoliceReport

@dynamic myid;
@dynamic caseinfo_id;
@dynamic report_desc;
@dynamic isuploaded;
@dynamic send_date;
+(PoliceReport*)policeReportForCaseID:(NSString *)ID{

    NSManagedObjectContext *context =[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PoliceReport" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"caseinfo_id==%@", ID];
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
    if(fetchedObjects.count<1) return nil;
    else return [fetchedObjects objectAtIndex:0];
}
@end
