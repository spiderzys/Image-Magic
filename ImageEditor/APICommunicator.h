//
//  APICommunicator.h
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,API){
    TUMBLR = 1
};

@protocol APICommunicatorDelegate <NSObject>  // the delegate should know what to do after request
- (void)didGetPhotoUrls:(NSMutableArray*)photoUrlArray;
@end


@interface APICommunicator : NSObject

@property (nonatomic, weak) id<APICommunicatorDelegate> delegate; // only view controller can be the delegate

//+ (APICommunicator*)sharedInstance;

//- (void)requestPhotoDataFromSource:(enum API)source;

- (void)requestDataFromTumblrBlog:(NSString*)blog InPage:(int)page;


@end
