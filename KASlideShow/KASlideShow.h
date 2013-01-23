//
//  KASlideShow.h
//
//  Created by Alexis Creuzot on 23/01/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

@interface KASlideShow : UIScrollView

@property  float delay;
@property  float transitionDuration;

- (void) addImageFromNames:(NSArray *) names;
- (void) start;
- (void) stop;

@end
