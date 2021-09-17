//
//  UserListTableViewController.m
//  ObjectiveSocial
//
//  Created by Pedro Henrique on 16/09/21.
//

#import "UserListTableViewController.h"

@interface UserListTableViewController () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSArray *users;

@end

@implementation UserListTableViewController

NSString *kBaseURL = @"https://jsonplaceholder.typicode.com";


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL *url = [NSURL URLWithString: [kBaseURL stringByAppendingString:@"/users"]];
    if (url != nil) {
        typeof(self) weakSelf = self;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:weakSelf
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        
        [[session dataTaskWithURL:url] resume];
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_users == nil) {
        return 0;
    }
    
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    NSDictionary *user = _users[indexPath.row];
    
    [cell.textLabel setText:user[@"name"]];
    [cell.detailTextLabel setText:user[@"email"]];
    
    NSUInteger x = 10;
    
    

    return cell;
}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)dataTask.response;
    if (response.statusCode >= 200 && response.statusCode < 300) {
        
        NSError *error;
    
        NSArray *users = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error: &error];
        
        if (error != nil) {
            NSLog(@"Deu erro: %@", [error debugDescription]);
        }
        
        self.users = users;
        [self.tableView reloadData];
    }
    
}


@end
