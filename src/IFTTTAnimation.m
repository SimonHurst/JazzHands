//
//  IFTTTAnimation.m
//  JazzHands
//
//  Created by Devin Foley on 9/27/13.
//  Copyright (c) 2013 IFTTT Inc. All rights reserved.
//

#import "IFTTTAnimation.h"

@interface IFTTTAnimation ()

@property (strong, nonatomic) NSMutableArray *timeline; // IFTTTAnimationFrames
@property (assign, nonatomic) NSInteger startTime; // in case timeline starts before t=0

@end

@implementation IFTTTAnimation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _startTime = 0;
    }
    
    return self;
}

- (NSMutableArray *)keyFrames
{
    if (!_keyFrames) {
        _keyFrames = [NSMutableArray new];
    }
    return _keyFrames;
}

- (NSMutableArray *)timeline
{
    if (!_timeline) {
        _timeline = [NSMutableArray new];
    }
    return _timeline;
}

- (id)initWithView:(UIView *)view
{
    self = [IFTTTAnimation new];
    if (self)
    {
        _view = view;
    }
    
    return self;
}

- (void)addKeyFrame:(IFTTTAnimationKeyFrame *)keyFrame
{
    if (self.keyFrames.count == 0)
    {
        [self.keyFrames addObject:keyFrame];
        return;
    }

    [self sortKeyFramesInOrderOfTimeIfNewKeyFrameIsNotAfterLastKeyFrame:keyFrame];
    [self updateKeyFrameTimeLine];
    [self updateStartTime];
}

- (void)sortKeyFramesInOrderOfTimeIfNewKeyFrameIsNotAfterLastKeyFrame:(IFTTTAnimationKeyFrame *)newKeyFrame
{
    if (newKeyFrame.time > ((IFTTTAnimationKeyFrame *)self.keyFrames.lastObject).time)
    {
        [self.keyFrames addObject:newKeyFrame];
    } else {
        for (NSInteger i = 0; i < self.keyFrames.count; i++)
        {
            if (newKeyFrame.time < [self keyFrameAtIndex:i].time) {
                [self.keyFrames insertObject:newKeyFrame atIndex:i];
                break;
            }
        }
    }
}

- (void)updateKeyFrameTimeLine
{
    self.timeline = [NSMutableArray new];
    for (NSInteger i = 0; i < self.keyFrames.count - 1; i++) {
        IFTTTAnimationKeyFrame *keyFrame = [self keyFrameAtIndex:i];
        IFTTTAnimationKeyFrame *nextKeyFrame = [self keyFrameAtIndex:i+1];
        
        for (NSInteger j = keyFrame.time; j <= nextKeyFrame.time; j++) {
            [self.timeline addObject:[self frameForTime:j startKeyFrame:keyFrame endKeyFrame:nextKeyFrame]];
        }
    }
}

- (void)updateStartTime
{
    IFTTTAnimationKeyFrame *firstKeyFrame = [self keyFrameAtIndex:0];
    self.startTime = firstKeyFrame.time;
}


- (IFTTTAnimationFrame *)animationFrameForTime:(NSInteger)time
{
    if (time < self.startTime) {
        return [self.timeline objectAtIndex:0];
    }

    if (time - self.startTime < self.timeline.count) {
        return [self.timeline objectAtIndex:time - self.startTime];
    }

    return [self.timeline lastObject];
}

- (IFTTTAnimationKeyFrame *)keyFrameAtIndex: (NSUInteger) index
{
    return (IFTTTAnimationKeyFrame *) [self.keyFrames objectAtIndex:index];
}

- (void)animate:(NSInteger)time
{
    NSLog(@"Hey pal! You need to use a subclass of IFTTTAnimation.");
}

- (IFTTTAnimationFrame *)frameForTime:(NSInteger)time
                        startKeyFrame:(IFTTTAnimationKeyFrame *)startKeyFrame
                          endKeyFrame:(IFTTTAnimationKeyFrame *)endKeyFrame
{
    NSLog(@"Hey pal! You need to use a subclass of IFTTTAnimation.");
    return startKeyFrame;
}

- (CGFloat)tweenValueForStartTime:(NSInteger)startTime
                          endTime:(NSInteger)endTime
                       startValue:(CGFloat)startValue
                         endValue:(CGFloat)endValue
                           atTime:(CGFloat)time
{
    CGFloat dt = (endTime - startTime);
    CGFloat timePassed = (time - startTime);
    CGFloat dv = (endValue - startValue);
    CGFloat vv = dv / dt;
    return (timePassed * vv) + startValue;
}



@end
