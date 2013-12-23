//
//  ViewController.m
//  StoreSearch
//
//  Created by Junnebai on 13-12-23.
//  Copyright (c) 2013年 GirliOS. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"

static NSString *const SearchResultCellIdentifier = @"SearchResultCell";
static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

@interface SearchViewController ()
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation SearchViewController

{
    NSMutableArray *searchResults;
}

//@synthesize searchBar;
//@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    self.tableView.rowHeight = 80;
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResults == nil) {
        return 0;
    } else if ([searchResults count] == 0){
        return 1;
    } else {
        return [searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    
    if ([searchResults count] == 0){
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
    } else {
        SearchResult *searchResult = [searchResults objectAtIndex:indexPath.row];
        cell.nameLabel.text = searchResult.name;
        cell.artistNameLabel.text = searchResult.artistName;
        return cell;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    searchResults = [NSMutableArray arrayWithCapacity:10];
    
    if (![searchBar.text isEqualToString:@"justin bieber"]){
        for (int i = 0; i < 3; i++) {
            SearchResult *searchResult = [[SearchResult alloc] init];
            searchResult.name = [NSString stringWithFormat:@"Fake Result %d for",i];
            searchResult.artistName = searchBar.text;
            [searchResults addObject:searchResult];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([searchResults count]) {
        return nil;
    } else {
        return indexPath;
    }
}
@end
