//
//  CaseInquire.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-19.
//
//

#import "UserInfo.h"
#import "CaseProveInfo.h"
#import "CaseInquire.h"


@implementation CaseInquire

@dynamic address;
@dynamic age;
@dynamic answerer_name;
@dynamic proveinfo_id;
@dynamic company_duty;
@dynamic date_inquired;
@dynamic inquirer_name;
@dynamic inquiry_note;
@dynamic isuploaded;
@dynamic locality;
@dynamic myid;
@dynamic phone;
@dynamic postalcode;
@dynamic recorder_name;
@dynamic relation;
@dynamic sex;
@dynamic times;
@dynamic date_inquired_end;

- (NSString *) signStr{
    if (![self.proveinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.proveinfo_id];
    }else{
        return @"";
    }
}

+(CaseInquire *)inquireForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInquire" inManagedObjectContext:context];
    NSPredicate *predicate;
    predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@",caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    if (tempArray && [tempArray count]>0) {
        return [tempArray objectAtIndex:0];
    }else{
        return nil;
    }
}
+(CaseInquire *)inquireForCase:(NSString *)caseID andRelation:(NSString *)relation{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSPredicate * predicate;
    predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && relation == %@",caseID,relation];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    if (tempArray && [tempArray count]>0) {
        return [tempArray objectAtIndex:0];
    }else{
        return nil;
    }
}


- (NSString *)prover1{
    NSArray *chunks = [self.inquirer_name componentsSeparatedByString: @","];
    if([chunks count] >= 2)
    {
        //勘验人1 单位职务
        return [chunks objectAtIndex:0];
    }else{
        return self.inquirer_name;
    }
}
- (NSString *)prover2{
    NSArray *chunks = [self.inquirer_name componentsSeparatedByString: @","];
    if(chunks && [chunks count] >= 2)
    {
        //勘验人2 单位职务
        for (int i = 1; i < [chunks count];i++) {
            if (![chunks[i] isEqualToString:[self prover1]]) {
                return chunks[i];
            }
            else{
                return @"";
            }
        }
//        return [chunks objectAtIndex:1];
    }
        //        return self.secondProver;
    return @"";
}
- (NSString *)prover1_exelawid{
    if ([self prover1]) {
        NSString * prover1 = [self prover1];
        NSString * exelawid  = [UserInfo exelawIDForUserName:prover1];
        return exelawid;
    }
    return nil;
}
- (NSString *)prover2_exelawid{
    if ([self prover2]) {
        NSString * prover1 = [self prover2];
        NSString * exelawid  = [UserInfo exelawIDForUserName:prover1];
        return exelawid;
    }
    return nil;
}
- (NSString *)remark{
    CaseProveInfo * proveinfo = [CaseProveInfo proveInfoForCase:self.proveinfo_id];
    return proveinfo.remark;
}
@end
