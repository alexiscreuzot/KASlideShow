//
//  KASlideShow.h
//
//  Created by Alexis Creuzot on 23/01/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

@interface KASlideShow : UIView

@property  float delay;
@property  float transitionDuration;
@property  UIViewContentMode imagesContentMode;
@property  NSMutableArray * images;

- (void) addImagesFromResources:(NSArray *) names;
- (void) addImage:(UIImage *) image;
- (void) start;
- (void) stop;
- (void) previous;
- (void) next;

@end
