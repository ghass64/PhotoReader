//
//  ViewController.m
//  PhotoReader
//
//  Created by GALMarei on 8/26/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    MRProgressOverlayView *progressView;

    UIImage * imageReturned;
    NSString * returnedText;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the navigation bar buttons
    [self prepareNavigationBarButtons];
    
}

#pragma mark - navigation buttons
-(void)prepareNavigationBarButtons
{
    UIBarButtonItem *resetBtn = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetData:)];
    
    UIBarButtonItem *transferBtn = [[UIBarButtonItem alloc] initWithTitle:@"Transfer" style:UIBarButtonItemStylePlain target:self action:@selector(transferData:)];

    
    self.navigationItem.rightBarButtonItem = transferBtn;
    self.navigationItem.leftBarButtonItem = resetBtn;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions
-(void)resetData:(UIButton*)sender
{
    [self hideLoadingMode];
    [self.imageView setBackgroundImage:[UIImage imageNamed:@"wish_image.png"] forState:UIControlStateNormal];
    self.returnedTextView.text = @"";
    self.label.hidden = YES;
}


-(void)transferData:(UIButton*)sender
{
    [self showLoadingMode];
    dispatch_queue_t fetchMarketQueue = dispatch_queue_create("Fetch_instagram", NULL);
    dispatch_async(fetchMarketQueue, ^{
        
        Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
        //language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory.
        //eng.traineddata is in your "tessdata" folder.
        
        [tesseract setImage:imageReturned]; //image to check
        [tesseract recognize];
        
        NSLog(@"Text : %@", [tesseract recognizedText]);
        returnedText = [tesseract recognizedText];
        [tesseract clear];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.label.hidden = NO;
            self.returnedTextView.text = returnedText;
            [self hideLoadingMode];
            
        });
    });
    
    
}

- (IBAction)pickImageInvoked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No camera availiable." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // ... task 1 on main thread
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    // store image
    imageReturned = chosenImage;
    [self.imageView setBackgroundImage:chosenImage forState:UIControlStateNormal];
    [self.imageView.imageView setContentMode:UIViewContentModeScaleAspectFill];
    NSLog(@"Pic returned");
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - loader animating
-(void)showLoadingMode {
    progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = @"Wait for the magic...";
    progressView.tintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    [progressView show:YES];
}


-(void)hideLoadingMode {
    [progressView dismiss:YES];
    progressView = nil;
}


@end
