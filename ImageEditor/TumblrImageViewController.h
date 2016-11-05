//
//  TumblrImageViewController.h
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-11-02.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICommunicator.h"

@protocol TumblrImageViewControllerDelegate <NSObject>  // the delegate should know what to do after request
- (void)tumblrImagePickerController:(__kindof UIViewController *)picker didFinishPickingImage:(UIImage *)image;
@end

@interface TumblrImageViewController : UIViewController <APICommunicatorDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *blogSearchBar;
@property (weak, nonatomic) id<TumblrImageViewControllerDelegate> delegate;

+ (TumblrImageViewController*)sharedInstance;


@end
