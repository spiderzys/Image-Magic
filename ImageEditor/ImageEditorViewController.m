//
//  ImageEditorViewController.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-11-05.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "ImageEditorViewController.h"
#import "SubProcessorCollectionViewCell.h"
#import "ImageProcessorAnalyzer.h"

@interface ImageEditorViewController (){
    
    UIImage *originalImage;
    UIDocumentInteractionController *documentInteractionController;
    NSString* reuseIdentifier;
  //  NSInteger *selectedCategory;
 //   NSInteger *selectedCell;
}

@end


@implementation ImageEditorViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rawImage:(UIImage*)rawImage{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){

        originalImage = rawImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  selectedCell = 0;
  //  selectedCategory = 0;
    reuseIdentifier = @"sub";
    [_subProcessorCollectionView registerNib:[UINib nibWithNibName:@"SubProcessorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    documentInteractionController.delegate = self;
    documentInteractionController = [UIDocumentInteractionController new];
    _processedImageView.image = [originalImage copy];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)cancelButtonTouched:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetButtonTouched:(id)sender {
    
    _processedImageView.image = [originalImage copy];
}

- (IBAction)actionButtonTouched:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths lastObject] : nil;
    NSString *imagePath = [basePath stringByAppendingPathComponent:@"image.ig"];

    [UIImagePNGRepresentation(_processedImageView.image) writeToFile:imagePath atomically:YES];
    documentInteractionController.URL = [NSURL fileURLWithPath:imagePath];
    documentInteractionController.delegate = self;
    
    [documentInteractionController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
    
    
   

}
- (IBAction)saveButtonTouched:(id)sender {
    
    
    
    UIImageWriteToSavedPhotosAlbum(_processedImageView.image, nil, nil, nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"image saved in Album" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES completion:^{
        [NSTimer scheduledTimerWithTimeInterval:0.6 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}



- (IBAction)doneButtonTouched:(id)sender {
    
    originalImage = _processedImageView.image;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}




#pragma UIPickerView data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    return [[ImageProcessorAnalyzer sharedInstance] getNumOfProcessorCategories];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    
    return [[ImageProcessorAnalyzer sharedInstance]getNameOfProcessorCategoryOfIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    
    [_subProcessorCollectionView reloadData];
    
}

- (NSInteger)pickerViewSelectedProcessorCategory{
    return [_processorCategoryPickerView selectedRowInComponent:0];
}

#pragma UIColletionView data source and delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return [[ImageProcessorAnalyzer sharedInstance]getNumOfProcessorsInCategory:[self pickerViewSelectedProcessorCategory]];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SubProcessorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *processor = [[ImageProcessorAnalyzer sharedInstance]getProcessorOfIndex:indexPath.row inCategory:[self pickerViewSelectedProcessorCategory]];
    cell.subProcessorLabel.text = [processor objectForKey:@"SubName"];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SubProcessorCollectionViewCell *cell = (SubProcessorCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.baseView.backgroundColor = [UIColor redColor];
    
}



@end
