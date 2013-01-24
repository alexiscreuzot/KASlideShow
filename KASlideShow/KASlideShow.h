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

- (void) addImagesFromResources:(NSArray *) names;
- (void) start;
- (void) stop;
- (void) next;

@end


@interface NSMutableArray (MoveArray)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
- (void)moveObject:(id)object toIndex:(NSUInteger)to;
- (void)reverse;
@end

@implementation NSMutableArray (MoveArray)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self objectAtIndex:from];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
    }
}

- (void)moveObject:(id)object toIndex:(NSUInteger)to
{
    NSUInteger from = [self indexOfObject:object];
    [self moveObjectFromIndex:from toIndex:to];
}

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end