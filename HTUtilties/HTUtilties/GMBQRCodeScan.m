//
//  GMBQRCodeScanView.m
//  HTUtilties
//
//  Created by 江海天 on 16/3/29.
//  Copyright © 2016年 江海天. All rights reserved.
//

#import "GMBQRCodeScan.h"
#import <AVFoundation/AVFoundation.h>

@interface GMBQRCodeScan ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation GMBQRCodeScan
{
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    
    dispatch_queue_t _sessionQueue;
}

+ (instancetype)scanViewWithResultHandler:(void (^)(NSString *))resultHandler
{
    GMBQRCodeScan *scanView = [[GMBQRCodeScan alloc] init];
    [scanView setResultHandler:resultHandler];
    return scanView;
}

- (void)commonInit
{
    _captureSession = [[AVCaptureSession alloc] init];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.layer addSublayer:_previewLayer];
    
    _sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
}

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

//只会在IB中执行, 不影响实际运行
- (void)prepareForInterfaceBuilder
{
//    UIImage *image = [UIImage imageNamed:@"QR_Code.jpg"
//                                inBundle:[NSBundle bundleForClass:[self class]]
//           compatibleWithTraitCollection:self.traitCollection];
//    self.layer.contents = (id)image.CGImage;
    self.backgroundColor = [UIColor orangeColor];
}

- (void)layoutSubviews
{
    _previewLayer.frame = self.bounds;
}

- (BOOL)startScan
{
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"请在设置-隐私-相机中允许访问相机。"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
     _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (!_input) {
        return NO;
    }
    [_captureSession addInput:_input];
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:_output];
    
    //output 和 input 都添加到session中才可以获取avaliableType
    for (NSString *type in [_output availableMetadataObjectTypes]) {
        if (type == AVMetadataObjectTypeQRCode) {  //可以直接比较地址
            [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        }
    }
    //在主线程中回调
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if (self.presetLevel) {
        _captureSession.sessionPreset = self.presetLevel;
    }
    
    dispatch_async(_sessionQueue, ^{
       [_captureSession  startRunning];
    });
    
    return YES;
}

- (void)stopScan
{
    dispatch_async(_sessionQueue, ^{
        [_captureSession stopRunning];
        [_captureSession removeInput:_input];
        [_captureSession removeOutput:_output];
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count]) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        _result = metadataObj.stringValue;
        if (_resultHandler) {
            _resultHandler(_result);
        }
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    else {
        _result = nil;
        NSLog(@"无输出");
    }
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
    //[self stopScan];
}

@end
