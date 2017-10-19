//
//  PickSingleImageViewController.m
//  GFBS
//
//  Created by Alice Jin on 16/10/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "PickSingleImageViewController.h"
#import <RSKImageCropper.h>
#import "ZBLocalized.h"

#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import <UIImageView+WebCache.h>

@interface PickSingleImageViewController () <RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, UIImagePickerControllerDelegate> {
    CGFloat imageViewWidth;
    CGFloat chooseButtonWidth;
}

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage *pickedImage;

@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation PickSingleImageViewController

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.navigationItem.title = ZBLocalized(@"Upload Profile Image", nil);
    [self setUpNavBar];
    
    //_chooseButton.frame = CGRectMake((GFScreenWidth - chooseButtonWidth) / 2, 300, chooseButtonWidth, 40);
    [_chooseButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [_chooseButton setTintColor:[UIColor whiteColor]];
    _chooseButton.backgroundColor = ZZGoldColor;
    _chooseButton.layer.cornerRadius = 4.0f;
    [_chooseButton setTitle:@"Choose from Library" forState:UIControlStateNormal];
    [self.view addSubview:_chooseButton];
    
    imageViewWidth = 200;
    NSString *imageURL = [ZZUser shareUser].userProfileImage.imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    //_imageView.frame = CGRectMake((GFScreenWidth - imageViewWidth)/2, 80, imageViewWidth, imageViewWidth);
    _imageView.layer.cornerRadius = _imageView.gf_width / 2;
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

//*********** upload image *******************//
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
            break;
        case 0x42:
            return @"image/bmp";
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (void)okButtonClicked {
    NSLog(@"Upload button clicked");
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSLog(@"userToken in checkinVC %@", userToken);
    
    NSString *imageBase64 = [UIImagePNGRepresentation(_pickedImage)
                             base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSData *imageData = UIImagePNGRepresentation(_pickedImage);
    NSString *imageType = [self contentTypeForImageData:imageData];
    NSString *imageInfo = [NSString stringWithFormat:@"data:%@;base64,%@",imageType, imageBase64];
    
    NSDictionary *inSubData = @{@"profilePic": imageInfo};
    
    NSDictionary *inData = @{@"action" : @"uploadProfilePic",
                             @"token" : userToken,
                             @"data" : inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //self.profileImageView.image = nil;
        
        [AppDelegate APP].user.userProfileImage_UIImage = _pickedImage;
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:ZBLocalized(@"Profile image uploaded!", nil)  delegate:self cancelButtonTitle:ZBLocalized(@"Ok", nil)  otherButtonTitles:nil, nil];
        [alertView show];
        
        ZZUser *sucessBack = [[ZZUser alloc] init];
        sucessBack = [ZZUser mj_objectWithKeyValues:responseObject[@"data"]];
        [ZZUser shareUser].userProfileImage.imageUrl = sucessBack.userProfileImage.imageUrl;
        NSLog(@"[appDelegate]sucessBack.userProfileImage.imageUrl %@", sucessBack.userProfileImage.imageUrl);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:sucessBack.userProfileImage.imageUrl forKey:@"KEY_USER_PROFILE_PICURL"];
        [userDefaults synchronize];
        
        
        //[self textView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
}


- (void)chooseImage {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.imageView.image = chosenImage;
    
    self.pickedImage = chosenImage;
    
    NSLog(@"chosenImage %@", chosenImage);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:chosenImage];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    

    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma cropVC
//************* crop vc delegate

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    self.imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}
 */

/*

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
    // Use when `applyMaskToCroppedImage` set to YES.
    [SVProgressHUD show];
}
 */

/*

// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGSize maskSize;
    if ([controller isPortraitInterfaceOrientation]) {
        maskSize = CGSizeMake(250, 250);
    } else {
        maskSize = CGSizeMake(220, 220);
    }
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    
    return maskRect;
}
 */


// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:point1];
    [triangle addLineToPoint:point2];
    [triangle addLineToPoint:point3];
    [triangle closePath];
    
    return triangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    // If the image is not rotated, then the movement rect coincides with the mask rect.
    return controller.maskRect;
}

- (void) passSingleImage:(NSString *) theURL {
    [_delegate passSingleImage:[ZZUser shareUser].userProfileImage.imageUrl];
}

@end
