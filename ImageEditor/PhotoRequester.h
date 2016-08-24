//
//  PhotoRequester.h
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,photoSource){
    photoLibrary = 1,
    camera,
    instagram
};


@protocol PhotoRequestDelegate <NSObject>
- (void)didFinishRequestPhoto:(UIImage*)photo;
@end

@interface PhotoRequester : NSObject
@property (nonatomic, weak) id<PhotoRequestDelegate> delegate;
+(PhotoRequester*)sharedInstance;
-(UIImage*)requestPhotoViaSource:(enum photoSource)source;


@end
