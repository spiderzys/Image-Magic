//
//  APICommunicator.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "APICommunicator.h"

@interface APICommunicator(){
    
}

@end

@implementation APICommunicator

// for connecting the API, currently i.e., Instagram

/*
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

- (void)requestPhotoDataFromSource:(enum API)source{
    switch (source) {
        case TUMBLR:
            
            break;
            
        default:
            break;
    }
}
*/

- (void)requestDataFromTumblrBlog:(NSString *)blog InPage:(int)page{
    NSString *blogRequestString = [NSString stringWithFormat:@"https://api.tumblr.com/v2/blog/%@.tumblr.com/posts/photo?api_key=WIAUCCGLAhm3p50rx4F0os5PIb0uUu8JepZToWdTc9cExhs2gW&page=%d",blog,page];
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:blogRequestString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self parseTumblrData:data];
    }]resume];

    
}

- (void)parseTumblrData:(NSData*)data{
    NSError *parserError;
    NSMutableArray *photoUrlArray = [NSMutableArray new];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parserError];
    NSLog(@"%@",dic);
    if(!data){
        NSLog(@"no data");
    }
    else if(parserError){
        NSLog(@"%@",parserError);
    }
    else{
        NSDictionary *response = [dic objectForKey:@"response"];
        NSArray *posts = [response objectForKey:@"posts"];
        
        for (NSDictionary* post in posts){
            NSArray *photos = [post objectForKey:@"photos"];
            for (NSDictionary *photo in photos){
                NSDictionary *originalPhoto = [photo objectForKey:@"original_size"];
                NSString* photoUrl = [originalPhoto objectForKey:@"url"];
                [photoUrlArray addObject:[NSURL URLWithString:photoUrl]];
            }
        }
        
    }
    [_delegate didGetPhotoUrls:photoUrlArray];
}


@end
