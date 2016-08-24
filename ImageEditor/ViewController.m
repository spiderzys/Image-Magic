//
//  ViewController.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [PhotoRequester sharedInstance].delegate = self;
 
    

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getPhotoViaPhotoLibrary:(UIButton *)sender {
    
    
    
}

- (void)didFinishRequestPhoto:(UIImage*)photo{
    
    _backgroundImageView.image = photo;
}

- (IBAction)GoButtonTouched:(UIButton *)sender {
    // when user specified the photo
    
}


@end
