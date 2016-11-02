//
//  APICommunicator.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "APICommunicator.h"

@implementation APICommunicator

// for connecting the API, currently i.e., Instagram

+ (APICommunicator*)sharedInstance{
    static APICommunicator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APICommunicator alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone
{
    static APICommunicator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}


#pragma api method

- (void)requestToken{
    
}



@end
