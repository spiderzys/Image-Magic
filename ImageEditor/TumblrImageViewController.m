//
//  TumblrImageViewController.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-11-02.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "TumblrImageViewController.h"
#import "TumblrImageCollectionViewCell.h"

@interface TumblrImageViewController (){
    NSMutableArray *imageArray;
    NSCache *imageCache;
    APICommunicator *apiCommunicator;
    int numOfLoadedPages;
    NSString *blogName;
}

@end

@implementation TumblrImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageCache = [NSCache new];
    imageArray = [NSMutableArray new];
    apiCommunicator = [APICommunicator new];
    apiCommunicator.delegate = self;
    [_imageCollectionView registerNib:[UINib nibWithNibName:@"TumblrImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"tumblr"];
    numOfLoadedPages = 0;
    
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

- (void)searchBlog:(NSString*)blog InPage:(int)page{
    [apiCommunicator requestDataFromTumblrBlog:blog InPage:page];
}



- (void)loadImagesFromBlog:(NSString*)blog{
    [imageCache removeAllObjects];
    numOfLoadedPages = 1;
    [self searchBlog:blog InPage:numOfLoadedPages];
}

#pragma SearchBar delegate method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    blogName = [searchBar text];
    [searchBar resignFirstResponder];
    searchBar.userInteractionEnabled = NO;
    
    [self loadImagesFromBlog:blogName];
    
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma APICommunicatorDelegate

- (void)didGetPhotoUrls:(NSMutableArray *)photoUrlArray{
    _blogSearchBar.userInteractionEnabled = YES;
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



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(44,44);
}


#pragma scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -100){
        [self loadImagesFromBlog:blogName];
    }
    
    else if(scrollView.contentOffset.y > imageArray.count) {
        [self searchBlog:blogName InPage:++numOfLoadedPages];
    }
    
}

@end
