//
//  ViewController.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "ViewController.h"
#import "ImageEditorViewController.h"


@interface ViewController(){
    PhotoRequester *requester;
}

@end


@implementation ViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _backgroundImageView.image = [UIImage imageNamed:NSLocalizedString(@"Launch", "")];
    
    [_bannderView setRootViewController:self];
    GADRequest *request = [GADRequest request];
    [_bannderView loadRequest:request];
    
    requester = [PhotoRequester sharedInstance];
    requester.delegate = self;
  
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   // [PhotoRequester sharedInstance].delegate = self;
}


- (IBAction)photoLibraryButtonClicked:(UIButton *)sender {
    
    [[PhotoRequester sharedInstance] requestPhotoViaSource:photoLibrary];
    [_loadingActivityIndicatorView startAnimating];
}
- (IBAction)cameraPhotoClicked:(UIButton *)sender {
    
    [[PhotoRequester sharedInstance] requestPhotoViaSource:camera];
    [_loadingActivityIndicatorView startAnimating];
}
- (IBAction)TumblrButtonClicked:(UIButton *)sender {
    
    [[PhotoRequester sharedInstance] requestPhotoViaSource:tumblr];
    [_loadingActivityIndicatorView startAnimating];
}

- (void)didFinishRequestPhoto:(UIImage*)photo{
    if (photo != nil){
        _backgroundImageView.image = photo;
    }
    [_loadingActivityIndicatorView stopAnimating];
}

- (IBAction)GoButtonTouched:(UIButton *)sender {
    if (_backgroundImageView.image) {
        [self presentImageEditor];
    }
    
    else {
    //    [self showNoImageAlert];
    }
    
}

- (void)presentImageEditor{
    
    ImageEditorViewController *imageEditor = [[ImageEditorViewController alloc]initWithNibName:@"ImageEditorViewController" bundle:nil rawImage:_backgroundImageView.image];
    [self presentViewController:imageEditor animated:YES completion:nil];
}




@end
