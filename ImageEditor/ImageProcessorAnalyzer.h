//
//  ImageProcessorAnalyzer.h
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-11-07.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageProcessorAnalyzer : NSObject


+ (ImageProcessorAnalyzer*)sharedInstance;

- (NSInteger)getNumOfProcessorCategories;

- (NSDictionary*)getCategoryOfIndex:(NSInteger)category;


- (NSString*)getNameOfProcessorCategoryOfIndex:(NSInteger)category;

- (NSArray*)getProcessorsInCategory:(NSInteger)category;

- (NSInteger)getNumOfProcessorsInCategory:(NSInteger)category;

- (NSDictionary*)getProcessorOfIndex:(NSInteger)index inCategory:(NSInteger)category;

- (UIImage*)processImage:(UIImage*)image WithArgument:(float)argument ProcessorCategory:(NSInteger)category index:(NSInteger)index;

@end
