//
//  ViewController.m
//  JailCoder Test
//
//  Created by Nha.HV on 4/28/13.
//  Copyright (c) 2013 Nha.HV. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SBJson.h"
#import <Social/Social.h>



@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView,btnTakePhoto,cameraView,stillImageOutput,captureButton,stickerVIEW,locationManager,currentLocation,arrayLocation, lblPlace;
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager startUpdatingLocation];
    

}

-(void) loadPlaces{
    if(currentLocation){
        NSURL * querryString = [NSURL URLWithString:[NSString stringWithFormat:@"/v2/venues/search?ll=%f,%f&oauth_token=QJ4TXYVWUZQDRMYADXHZRCBYNPQWTZQW1WTEHPMC15I1OKXW&v=20130430",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude] relativeToURL:[NSURL URLWithString:@"https://api.foursquare.com"]];
        NSLog(@"url: %@",querryString);
        
        NSURLRequest *httpsRequest = [NSURLRequest requestWithURL:querryString];
        NSData *httpResponse = [NSURLConnection sendSynchronousRequest:httpsRequest returningResponse:nil error:nil];
        NSString *jsonResponse = [[NSString alloc] initWithData:httpResponse encoding:NSUTF8StringEncoding];
        
        
        // Parsing Json with SBJSON
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        // NDiction
        NSDictionary *jsonDict = [jsonParser objectWithString:jsonResponse];
        if (jsonDict) {
            NSDictionary *response4S = [jsonDict objectForKey:@"response"];
            if (response4S) {
                 NSDictionary *venues = [response4S objectForKey:@"venues"];
                if (venues) {
                    arrayLocation = [[NSMutableArray alloc]init];
                    for (NSDictionary *v in venues) {
                        [arrayLocation addObject:[NSString stringWithFormat:@"%@",[v objectForKey:@"name"]]];
                    }
                }
            }
        }
        jsonParser = nil;
        [self redrawText];
    }
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    currentLocation = [locations lastObject];
//    NSString * locationDesc = [NSString stringWithFormat:@"Lat: %f | Long: %f | HAcc: %gm | VAcc :%gm | Altitude: %gm", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, currentLocation.horizontalAccuracy,currentLocation.verticalAccuracy,currentLocation.altitude];
    [self loadPlaces];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorString = [[NSString alloc] init];
    
    switch (error.code) {
        case kCLErrorLocationUnknown:
            errorString = @"Location unknown";
            break;
            
        case kCLErrorDenied:
            errorString = @"Access denied";
            break;
            
        case kCLErrorNetwork:
            errorString = @"No network coverage";
            break;
            
        case kCLErrorDeferredAccuracyTooLow:
            errorString = @"Accuracy is too low to display";
            break;
            
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting location"
                                                    message:errorString
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



int sIndex = 0;

-(IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender{
    NSArray * arrStickers = [[NSArray alloc] initWithObjects: @"img01.png",@"img02.png",@"img03.png",@"img04",@"img05",@"img06",@"img07",@"img08",@"img09",@"img10",@"img11",@"img12",@"img13",@"img14",@"img15",nil];
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && sIndex > 0) {
        sIndex--;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight && sIndex < arrStickers.count - 1) {
        sIndex++;
    }
    NSLog(@"Index: %@", [arrStickers objectAtIndex:sIndex]);
    stickerVIEW.image = [UIImage imageNamed:[arrStickers objectAtIndex:sIndex]];
  }
int locIndex = 0;

- (IBAction)handleLabelSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && locIndex > 0) {
        locIndex--;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight && locIndex < arrayLocation.count - 1) {
        locIndex++;
    }
    
    [self redrawText];


}

-(void) redrawText{
    lblPlace.text = [arrayLocation objectAtIndex:locIndex];
    lblPlace.font = [UIFont fontWithName:@"UVN Ban Tay" size:40];
    lblPlace.textColor = [UIColor whiteColor];
    lblPlace.shadowColor = [UIColor blackColor];
    lblPlace.shadowOffset = CGSizeMake(4, 4);
    lblPlace.textAlignment = NSTextAlignmentCenter;
}


AVCaptureSession *session;
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!session) {
        [self startCameraSession];
    }
}

-(void) startCameraSession{
    //     [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_button_take.png"] highlightImage:[UIImage imageNamed:@"tabBar_cameraButton_ready_matte.png"]];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
    
    session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
	
    CALayer * viewLayer = self.cameraView.layer;
	
	[viewLayer setMasksToBounds:YES];
    viewLayer.bounds = cameraView.bounds;
    NSLog(@"viewLayer = %@", viewLayer);
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    
    
    
    
    //    CALayer * Mashlayer = [[CALayer alloc]init];
    //    Mashlayer.frame = CGRectMake(0, 0, screenWidth, screenWidth);
	captureVideoPreviewLayer.frame = CGRectMake(0, 0, screenWidth, screenWidth);
    captureVideoPreviewLayer.bounds = CGRectMake(0, 100, screenWidth, screenWidth*3);
    
    
    //NSLog(@"Rect %@",rect.origin);
    
    
	[self.cameraView.layer addSublayer:captureVideoPreviewLayer];
    cameraView.layer.frame = CGRectMake(0, 0, screenWidth, screenWidth);
    
    //  CALayer *stickerLayer = [[CALayer alloc]init];
    //  stickerVIEW = [[UIImageView alloc]init];
    //  UIImage *initImage = [UIImage imageNamed:@"img01.png"];
    // stickerVIEW.image = initImage;
    [cameraView addSubview:stickerVIEW];
    [cameraView addSubview:lblPlace];
    
    
    
    
    
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	NSError *error = nil;
    
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
	
	
    
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVCaptureSessionPresetPhoto, nil];
    //[session setSessionPreset: AVCaptureSessionPresetPhoto];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)loadImage:(id)sender{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
