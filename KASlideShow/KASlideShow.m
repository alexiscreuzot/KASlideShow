//
//  KASlideShow.m
//
//  Created by Alexis Creuzot on 23/01/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "KASlideShow.h"

@implementation KASlideShow{
    NSUInteger nbSlides;
    BOOL doStop;
    NSMutableArray * slides;
}

@synthesize delay;
@synthesize transitionDuration;

- (void)awakeFromNib
{
    [self setDefaultValues];
    NSLog(@"bloop");
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void) setDefaultValues
{
    slides = [NSMutableArray array];
    delay = 3;
    transitionDuration = 1;
    doStop = NO;
}


- (void) addImageFromNames:(NSArray *) names
{
    nbSlides = [names count];
    
    UIImageView * lastImageView;
    
    // Add images
    for(NSString * name in names){
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        [imageView setFrame:self.frame];
        [slides addObject:imageView];
        
        if(lastImageView){
            [self insertSubview:imageView belowSubview:lastImageView];
        }else{
            [self addSubview:imageView];
        }
        
        lastImageView = imageView;
    }
}


- (void) start
{    
    if(nbSlides <= 1){
        return;
    }
    
    [self performSelector:@selector(animate) withObject:nil afterDelay:delay];
}

- (void) animate
{
    UIImageView * currentImage = (UIImageView *) slides[0];
    UIView * lastImage = (UIImageView *) slides[nbSlides-1];
    
    [UIView animateWithDuration:transitionDuration
                     animations:^{
                         currentImage.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self insertSubview:currentImage belowSubview:lastImage];
                         [slides insertObject:currentImage atIndex:nbSlides];
                         [slides removeObjectAtIndex:0];
                         currentImage.alpha = 1;
                         
                         if(! doStop){
                             [self performSelector:@selector(animate) withObject:nil afterDelay:delay];
                         }else{
                             doStop = NO;
                         }
                         
                     }];
}

- (void) stop
{
    doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animate) object:nil];
}


@end
