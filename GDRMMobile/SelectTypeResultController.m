//
//  SelectTypeResultController.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/6/6.
//

#import "SelectTypeResultController.h"

@interface SelectTypeResultController ()

@end

@implementation SelectTypeResultController
@synthesize myPopover=_myPopover;
@synthesize delegate=_delegate;
@synthesize SelectList = _SelectList;


- (void)viewDidLoad {
    
    self.SelectTypeResult.delegate = self;
    self.SelectTypeResult.dataSource = self;
    if ([ self.textfieldtag integerValue] > 335) {
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, 60, 220);
        self.NavigationShow.topItem.title = @"列表信息";
    }else{
        self.NavigationShow.topItem.title = @"列表";
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.SelectList.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier=@"CaseListCell";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell==nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    cell.textLabel.text = [self.SelectList objectAtIndex:indexPath.row];
////两行    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@年%@号",caseInfo.case_mark2,caseInfo.full_case_mark3];
//
//    return cell;
    UITableViewCell *cell;
    if (indexPath.section==0) {
        static NSString *CellIdentifier=@"CitizenListCell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if ([tableView isEditing]) {
            UITextField *textField=(UITextField *)[cell.contentView viewWithTag:1007];
            textField.text=[self.SelectList objectAtIndex:indexPath.row];
            cell.textLabel.text=@"";
        } else {
            cell.textLabel.text=[self.SelectList objectAtIndex:indexPath.row];
        }
    } else {
        static NSString *CellIdentifier=@"NewCitizenCell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text=@"";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate  loadTextand:self.SelectList[indexPath.row] addTag:[self.textfieldtag integerValue]];
    [self.myPopover dismissPopoverAnimated:YES];
}

//设置为可编辑的
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (indexPath.section == 1) {
        if ([self.SelectList[0] isEqual:@"A"]) {
            return UITableViewCellEditingStyleNone;
        }
        return UITableViewCellEditingStyleInsert;
    }
    if ([self.SelectList[0] isEqual:@"A"]) {
        if (indexPath.row > 2) {
            return UITableViewCellEditingStyleDelete;
        }else{
            return UITableViewCellEditingStyleNone;
        }
    }else{
        if (indexPath.row >1) {
            return UITableViewCellEditingStyleDelete;
        }else{
            return UITableViewCellEditingStyleNone;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//删除案件信息
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"此项不可删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];//一般在if判断中加入
            [alert show];
            return;
        }else if(indexPath.row == 2 && [self.SelectList[0] isEqualToString:@"A"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"此项不可删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];//一般在if判断中加入
            [alert show];
            return;
        }
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.SelectList == appDelegate.selectType) {
            [appDelegate.selectType removeObjectAtIndex:indexPath.row];
        }else if(self.SelectList == appDelegate.selectResult){
            [appDelegate.selectResult removeObjectAtIndex:indexPath.row];
        }
        [self.SelectList removeObjectAtIndex:indexPath.row];
        
//        [self.delegate deleteCaseAllDataForCase:[[self.caseList objectAtIndex:indexPath.row] valueForKey:@"myid"]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [tableView reloadData];
    }
    if (editingStyle == UITableViewCellEditingStyleInsert) {
//        NSInteger row = [indexPath row];
//        NSArray *insertIndexPath = [NSArray arrayWithObjects:indexPath, nil];
//        NSString *mes = [NSString stringWithFormat:@"添加的第%d行",row+1];
//        //        添加单元行的设置的标题
//        if(![mes isEqualToString:@""])
//        [self.SelectList insertObject:mes atIndex:row];
//        [appDelegate.selectResult insertObject:mes atIndex:row];
//        [tableView insertRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationRight];
        NSIndexPath *indexPathForInsert=[NSIndexPath indexPathForRow:self.SelectList.count-1 inSection:0];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForInsert] withRowAnimation:UITableViewRowAnimationRight];
        UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPathForInsert];
        UITextField *newTextField=[[UITextField alloc] initWithFrame:CGRectMake(myCell.frame.origin.x+6, (myCell.frame.size.height-31)/2, myCell.frame.size.width-100, 31)];
        newTextField.borderStyle=UITextBorderStyleRoundedRect;
        newTextField.textColor=[UIColor blackColor];
        newTextField.returnKeyType=UIReturnKeyDefault;
        newTextField.textAlignment=UITextAlignmentLeft;
        newTextField.text=@"";
        newTextField.font=[UIFont systemFontOfSize:17];
        newTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        newTextField.keyboardType=UIKeyboardTypeDefault;
        newTextField.tag=1007;
        [myCell.contentView addSubview:newTextField];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)btnClickEdit:(id)sender {
    if ([self.SelectTypeResult isEditing]) {
        [(UIBarButtonItem *)sender setTitle:@"编辑"];
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [(UIBarButtonItem *)sender setStyle:UIBarButtonItemStyleBordered];
        [self.SelectTypeResult setEditing:NO animated:YES];
    } else {
        [(UIBarButtonItem *)sender setTitle:@"完成"];
        [(UIBarButtonItem *)sender setStyle:UIBarButtonItemStyleDone];
        [self.SelectTypeResult setEditing:YES animated:YES];
        
        for (int i=0; i<self.SelectList.count; i++) {
            UITableViewCell *myCell=[self.SelectTypeResult cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            UITextField *newTextField=[[UITextField alloc] initWithFrame:CGRectMake(myCell.frame.origin.x+6, (myCell.frame.size.height-31)/2, myCell.frame.size.width-100, 31)];
            newTextField.borderStyle=UITextBorderStyleRoundedRect;
            newTextField.textColor=[UIColor blackColor];
            newTextField.returnKeyType=UIReturnKeyDone;
            newTextField.textAlignment=UITextAlignmentLeft;
            newTextField.text=myCell.textLabel.text;
            newTextField.font=[UIFont systemFontOfSize:17];
            newTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            newTextField.keyboardType=UIKeyboardTypeDefault;
            [myCell.contentView addSubview:newTextField];
            myCell.textLabel.text=@"";
            newTextField.tag=1007;
        }
    }
}

@end
