//
//  ConstructionCorrect.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/8/8.
//

#import "ConstructionCorrect.h"

@implementation ConstructionCorrect

@dynamic caseinfo_id;
@dynamic correct_name;
@dynamic myid;
@dynamic isuploaded;
@dynamic breakLaw_one;
@dynamic breakLaw_two;
@dynamic breakLaw_three;
@dynamic breakLaw_four;
@dynamic demand_one;
@dynamic demand_two;
@dynamic demand_three;
@dynamic demand_four;
@dynamic law;
@dynamic at_once;
@dynamic later;
@dynamic end_date_time;
@dynamic smallplace;
@dynamic mark;

+(ConstructionCorrect *)newCaseConstructionCorrectForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    ConstructionCorrect * construction = [[ConstructionCorrect alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    construction.caseinfo_id = caseID;
    construction.isuploaded = @(NO);
    construction.myid = [NSString randomID];
    [[AppDelegate App] saveContext];
    return construction;
}

+ (ConstructionCorrect *)caseConstructionCorrectForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    if (result && [result count]>0) {
        return [result objectAtIndex:0];
    }else{
        return nil;
    }
}

@end
