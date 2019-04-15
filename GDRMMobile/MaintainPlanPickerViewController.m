//
//  MaintainPlanPickerViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/18.
//
//

#import "MaintainPlanPickerViewController.h"
#import "MaintainPlan.h"

@interface MaintainPlanPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation MaintainPlanPickerViewController
@synthesize pickerType=_pickerType;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSDate * date =
    if(_pickerType==1){
        NSMutableArray * nsmudata = [NSMutableArray arrayWithArray:[MaintainPlan allMaintainPlan]] ;
        NSInteger count = [nsmudata count];
        for (int i = 0; i< count; i++) {
            MaintainPlan * plan = [nsmudata objectAtIndex:i];
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString * anotherday = [formatter stringFromDate:plan.date_end];
            if ([self compareOneDay:[self getCurrentTime] withAnotherDay:anotherday] == 1){
                NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                [context deleteObject:plan];
            }
        }
        [[AppDelegate App] saveContext];
        self.data= [MaintainPlan allMaintainPlan];
//        self.data=[MaintainPlan allMaintainPlanfordate:date];
    }
    else if (_pickerType==2){
       self.data=[[NSMutableArray alloc]initWithObjects:@"施工前检查",@"施工期间检查", nil];
    }
    else if (_pickerType==3){
        self.data=[[NSMutableArray alloc]initWithObjects:@"是",@"否", nil];
    }
}
- (NSString *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    return dateTime;
}
- (int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"DateA  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"DateA is in the past");
        return -1;
    }else{
        //NSLog(@"Both dates are the same");
        return 0;
    }
}
- (void)viewDidUnload
{
    [self setData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(_pickerType==1){
    cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"project_name"];
    }
    else{
     cell.textLabel.text=[self.data objectAtIndex:indexPath.row] ;
    }
//    NSLog(@"%d----%@----",indexPath.row,[[self.data objectAtIndex:indexPath.row] valueForKey:@"date_start"]);
//    NSLog(@"%d----%@----",indexPath.row,[[self.data objectAtIndex:indexPath.row] valueForKey:@"date_end"]);
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_pickerType==1){
    NSString *userName=[[self.data objectAtIndex:indexPath.row] valueForKey:@"project_name"];
    NSString *userID=[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"];
    [self.delegate setMaintainPlan:userName andID:userID];
    [self.pickerPopover dismissPopoverAnimated:YES];
    }else{
        NSString *userName=[self.data objectAtIndex:indexPath.row] ;
        //NSString *userID=[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"];
        NSString *userID=nil;
        if([userName isEqualToString:@"是"]){userID=@"1";}
        else if([userName isEqualToString:@"否"]){userID=@"0";}
        [self.delegate setMaintainPlan:userName andID:userID];
        [self.pickerPopover dismissPopoverAnimated:YES];
    }
}

@end
