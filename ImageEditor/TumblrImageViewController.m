//
//  TumblrImageViewController.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-11-02.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "TumblrImageViewController.h"

@interface TumblrImageViewController (){
    NSArray *imageArray;
    APICommunicator *apiCommunicator;
}

@end

@implementation TumblrImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    apiCommunicator = [APICommunicator new];
    apiCommunicator.delegate = self;
    [_imageCollectionView registerNib:[UINib nibWithNibName:@"TumblrImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"tumblr"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (TumblrImageViewController*)sharedInstance{
    
    // sharedInstance is the only object for access
    static TumblrImageViewController *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TumblrImageViewController alloc] initWithNibName:@"TumblrImageViewController" bundle:nil];
        
    });
    return sharedInstance;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchBlog:(NSString*)blog{
    
    [apiCommunicator requestDataFromTumblrBlog:blog];
}


#pragma SearchBar delegate method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString* keywords = [searchBar text];
    [searchBar resignFirstResponder];
    searchBar.userInteractionEnabled = NO;
    [self searchBlog:keywords];
    searchBar.userInteractionEnabled = YES;
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


#pragma APICommunicatorDelegate

- (void)didFinishAccessData:(NSData*)data{
    
}


#pragma Image ColletionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


#pragma Image ColletionView data delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
