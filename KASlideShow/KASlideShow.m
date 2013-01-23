//
//  KASlideShow.m
//
//  Created by Alexis Creuzot on 23/01/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "KASlideShow.h"

@interface KASlideShow()
@property (atomic) BOOL doStop;
@end

@implementation KASlideShow{
    NSUInteger nbSlides;
    NSMutableArray * slides;
}

@synthesize delay;
@synthesize transitionDuration;

- (void)awakeFromNib
{
    [self setDefaultValues];
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
    delay = 1;
    transitionDuration = 0.3;
    _doStop = NO;
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
    _doStop = NO;
    [self performSelector:@selector(next) withObject:nil afterDelay:delay];
}

- (void) next
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
                         
                         if(! _doStop){
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }else{
                             _doStop = NO;
                         }
                         
                     }];
}


- (void) stop
{
    _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}


@end
