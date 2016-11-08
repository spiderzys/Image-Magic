//
//  ImageEditorViewController.h
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-11-05.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageEditorViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *processedImageView;

@property (weak, nonatomic) IBOutlet UIPickerView *processorCategoryPickerView;

@property (weak, nonatomic) IBOutlet UICollectionView *subProcessorCollectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rawImage:(UIImage*)rawImage;

@end
