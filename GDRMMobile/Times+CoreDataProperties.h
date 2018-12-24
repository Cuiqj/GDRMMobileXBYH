//
//  Times+CoreDataProperties.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/2/28.
//
//

#import "Times+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Times (CoreDataProperties)

+ (NSFetchRequest<Times *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *myid;
@property (nullable, nonatomic, copy) NSString *parent_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *time;

@end

NS_ASSUME_NONNULL_END
