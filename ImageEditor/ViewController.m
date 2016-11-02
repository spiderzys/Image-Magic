//
//  ViewController.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    [PhotoRequester sharedInstance].delegate = self;
 
    [[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:@"http://zouy34.tumblr.com/image/152627928800"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if(data) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                 _backgroundImageView.image = image;
            });
           
        }
        else{
            NSLog(@"no data");
        }
        
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)photoLibraryButtonClicked:(UIButton *)sender {
    [[PhotoRequester sharedInstance] requestPhotoViaSource:photoLibrary];
}
- (IBAction)cameraPhotoClicked:(UIButton *)sender {
    [[PhotoRequester sharedInstance] requestPhotoViaSource:camera];
}
- (IBAction)InstagramButtonClicked:(UIButton *)sender {
    [[PhotoRequester sharedInstance] requestPhotoViaSource:instagram];
}

- (void)didFinishRequestPhoto:(UIImage*)photo{

    _backgroundImageView.image = photo;
    
}

- (IBAction)GoButtonTouched:(UIButton *)sender {
    // when user specified the photo
    
}


@end
