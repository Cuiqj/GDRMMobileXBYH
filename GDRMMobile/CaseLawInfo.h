//
//  CaseLawInfo.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CaseLawInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * buildingtype;
@property (nonatomic, retain) NSString * breaklawdesc;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * sendorgname;
@property (nonatomic, retain) NSDate * senddate;
@property (nonatomic, retain) NSString * linkaddress;
@property (nonatomic, retain) NSString * linktel;
+(CaseLawInfo*)CaseLawInfoForCaseID:(NSString*)caseID;
@end
