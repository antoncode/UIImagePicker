//
//  AHRDraggingCell.m
//  UICollectionViewHW
//
//  Created by Anton Rivera on 3/20/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "AHRDraggingCell.h"

@implementation AHRDraggingCell

-(UIImage *)getRasterizedImageCopy
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
