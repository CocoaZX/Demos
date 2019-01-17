//
//  KTPhotoView.h
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTPhotoView : UIScrollView <UIScrollViewDelegate>
{
	UIImageView *imageView_;
	NSInteger index_;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSString *imageData;

@property (nonatomic, assign) BOOL disableDoubleClick;

- (void)setImage:(UIImage *)newImage;
- (void)turnOffZoom;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;


@end
