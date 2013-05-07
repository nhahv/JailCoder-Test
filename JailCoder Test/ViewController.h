//
//  ViewController.h
//  JailCoder Test
//
//  Created by Nha.HV on 4/28/13.
//  Copyright (c) 2013 Nha.HV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>


@property IBOutlet UIImageView *imageView;
@property IBOutlet UIButton *btnTakePhoto;
@property IBOutlet UIButton *captureButton;
@property IBOutlet UIView *cameraView;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property IBOutlet UIImageView *stickerVIEW;

-(IBAction)loadImage:(id)sender;
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)handleLabelSwipe:(UISwipeGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblPlace;



//Core Location;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;


@property NSMutableArray *arrayLocation;

@end
