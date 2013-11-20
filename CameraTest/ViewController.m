//
//  ViewController.m
//  CameraTest
//
//  Created by Bart on 13/11/13.
//  Copyright (c) 2013 iDA MediaFoundry. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "ViewController.h"
#import "IMFOperation.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, IMFOperationDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray *labelsArr;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.labelsArr = [NSMutableArray arrayWithCapacity:1];
    for (int i=0; i<=40; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(190, 190, 30, 30)];
        label.text=[NSString stringWithFormat:@"%d",i];
        [self.labelsArr addObject:label];
        [self.view addSubview:label];
    }
}

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.name = @"imfqueue";
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

- (IBAction)cameraBtnTap:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        self.imagePicker.allowsEditing = NO;
        
        [self presentViewController:self.imagePicker animated:NO completion:nil];
        
    } else {
        // TODO: Show alert
    }
}

- (IBAction)gcdBtnTap:(id)sender {
    for (int i=0; i<40; i++) {
        IMFOperation *operation = [[IMFOperation alloc] init];
        [self.operationQueue addOperation:operation];
    }
}

- (void)operationDidFinish:(IMFOperation *)operation {
    NSLog(@"Operation did finish!");
}

#pragma mark -
#pragma mark Reason 2
- (IBAction)blockEnumeration:(id)sender {
    [self.labelsArr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel * label = (UILabel*)obj;
        label.text=[NSString stringWithFormat:@"%d",idx+2];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;
}

@end
