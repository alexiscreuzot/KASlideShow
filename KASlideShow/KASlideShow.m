//
//  KASlideShow.m
//
//  Created by Alexis Creuzot on 23/01/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "KASlideShow.h"

@interface KASlideShow()
@property (atomic) BOOL doStop;
@property (atomic) BOOL isAnimating;
@end

@implementation KASlideShow{
    
    NSUInteger currentIndex;
    
    UIImageView * topImageView;
    UIImageView * bottomImageView;
}

@synthesize delay;
@synthesize transitionDuration;
@synthesize images;

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
    images = [NSMutableArray array];
    currentIndex = 0;
    delay = 1;
    
    transitionDuration = 0.3;
    _doStop = YES;
    _isAnimating = NO;
    
    topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bottomImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self setImagesContentMode:UIViewContentModeScaleAspectFit];
    
    [self addSubview:bottomImageView];
    [self addSubview:topImageView];
}

- (void) setImagesContentMode:(UIViewContentMode)mode
{
    topImageView.contentMode = mode;
    bottomImageView.contentMode = mode;
}

- (UIViewContentMode) imagesContentMode
{
    return topImageView.contentMode;
}


- (void) addImagesFromResources:(NSArray *) names
{
    // Add images
    for(NSString * name in names){
        [self addImage:[UIImage imageNamed:name]];
    }
}

- (void) addImage:(UIImage*) image
{
    [images addObject:image];
    
    if([images count] == 1){
        topImageView.image = image;
    }else if([images count] == 2){
        bottomImageView.image = image;
    }
}


- (void) start
{
    if([images count] <= 1){
        return;
    }
    
    _doStop = NO;
    [self performSelector:@selector(next) withObject:nil afterDelay:delay];
}

- (void) next
{
    
    if(! _isAnimating){
        
        // Next Image
        NSUInteger nextIndex = (currentIndex+1)%[images count];
        topImageView.image = images[currentIndex];
        bottomImageView.image = images[nextIndex];
        currentIndex = nextIndex;
        
        [self animate];
    }
}


- (void) previous
{
    if(! _isAnimating){
        
        // Previous image
        NSUInteger prevIndex;
        if(currentIndex == 0){
            prevIndex = [images count] - 1;
        }else{
            prevIndex = (currentIndex-1)%[images count];
        }
        topImageView.image = images[currentIndex];
        bottomImageView.image = images[prevIndex];
        currentIndex = prevIndex;
        
        // Animate
        [self animate];
    }
    
}

- (void) animate
{
    _isAnimating = YES;
    
    [UIView animateWithDuration:transitionDuration
                     animations:^{
                         topImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         topImageView.image = bottomImageView.image;
                         topImageView.alpha = 1;
                         
                         _isAnimating = NO;
                         
                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }
                     }];
}


- (void) stop
{
    _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}


@end

