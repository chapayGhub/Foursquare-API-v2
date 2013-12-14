//
//  SettingsViewController.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 1/21/13.
//
//

#import "SettingsViewController.h"
#import "Foursquare2.h"

typedef enum CellsType{
    nickname,
    breed,
    sex,
    bithday,
    relationships,
    owner,
    count
} CellsType;

NSString* cellsIds[count] = {
    @"nickname",
    @"breed",
    @"sex",
    @"bithday",
    @"relationships",
    @"owner"
};


@interface SettingsViewController ()

@property (nonatomic, retain) NSMutableArray* profileData;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    
    self.profileData = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",nil];
    
    [super viewDidLoad];
    [self prepareViewForUser];
    self.title = @"Settings";
}

- (void)prepareViewForUser {
    [Foursquare2  userGetDetail:@"self"
                       callback:^(BOOL success, id result){
                           if (success) {
                               
                               NSString *nick = [NSString stringWithFormat:@"%@ %@",
                                                 [result valueForKeyPath:@"response.user.firstName"],
                                                 [result valueForKeyPath:@"response.user.lastName"]];
                               [self.profileData replaceObjectAtIndex:nickname
                                                           withObject:nick];
                               
                               NSString *imageUrl = [NSString stringWithFormat:@"%@200x200%@",
                                                    [result valueForKeyPath:@"response.user.photo.prefix"],
                                                    [result valueForKeyPath:@"response.user.photo.suffix"]];
                               
                               NSURL *url = [NSURL URLWithString:imageUrl];
                               NSData* imgData =  [NSData dataWithContentsOfURL:url];
                               if([imgData length])
                               {
                                   self.avatar.image = [UIImage imageWithData:imgData];
                               }
                               
                               [self.profile reloadData];
                               NSLog(@"%@", result);
                           }
                       }];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)logout:(id)sender {
    [Foursquare2 removeAccessToken];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return count;
}

//4
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = cellsIds[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *data = [self.profileData objectAtIndex:indexPath.row];
    [cell.textLabel setText:data];
    [cell.detailTextLabel setText:cellIdentifier];
    return cell;
}

@end
