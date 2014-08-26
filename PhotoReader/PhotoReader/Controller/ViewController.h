//
//  ViewController.h
//  PhotoReader
//
//  Created by GALMarei on 8/26/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *returnedTextView;

- (IBAction)pickImageInvoked:(id)sender;
@end