//	if((UIButton *) sender == btnTakePhoto) {
//		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//	}
    
	[self presentViewController:picker animated:YES completion:nil];
    
    
}


// Create a custom UIButton and add it to the center of our tab bar
//-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
//{
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//    
//    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
//    if (heightDifference < 0)
//        button.center = self.tabBar.center;
//    else
//    {
//        CGPoint center = self.tabBar.center;
//        center.y = center.y - heightDifference/2.0;
//        button.center = center;
//    }
//    
//    [self.view addSubview:button];
//}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	UIImage *photoFromCamera = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIImage *sticker = [UIImage imageNamed:@"cofffe"];
    CGRect displayStickerZone = CGRectMake(100, 100, sticker.size.width * 5, sticker.size.height * 5);
    
    
    
    CGRect displayTextZone = CGRectMake(200, photoFromCamera.size.height - 400, photoFromCamera.size.width,(photoFromCamera.size.height)/10);
    
    UILabel *label = [[UILabel alloc] init];
    [label setText: @"Chộp được ở Galaxy Cafe"];
    label.font = [UIFont fontWithName:@"UVN Ban Tay" size:200];
    label.textColor = [UIColor whiteColor];
    
    UIGraphicsBeginImageContextWithOptions(photoFromCamera.size, NO, 0.0); //Create an image context
    [photoFromCamera drawInRect:CGRectMake(0, 0, photoFromCamera.size.width, photoFromCamera.size.height)]; //Draw the first UIImage
    [sticker drawInRect:displayStickerZone]; //Draw the second UIImage wherever you want on top of the first image
    
    [label drawTextInRect:displayTextZone];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    imageView.image = finalImage;
    
    
    UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);

}



-(IBAction) captureNow
{
    if (!session || !session.running) {
        [self startCameraSession];
    }
    
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
	
	NSLog(@"about to request a capture from: %@", stillImageOutput);
	[stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *photoFromCamera = [[UIImage alloc] initWithData:imageData];
         
         //Định nghĩa khung crop ảnh để cắt láy ảnh vuông
         CGRect cropRect = CGRectMake(0, (photoFromCamera.size.height - photoFromCamera.size.width)/2, photoFromCamera.size.width,photoFromCamera.size.height);
         // Ảnh đã cắt.
         CGImageRef imageRef = CGImageCreateWithImageInRect([photoFromCamera CGImage], cropRect);
         
         UIImage *imageToSave = [UIImage imageWithCGImage:imageRef];
         
         CGImageRelease(imageRef);
         
         
         // Sticker
         UIImage *sticker = stickerVIEW.image;
         CGRect displayStickerZone = CGRectMake(imageToSave.size.width - sticker.size.width * 4 - 100,100, sticker.size.width * 4, sticker.size.height * 4);
         
         
         
         CGRect displayTextZone = CGRectMake(0, imageToSave.size.height - 400, imageToSave.size.width,(imageToSave.size.height)/10);
         

         
         UIGraphicsBeginImageContextWithOptions(imageToSave.size, NO, 0.0); //Create an image context
         [imageToSave drawInRect:CGRectMake(0, 0, imageToSave.size.width, imageToSave.size.height)]; //Draw the first UIImage
         [sticker drawInRect:displayStickerZone]; //Draw the second UIImage wherever you want on top of the first image
         lblPlace.font = [UIFont fontWithName:@"UVN Ban Tay" size:150];
         [lblPlace drawTextInRect:displayTextZone];
         
         UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
         
         
         
         [session stopRunning];
         
         for (UIView *view in cameraView.subviews) {
             [view removeFromSuperview];
         }
         UIImageView *finalImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cameraView.frame.size.width, cameraView.frame.size.width)];
         finalImgView.image = finalImage;
         [cameraView addSubview:finalImgView];
         if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
             
             SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
             
             [controller setInitialText:[NSString stringWithFormat:@"I'm @ %@",lblPlace.text]];
             //[controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
             [controller addImage:finalImage];
             
             [self presentViewController:controller animated:YES completion:Nil];
             
             
         }

         
         UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);
	 }];
    
    }

// Create a view controller and setup it's tab bar item with a title and image
//-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
//{
//    UIViewController* viewController = [[UIViewController alloc] init];
//    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0] ;
//    return viewController;
//}

@end
