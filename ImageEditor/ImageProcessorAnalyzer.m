//
//  ImageProcessorAnalyzer.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-11-07.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "ImageProcessorAnalyzer.h"
#import "GPUImage.h"

@interface ImageProcessorAnalyzer (){
    
    NSArray *processorArray;
}

@end

@implementation ImageProcessorAnalyzer




#pragma Magic Plist Analyze

- (NSInteger)getNumOfProcessorCategories{
    return processorArray.count;
}

- (NSDictionary*)getCategoryOfIndex:(NSInteger)category{
    return processorArray[category];
}

- (NSString*)getNameOfProcessorCategoryOfIndex:(NSInteger)category{
    NSDictionary *processorsDictionary = [self getCategoryOfIndex:category];
    return [processorsDictionary objectForKey:@"CategoryName"];
}

- (NSArray*)getProcessorsInCategory:(NSInteger)category {
    NSDictionary *processorsDictionary = [self getCategoryOfIndex:category];
    return [processorsDictionary objectForKey:@"Sub"];
}

- (NSInteger)getNumOfProcessorsInCategory:(NSInteger)category{
    NSArray *processors = [self getProcessorsInCategory:category];
    
    return processors.count;
}

- (NSDictionary*)getProcessorOfIndex:(NSInteger)index inCategory:(NSInteger)category{
    NSArray *processors = [self getProcessorsInCategory:category];
    return processors[index];
}

- (UIImage*)processImage:(UIImage*)image WithArgument:(float)argument ProcessorCategory:(NSInteger)category index:(NSInteger)index{
 
    NSDictionary *processor = [self getProcessorOfIndex:index inCategory:category];
    NSString *filterName = [processor objectForKey:@"FilterClassName"];
    
    
    GPUImageFilter *filter = [[NSClassFromString(filterName) alloc]init];
    NSString *argumentName = [processor objectForKey:@"ArgumentName"];
    if(argumentName != nil){
       [filter setValue:@(argument) forKey:argumentName];
    }
   
    return [filter imageByFilteringImage:image];
    

}

- (UIImage*)resizeImage:(UIImage*)image toSize:(CGSize)size{
    
    // resample image
    GPUImageLanczosResamplingFilter *filter = [[GPUImageLanczosResamplingFilter alloc]init];
    [filter forceProcessingAtSize:size];
    return [filter imageByFilteringImage:image];
    
}





#pragma Singleton
+(ImageProcessorAnalyzer*)sharedInstance{
    
    // sharedInstance is the only object for access
    static ImageProcessorAnalyzer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageProcessorAnalyzer alloc] init];
        
        
    });
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    
    // alloc init method  override to avoid new object init
    static ImageProcessorAnalyzer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
        NSURL* url = [[NSBundle mainBundle] URLForResource: @"Magic" withExtension: @"plist"];
        sharedInstance->processorArray = [NSArray arrayWithContentsOfURL: url];
        
        
    });
    return sharedInstance;
}





@end


