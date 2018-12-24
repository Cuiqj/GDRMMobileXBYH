//
//  RoadSegmentPickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-19.
//
//

#import <UIKit/UIKit.h>
#import "RoadSegment.h"

typedef enum {
    kRoadSegment = 0,
    kRoadSide,
    kRoadPlace,
    kShoufz,
    kZadao
} RoadSegmentPickerState;
//typedef (void)(^setRoadsegment)(RoadSegment*);
@protocol RoadSegmentPickerDelegate;

@interface RoadSegmentPickerViewController : UITableViewController
@property (assign, nonatomic                     ) RoadSegmentPickerState    pickerState;
@property (weak, nonatomic                       ) UIPopoverController       *pickerPopover;
@property (weak, nonatomic                       ) id<RoadSegmentPickerDelegate> delegate;
@property (weak, nonatomic  )void(^setRoadsegment) (  RoadSegment              *);
@end

@protocol RoadSegmentPickerDelegate <NSObject>
@optional
- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName;
- (void)setRoadPlace:(NSString *)place;
- (void)setRoadSide:(NSString *)side;
- (void)setShoufz:(NSString*) sfzname sfzID:(NSString*)sfzID;
- (NSArray*)getZadao;
@end