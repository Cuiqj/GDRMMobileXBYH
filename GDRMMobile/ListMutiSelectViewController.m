//
//  ListMutiSelectViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/6.
//
//

#import "ListMutiSelectViewController.h"

@interface ListMutiSelectViewController ()

@end

@implementation ListMutiSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.ListView=[[UITableView alloc]initWithFrame:self.view.frame];
//    self.ListView.delegate=self;
//    self.ListView.dataSource=self;
//    [self.view addSubview:self.ListView];
    UIBarButtonItem *leftbutton =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle:)];
     UIBarButtonItem *rightbutton= [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(conform:)];
    self.navigationItem.leftBarButtonItem=leftbutton;
    self.navigationItem.rightBarButtonItem=rightbutton;
    [self.view setUserInteractionEnabled:YES];
    //self.tableView.editing = YES;
	//self.allowsMultipleSelectionDuringEditing = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.tempdata=[[NSMutableArray alloc]init];
 }
- (void)viewDidUnload
{
    [super viewDidUnload];
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString* cellString =[self.data objectAtIndex:indexPath.row];
    cell.textLabel.text=cellString;
    if ([self.selectedData rangeOfString:cellString].length>0) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
	
	return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    [self.tempdata addObject:indexPath ];
    //CaseDescString *temp=[self.data objectAtIndex:indexPath.row];
    //temp.isSelected=YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    [self.tempdata removeObject:indexPath ];
    //CaseDescString *temp=[self.data objectAtIndex:indexPath.row];
    //temp.isSelected=NO;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (IBAction)btnCancel:(id)sender {
    [self.pickerPopover dismissPopoverAnimated:YES];
}

- (IBAction)btnConfirm:(id)sender {
    NSMutableArray *resultArray=[[NSMutableArray alloc]init];
    for (NSIndexPath *index in self.tempdata) {
        [resultArray addObject:[ self.data objectAtIndex:index.row]];
    }
    self.setDataCallback(resultArray);
    [self.pickerPopover dismissPopoverAnimated:YES];
}
@end
