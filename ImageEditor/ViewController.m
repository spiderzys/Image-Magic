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
    
    [_bannderView setRootViewController:self];
    //_bannderView.adUnitID = @"ca-app-pub-1134676718735499~2657091162";
    GADRequest *request = [GADRequest request];
    [_bannderView loadRequest:request];
    request.testDevices = @[ kGADSimulatorID ];
    
    [PhotoRequester sharedInstance].delegate = self;
    
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
- (IBAction)TumblrButtonClicked:(UIButton *)sender {
    [[PhotoRequester sharedInstance] requestPhotoViaSource:tumblr];
}

- (void)didFinishRequestPhoto:(UIImage*)photo{
    
    _backgroundImageView.image = photo;
    
}

- (IBAction)GoButtonTouched:(UIButton *)sender {
    // when user specified the photo
    
}


@end
