//
//  ViewController.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "ViewController.h"
#import "ImageEditorViewController.h"



@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [_bannderView setRootViewController:self];
    GADRequest *request = [GADRequest request];
    [_bannderView loadRequest:request];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [PhotoRequester sharedInstance].delegate = self;
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
    if (_backgroundImageView.image) {
        [self presentImageEditor];
    }
    
    else {
        [self showNoImageAlert];
    }
    
}

- (void)presentImageEditor{
    
    ImageEditorViewController *imageEditor = [[ImageEditorViewController alloc]initWithNibName:@"ImageEditorViewController" bundle:nil rawImage:_backgroundImageView.image];
    [self presentViewController:imageEditor animated:YES completion:nil];
}

- (void)showNoImageAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"No image picked" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES completion:^{
        [NSTimer scheduledTimerWithTimeInterval:0.6 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}


@end
