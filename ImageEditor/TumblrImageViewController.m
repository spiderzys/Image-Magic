//
//  TumblrImageViewController.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-11-02.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//



#import "TumblrImageViewController.h"
#import "TumblrImageCollectionViewCell.h"

#define NUM_COLUMN 4 // the num of images per row



@interface TumblrImageViewController (){
    NSMutableArray *imageUrlArray;  // store the url of image
    NSCache *imageCache;  // cache the tumblr blog image
    APICommunicator *apiCommunicator;
    NSString *blogName;
    NSString *reuseIdentifier;
}

@end

@implementation TumblrImageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    imageCache = [NSCache new];
    imageUrlArray = [NSMutableArray new];
    apiCommunicator = [APICommunicator new];
    apiCommunicator.delegate = self;
    reuseIdentifier = @"tumblr";
    [_imageCollectionView registerNib:[UINib nibWithNibName:@"TumblrImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
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
    [imageUrlArray removeAllObjects];
    [imageCache removeAllObjects];

    [self searchBlog:blog InPage:1];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(imageUrlArray.count == 0){
            
            imageUrlArray = [NSMutableArray arrayWithArray:photoUrlArray];
            [_imageCollectionView reloadData];
        }
        else {
            
            [imageUrlArray addObjectsFromArray:photoUrlArray];
            
        }
        _blogSearchBar.userInteractionEnabled = YES;
        _imageCollectionView.scrollEnabled = YES;
    });
}


#pragma Image ColletionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return imageUrlArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TumblrImageCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    imageCell.tumblrImageView.image = nil;
    NSString* imageCacheKey = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
    NSData* imageData = [imageCache objectForKey:imageCacheKey];
    
    if (imageData) {
        // try to load image from cache
        imageCell.tumblrImageView.image = [UIImage imageWithData:imageData];
    }
    else {
        // load image from Url
        NSURL *imageUrl = imageUrlArray[indexPath.row];
        [[[NSURLSession sharedSession]dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            TumblrImageCollectionViewCell *updateCell = (TumblrImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if(data!=nil){
                
                [imageCache setObject:data forKey:imageCacheKey];
                if(updateCell!=nil){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        updateCell.tumblrImageView.image = [UIImage imageWithData:data];
                    });
                
                    
                }
            }
            
            
        }]resume];
        
    }
    return imageCell;
}


#pragma Image ColletionView data delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TumblrImageCollectionViewCell *imageCell = (TumblrImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image = [imageCell.tumblrImageView.image copy];
    [_delegate tumblrImagePickerController:self didFinishPickingImage:image];
}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 4 images per row
    CGFloat cellWidth = collectionView.bounds.size.width/NUM_COLUMN;
    return CGSizeMake(cellWidth, cellWidth);
}

#pragma scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // refresh the tumblr blog images
    if(scrollView.contentOffset.y < -100){
        _imageCollectionView.scrollEnabled = NO;
        [self loadImagesFromBlog:blogName];
    }
    
   
    
}

@end
