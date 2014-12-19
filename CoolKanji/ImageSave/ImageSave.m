//
//  ImageSave.m
//  ImageSaveTest
//
//  Created by kayama on 2014/12/15.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

#import "ImageSave.h"


@implementation ImageSave
+ (UIImage *)imageFromView:(UIView *)view size:(CGSize)size_in bkColor:(UIColor*)color_in
{
    // 必要なUIImageサイズ分のコンテキスト確保
    UIGraphicsBeginImageContextWithOptions(size_in, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画像化する部分の位置を調整
    //左上(原点)
    //CGContextTranslateCTM(context, 0, 0);
    
    // colorで塗りつぶし
    CGRect rect = CGRectMake(0, 0, size_in.width, size_in.height);
    CGContextSetFillColorWithColor(context, color_in.CGColor);
    CGContextFillRect(context, rect);
    
    //中心に描画
    CGContextTranslateCTM(context, size_in.width / 2.0 - view.frame.size.width / 2.0,
                          size_in.height / 2.0 - view.frame.size.height / 2.0);
    
    // 画像出力
    [view.layer renderInContext:context];
    
    // uiimage化
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // コンテキスト破棄
    UIGraphicsEndImageContext();
    
    return renderedImage;
}


// 写真へのアクセスが許可されている場合はYESを返す。まだ許可するか選択されていない場合はYESを返す。
+ (BOOL)isPhotoAccessEnableWithIsShowAlert:(BOOL)_isShowAlert {
    // このアプリの写真への認証状態を取得する
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    BOOL isAuthorization = NO;
    
    switch (status) {
        case ALAuthorizationStatusAuthorized: // 写真へのアクセスが許可されている
            isAuthorization = YES;
            break;
        case ALAuthorizationStatusNotDetermined: // 写真へのアクセスを許可するか選択されていない
            isAuthorization = YES; // 許可されるかわからないがYESにしておく
            break;
        case ALAuthorizationStatusRestricted: // 設定 > 一般 > 機能制限で利用が制限されている
        {
            isAuthorization = NO;
            if (_isShowAlert) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"エラー"
                                          message:@"写真へのアクセスが許可されていません。\n設定 > 一般 > 機能制限で許可してください。"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
            break;
            
        case ALAuthorizationStatusDenied: // 設定 > プライバシー > 写真で利用が制限されている
        {
            isAuthorization = NO;
            if (_isShowAlert) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"エラー"
                                          message:@"写真へのアクセスが許可されていません。\n設定 > プライバシー > 写真で許可してください。"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
            break;
            
        default:
            break;
    }
    return isAuthorization;
}

+ (void)saveImageToPhotosAlbum:(UIImage*)_image {
    
    BOOL isPhotoAccessEnable = [self isPhotoAccessEnableWithIsShowAlert:YES];
    
    /////// フォトアルバムに保存 ///////
    if (isPhotoAccessEnable) {
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:_image.CGImage
                                  orientation:(ALAssetOrientation)_image.imageOrientation
                              completionBlock:
         ^(NSURL *assetURL, NSError *error){
            // NSLog(@"URL:%@", assetURL);
             //NSLog(@"error:%@", error);
             
             ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
             
             if (status == ALAuthorizationStatusDenied) {
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Error"
                                           message:@"写真へのアクセスが許可されていません。\n設定 > 一般 > 機能制限で許可してください。"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView show];
             } else {
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@""
                                           message:@"Save image to your device"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView show];
             }
         }];
    }
}


+ (UIColor *)invisibleColor
{
    return [UIColor clearColor];
}

@end
