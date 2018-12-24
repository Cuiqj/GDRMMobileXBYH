//
//  CaseMap.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-16.
//
//

#import "CaseMap.h"


@implementation CaseMap

@dynamic myid;
@dynamic isuploaded;
@dynamic caseinfo_id;
@dynamic draftsman_name;
@dynamic draw_time;
@dynamic road_type;
@dynamic remark;
@dynamic map_item;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

+ (CaseMap *)caseMapForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}

- (NSString *)map_remark{
    NSRange range1 =[self.remark rangeOfString:@"事实为："];
    NSString *subStr4 =self.remark;
    if(range1.length>0)
        [self.remark  substringFromIndex:range1.location+range1.length+1];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"1、" withString:@"A为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"2、" withString:@"B为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"3、" withString:@"C为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"4、" withString:@"D为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"5、" withString:@"E为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"6、" withString:@"F为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"7、" withString:@"G为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"8、" withString:@"H为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"9、" withString:@"I为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"10、" withString:@"J为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"11、" withString:@"K为"];
    subStr4=[subStr4 stringByReplacingOccurrencesOfString:@"\n以上勘验完毕。" withString:@""];
    return subStr4;
}

- (NSString *)map_file{
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[pathArray objectAtIndex:0];
    NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseinfo_id];
    mapPath=[documentPath stringByAppendingPathComponent:mapPath];
    NSString *mapName = @"casemap.jpg";
    NSString *filePath=[mapPath stringByAppendingPathComponent:mapName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    }else{
        return nil;
    }
}
@end
