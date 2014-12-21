//
//  ImageSave.h
//  ImageSaveTest
//
//  Created by kayama on 2014/12/15.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

#ifndef ImageSaveTest_ImageSave_h
#define ImageSaveTest_ImageSave_h

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageSave: NSObject
{
}

+ (UIImage *)imageFromView:(UIView *)view size:(CGSize)size_in bkColor:(UIColor*)color_in;
+ (void)saveImageToPhotosAlbum:(UIImage*)_image;
+ (BOOL)isPhotoAccessEnableWithIsShowAlert:(BOOL)_isShowAlert;
+ (UIColor *)invisibleColor;
+ (UIImage *)reSizeUIImage:(UIImage *)original width:(CGFloat)width_in height:(CGFloat)height_in;
@end

#endif