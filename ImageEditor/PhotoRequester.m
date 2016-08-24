//
//  PhotoRequester.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "PhotoRequester.h"
#import "APICommunicator.h"
@implementation PhotoRequester




- (UIImage*)requestPhotoViaSource:(enum photoSource)source{
    
    switch (source) {
        case photoLibrary:
            return [self requestPhotoViaPhotoLibrary];
        case camera:
            return [self requestPhotoViaCamera];
        default:
            return [self requestPhotoViaInstagram];
    }
  
}

- (UIImage*)requestPhotoViaPhotoLibrary{
    if (_delegate != nil){
        
    }
    
    return nil;
}

-(UIImage*)requestPhotoViaCamera{
    
    
    return nil;
}

-(UIImage*)requestPhotoViaInstagram{
    
    
    return nil;
}

+(PhotoRequester*)sharedInstance{
    static PhotoRequester *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PhotoRequester alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static PhotoRequester *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

@end
