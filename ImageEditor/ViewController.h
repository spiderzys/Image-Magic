//
//  ViewController.h
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoRequester.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController : UIViewController <PhotoRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet GADBannerView *bannderView;

@end

