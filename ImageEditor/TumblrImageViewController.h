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
- (void)didFinishPickImageView:(UIImage*)image;
@end

@interface TumblrImageViewController : UIViewController <APICommunicatorDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
+ (TumblrImageViewController*)sharedInstance;


@end
