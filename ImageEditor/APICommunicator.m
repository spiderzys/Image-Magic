//
//  APICommunicator.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "APICommunicator.h"
#import "NXOauth2.h"
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

- (void)authorize{
    NSArray *accounts = [[NXOAuth2AccountStore sharedStore]accountsWithAccountType:@"Instagram"];
    NXOAuth2Account *currentAccount = [accounts objectAtIndex:0];
    NSString *url = [@"https://api.instagram.com/v1/users/self/?access_token=" stringByAppendingString:currentAccount.accessToken.accessToken];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error){
            NSLog(@"error: %@",error.description);
        }
        NSError *parserError;
        id pkg = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parserError];
        if(pkg){
            NSLog(@"parser error: %@",parserError.description);
        }
        NSString *username = pkg[@"data"][@"username"];
        NSLog(@"%@",username);
        
    }
      ]resume];
}

@end
