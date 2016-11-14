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

#define MAX_RESOLUTION 5000000

@interface ImageEditorViewController (){
    
    UIImage *originalImage;
    UIImage *processedImage;
    UIImage *previousImage;
    UIImage *resizedOriginalImage;
    UIDocumentInteractionController *documentInteractionController;
    NSString* reuseIdentifier;
    NSIndexPath *selectedCellIndexPath;
    NSString *deviceType;
    float sizeFactor;
    
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
    
    // prepare for this view controller
    
    
    
    
    deviceType = [UIDevice currentDevice].model;  // determine device type
    if([deviceType isEqualToString:@"iPhone"]){
        sizeFactor = 3.5;
    }
    else{
        sizeFactor = 2.8;
    }
    
    reuseIdentifier = @"sub";
    [_subProcessorCollectionView registerNib:[UINib nibWithNibName:@"SubProcessorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    documentInteractionController.delegate = self;
    documentInteractionController = [UIDocumentInteractionController new];
    
   
    // Do any additional setup after loading the view from its nib.
}

- (CGSize)imageSize{
    CGFloat boundsWidth  = [_processedImageView bounds].size.width,
    boundsHeight = [_processedImageView bounds].size.height;
    
    CGSize  imageSize  = [_processedImageView.image size];
    CGFloat imageRatio = imageSize.width / imageSize.height;
    CGFloat viewRatio  = boundsWidth / boundsHeight;
    
    if(imageRatio < viewRatio) {
        CGFloat scale = boundsHeight / imageSize.height;
        CGFloat width = scale * imageSize.width;
        if (width *sizeFactor > originalImage.size.width){
            return CGSizeMake(width, boundsHeight);
        }
            
        return CGSizeMake(width * sizeFactor, boundsHeight * sizeFactor);
       
    }
    
    CGFloat scale = boundsWidth / imageSize.width;
    CGFloat height = scale * imageSize.height;
    
    if(boundsWidth *sizeFactor > originalImage.size.width){
        return CGSizeMake(boundsWidth, height);
    }
    
    return CGSizeMake(boundsWidth*sizeFactor, height*sizeFactor);
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self loadImage];
    
    float scale = sqrtf(originalImage.size.width * originalImage.size.height /MAX_RESOLUTION);
    
    if (scale < 1){
        resizedOriginalImage = originalImage;
    }
    else{
       
        
        resizedOriginalImage = [[ImageProcessorAnalyzer sharedInstance]resizeImage:originalImage toSize: CGSizeMake(floor(originalImage.size.width/scale), floor(originalImage.size.height/scale))];
        _processedImageView.image = resizedOriginalImage;
    }
    /*
    imageSizeInView = [self imageSize];
    resizedOriginalImage = [[ImageProcessorAnalyzer sharedInstance]resizeImage:originalImage toSize:imageSizeInView];
    _processedImageView.image = resizedOriginalImage;
    */
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

- (void)loadImage{
    
   
    [_loadingImageActivityView startAnimating];
    if(resizedOriginalImage){
        
        _processedImageView.image = resizedOriginalImage;
    }
    else{
       _processedImageView.image = originalImage;
    }
    
    processedImage = _processedImageView.image;
    
    [_loadingImageActivityView stopAnimating];
}


- (IBAction)resetButtonTouched:(id)sender {
    // reset the image
    
    [self loadImage];
    selectedCellIndexPath = nil;
    _sliderLabel.hidden = YES;
    _processorArgumentSlider.hidden = YES;
    
}



- (IBAction)actionButtonTouched:(id)sender {
    
    // upload action
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths lastObject] : nil;
    NSString *imagePath = [basePath stringByAppendingPathComponent:@"image.ig"];

    [UIImagePNGRepresentation(_processedImageView.image) writeToFile:imagePath atomically:YES];
    documentInteractionController.URL = [NSURL fileURLWithPath:imagePath];
    documentInteractionController.delegate = self;
    
    [documentInteractionController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
    
    
   

}


- (IBAction)saveButtonTouched:(id)sender {
    
    NSLog(@"%@",_processedImageView.image);
   // UIImageWriteToSavedPhotosAlbum([[ImageProcessorAnalyzer sharedInstance]resizeImage:_processedImageView.image toSize:originalImage.size], nil, nil, nil);
    UIImageWriteToSavedPhotosAlbum(_processedImageView.image, nil, nil, nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"saved in album" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        
    }];

    
}



- (IBAction)doneButtonTouched:(id)sender {
    
    // back to the root view controller
    
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



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel *label = [[UILabel alloc]init];
    if (label){
        
        if([deviceType isEqualToString:@"iPhone"]){
             [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        }
        else{
             [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        }
       
        
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [[ImageProcessorAnalyzer sharedInstance]getNameOfProcessorCategoryOfIndex:row];
        label.textColor = [UIColor whiteColor];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    
    if(selectedCellIndexPath != nil & selectedCellIndexPath.section != row){ // selected a different category row, then reload the whole picker part
        selectedCellIndexPath = nil;
        _processorArgumentSlider.hidden = YES;
        _sliderLabel.hidden = YES;
        [_subProcessorCollectionView reloadData];
    }
    
    else if (selectedCellIndexPath == nil){
        [_subProcessorCollectionView reloadData];
    }
    
}

- (NSInteger)pickerViewSelectedProcessorCategory{
    return [_processorCategoryPickerView selectedRowInComponent:0];
}

#pragma UIColletionView data source and delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[ImageProcessorAnalyzer sharedInstance]getNumOfProcessorsInCategory:[self pickerViewSelectedProcessorCategory]];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SubProcessorCollectionViewCell *cell = (SubProcessorCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *processor = [[ImageProcessorAnalyzer sharedInstance]getProcessorOfIndex:indexPath.row inCategory:[self pickerViewSelectedProcessorCategory]];
    cell.subProcessorLabel.text = [processor objectForKey:@"FilterName"];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (selectedCellIndexPath){
        
        // it indicates that the selected cell appear again
        if (selectedCellIndexPath.row == indexPath.row & selectedCellIndexPath.section == [self pickerViewSelectedProcessorCategory]){
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if([deviceType isEqualToString:@"iPhone"]){
        return CGSizeMake(66, 50);
    }
    else{
        return CGSizeMake(93, 68);
    }
    
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]){
       
        // show tip for fresh user
        [[NSUserDefaults standardUserDefaults]setObject:@(true) forKey:@"first"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"By selecting the same processor again, you can revert this image process" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
       
        }];
    }
    
  
    if ((selectedCellIndexPath != nil) & (selectedCellIndexPath.row == indexPath.row) & (selectedCellIndexPath.section == [self pickerViewSelectedProcessorCategory])){
        // indicate the user select the same processor, so revert its effect
        _processedImageView.image = processedImage;
        [self setArgumentSlider];
    }
        
    else {
        // load the slider and run the processor
        processedImage = _processedImageView.image;
        [self setBackgroundForSelectedCell:indexPath];
        [self setArgumentSlider];
        [self processImageWithSelectedProcessor];
    }
   
    
}


- (void)setArgumentSlider{
    
    
    
    NSDictionary *processor = [[ImageProcessorAnalyzer sharedInstance]getProcessorOfIndex:selectedCellIndexPath.row inCategory:selectedCellIndexPath.section];
    
    if ([processor objectForKey:@"Default"]){
        // if the processor needs argument, load the slider
        _processorArgumentSlider.maximumValue = [[processor objectForKey:@"Max"]floatValue];
        _processorArgumentSlider.minimumValue = [[processor objectForKey:@"Min"]floatValue];
        _processorArgumentSlider.value = [[processor objectForKey:@"Default"]floatValue];
        _processorArgumentSlider.hidden = NO;
        _sliderLabel.text = [processor objectForKey:@"ArgumentName"];
    }
    
    else {
        // else hide the slider
        _processorArgumentSlider.hidden = YES;
    }
    
    _sliderLabel.hidden = _processorArgumentSlider.hidden;
}

- (void)setBackgroundForSelectedCell:(NSIndexPath*)indexPath{
    
    if (selectedCellIndexPath!=nil & selectedCellIndexPath.section == [self pickerViewSelectedProcessorCategory]) {
        NSIndexPath *oldPath = [NSIndexPath indexPathForRow:selectedCellIndexPath.row inSection:0];
        SubProcessorCollectionViewCell *oldCell = (SubProcessorCollectionViewCell*)[_subProcessorCollectionView cellForItemAtIndexPath:oldPath];
      
        // revert the hightlight of the previous cell
        if (oldCell) {
            
            oldCell.contentView.backgroundColor = [UIColor whiteColor];
        }
        else {
            [_subProcessorCollectionView reloadItemsAtIndexPaths: @[oldPath]];

        }
    }
    SubProcessorCollectionViewCell *cell = (SubProcessorCollectionViewCell*)[_subProcessorCollectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    selectedCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:[self pickerViewSelectedProcessorCategory]];
}

- (void)processImageWithSelectedProcessor{
    dispatch_async(dispatch_get_main_queue(), ^{
       _processedImageView.image = [[ImageProcessorAnalyzer sharedInstance]processImage:processedImage WithArgument: _processorArgumentSlider.value ProcessorCategory:selectedCellIndexPath.section index:selectedCellIndexPath.row];
    });
    
    
    
}

- (IBAction)argumentValueChanged:(id)sender {
    [self processImageWithSelectedProcessor];
}




@end
