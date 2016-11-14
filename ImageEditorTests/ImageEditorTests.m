//
//  ImageEditorTests.m
//  ImageEditorTests
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ImageProcessorAnalyzer.h"

@interface ImageEditorTests : XCTestCase {
    ImageProcessorAnalyzer *analyzer;
}

@end

@implementation ImageEditorTests

- (void)setUp {
    [super setUp];
    analyzer = [ImageProcessorAnalyzer sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testAnalyzer {
    /*
     - (NSInteger)getNumOfProcessorCategories;
     
     
     - (NSString*)getNameOfProcessorCategoryOfIndex:(NSInteger)category;
     
    
     - (NSInteger)getNumOfProcessorsInCategory:(NSInteger)category;
     
     - (NSDictionary*)getProcessorOfIndex:(NSInteger)index inCategory:(NSInteger)category;
     
     - (UIImage*)processImage:(UIImage*)image WithArgument:(float)argument ProcessorCategory:(NSInteger)category index:(NSInteger)index;
     
     - (UIImage*)resizeImage:(UIImage*)image toSize:(CGSize)size;
     */
    
    XCTAssertNotNil(analyzer);
    CGFloat scaleWidth = 100;
    CGFloat scaleHeight = 120;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    UIImage *image = [UIImage imageNamed:@"Launch"];
    UIImage *resizedImage = [analyzer resizeImage:image toSize:scaleSize];
    XCTAssertEqual(resizedImage.size.width, scaleWidth);
    XCTAssertEqual(resizedImage.size.height, scaleHeight);
    XCTAssertNotNil([analyzer processImage:image WithArgument:0.5 ProcessorCategory:0 index:0]);
    XCTAssertNotNil([analyzer processImage:image WithArgument:1 ProcessorCategory:2 index:0]);
    
    int numOfCategories = 4;
    NSArray *categoryNameArray = @[@"Color",@"Light",@"Effect",@"Pro"];
    NSArray *numOfProcessorsArray = @[@(7),@(6),@(8),@(3)];
    
    XCTAssertNotNil(image);
    XCTAssertEqual([analyzer getNumOfProcessorCategories], numOfCategories);
    for (int i = 0; i<numOfCategories; i++){
        
        XCTAssertEqualObjects([analyzer getNameOfProcessorCategoryOfIndex:i], categoryNameArray[i]);
        XCTAssertEqual([analyzer getNumOfProcessorsInCategory:i], [numOfProcessorsArray[i] integerValue]);
        for (int j =0 ; j<[numOfProcessorsArray[i] integerValue]; j++){
            NSDictionary *filter = [analyzer getProcessorOfIndex:j inCategory:i];
            XCTAssertNotNil([filter objectForKey:@"FilterClassName"]);
            XCTAssertNotNil([filter objectForKey:@"FilterName"]);
            
        }
    }
    
    

    
}
@end
