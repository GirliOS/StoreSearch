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
#import "AFJSONRequestOperation.h"

static NSString *const SearchResultCellIdentifier = @"SearchResultCell";
static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";
static NSString *const LoadingCellIdentifier = @"LoadingCell";

@interface SearchViewController ()
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation SearchViewController

{
    NSMutableArray *searchResults;
    BOOL isLoading;
    NSOperationQueue *queue;
}

//@synthesize searchBar;
//@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    self.tableView.rowHeight = 80;
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    [self.searchBar becomeFirstResponder];
    
    cellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNetworkError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Whoops..."
                              message:@"There was an error reading from the iTunes Store. Please try again."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
}

- (SearchResult *)parseTrack:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = [dictionary objectForKey:@"trackName"];
    searchResult.artistName = [dictionary objectForKey:@"artistName"];
    searchResult.artworkURL60 = [dictionary objectForKey:@"artworkUrl60"];
    searchResult.artworkURL100 = [dictionary objectForKey:@"artworkUrl100"];
    searchResult.storeURL = [dictionary objectForKey:@"trackViewUrl"];
    searchResult.kind = [dictionary objectForKey:@"kind"];
    searchResult.price = [dictionary objectForKey:@"trackPrice"];
    searchResult.currency = [dictionary objectForKey:@"currency"];
    searchResult.genre = [dictionary objectForKey:@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseAudioBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = [dictionary objectForKey:@"collectionName"];
    searchResult.artistName = [dictionary objectForKey:@"artistName"];
    searchResult.artworkURL60 = [dictionary objectForKey:@"artworkUrl60"];
    searchResult.artworkURL100 = [dictionary objectForKey:@"artworkUrl100"];
    searchResult.storeURL = [dictionary objectForKey:@"collectionViewUrl"];
    searchResult.kind = @"audiobook";
    searchResult.price = [dictionary objectForKey:@"collectionPrice"];
    searchResult.currency = [dictionary objectForKey:@"currency"];
    searchResult.genre = [dictionary objectForKey:@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseSoftware:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = [dictionary objectForKey:@"trackName"];
    searchResult.artistName = [dictionary objectForKey:@"artistName"];
    searchResult.artworkURL60 = [dictionary objectForKey:@"artworkUrl60"];
    searchResult.artworkURL100 = [dictionary objectForKey:@"artworkUrl100"];
    searchResult.storeURL = [dictionary objectForKey:@"trackViewUrl"];
    searchResult.kind = [dictionary objectForKey:@"kind"];
    searchResult.price = [dictionary objectForKey:@"price"];
    searchResult.currency = [dictionary objectForKey:@"currency"];
    searchResult.genre = [dictionary objectForKey:@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseEBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = [dictionary objectForKey:@"trackName"];
    searchResult.artistName = [dictionary objectForKey:@"artistName"];
    searchResult.artworkURL60 = [dictionary objectForKey:@"artworkUrl60"];
    searchResult.artworkURL100 = [dictionary objectForKey:@"artworkUrl100"];
    searchResult.storeURL = [dictionary objectForKey:@"trackViewUrl"];
    searchResult.kind = [dictionary objectForKey:@"kind"];
    searchResult.price = [dictionary objectForKey:@"price"];
    searchResult.currency = [dictionary objectForKey:@"currency"];
    searchResult.genre = [(NSArray *)[dictionary objectForKey:@"genres"] componentsJoinedByString:@", "];
    return searchResult;
}

- (void)parseDictionary:(NSDictionary *)dictionary
{
    NSArray *array = [dictionary objectForKey:@"results"];
    if (array == nil) {
        NSLog(@"Expected 'result' array");
        return;
    }
    for (NSDictionary *resultDict in array) {
        SearchResult *searchResult;
        
        NSString *wrapperType = [resultDict objectForKey:@"wrapperType"];
//        NSString *kind = [resultDict objectForKey:@"kind"];
        
        if ([wrapperType isEqualToString:@"track"]) {
            searchResult = [self parseTrack:resultDict];
        } else if ([wrapperType isEqualToString:@"audiobook"]){
            searchResult = [self parseAudioBook:resultDict];
        } else if ([wrapperType isEqualToString:@"software"]){
            searchResult = [self parseSoftware:resultDict];
        } else if ([wrapperType isEqualToString:@"ebook"]){
            searchResult = [self parseEBook:resultDict];
        }
        if (searchResult != nil) {
            [searchResults addObject:searchResult];
        }
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLoading){
        return 1;
    } else if (searchResults == nil) {
        return 0;
    } else if ([searchResults count] == 0){
        return 1;
    } else {
        return [searchResults count];
    }
}

- (NSString *)kindForDisplay:(NSString *)kind
{
    if ([kind isEqualToString:@"album"]) {
        return @"Album";
    } else if ([kind isEqualToString:@"audiobook"]) {
        return @"Audio Book";
    } else if ([kind isEqualToString:@"book"]) {
        return @"Book";
    } else if ([kind isEqualToString:@"ebook"]) {
        return @"E-Book";
    } else if ([kind isEqualToString:@"feature-movie"]) {
        return @"Movie";
    } else if ([kind isEqualToString:@"music-video"]) {
        return @"Music Video";
    } else if ([kind isEqualToString:@"podcast"]) {
        return @"Podcast";
    } else if ([kind isEqualToString:@"software"]) {
        return @"App";
    } else if ([kind isEqualToString:@"song"]) {
        return @"Song";
    } else if ([kind isEqualToString:@"tv-episode"]) {
        return @"TV Episode";
    } else {
        return kind;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isLoading){
        return [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
    } else if ([searchResults count] == 0){
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
    } else {
        SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier];
                
        SearchResult *searchResult = [searchResults objectAtIndex:indexPath.row];
        cell.nameLabel.text = searchResult.name;
        NSString *artistName = searchResult.artistName;
        if (artistName == nil) {
            artistName = @"Unknown";
        }
        
        NSString *kind = [self kindForDisplay:searchResult.kind];
        cell.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", artistName, kind];
        return cell;
    }
}

#pragma mark - UISearchBarDelegate

- (NSURL *)urlWithSearchText:(NSString *)searchText
{
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&limit=200", escapedSearchText];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] > 0) {
        [searchBar resignFirstResponder];
        
        [queue cancelAllOperations];
        
        isLoading = YES;
        [self.tableView reloadData];
        
        searchResults = [NSMutableArray arrayWithCapacity:10];
        
        NSURL *url = [self urlWithSearchText:searchBar.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation
            JSONRequestOperationWithRequest:request
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                 [self parseDictionary:JSON];
                 [searchResults sortUsingSelector:@selector(compareName:)];
                 
                 isLoading = NO;
                 [self.tableView reloadData];
             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                 
                 [self showNetworkError];
                 isLoading = NO;
                 [self.tableView reloadData];
             }];
        operation.acceptableContentTypes = [NSSet setWithObjects:@"appliction/json", @"text/json", @"text/javascript", nil];
        [queue addOperation:operation];
    }
} 

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([searchResults count] == 0 || isLoading) {
        return nil;
    } else {
        return indexPath;
    }
}
@end
