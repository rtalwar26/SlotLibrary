    //
    //  WLReel.m
    //  JewelThiefIphone
    //
    //  Created by rajat talwar on 27/11/11.
    //  Copyright (c) 2011 rajat. All rights reserved.
    //
/*Disclaimer: IMPORTANT:  This  software is supplied to you by Delvelogic Pvt Ltd
 in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Delvelogic Pvt LTd software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Delvelogic Pvt Ltd software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Delvelogic grants you a personal, non-exclusive
 license, under Delvelogic's copyrights in this original Delvelogic software (the
 "Delvelogic Software"), to use, reproduce, modify and redistribute the Delvelogic
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Delvelogic Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Delvelogic Software.
 Neither the name, trademarks, service marks or logos of Delvelogic Pvt ltd. may
 be used to endorse or promote products derived from the Delvelogic Software
 without specific prior written permission from Delvelogic.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Delvelogic herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Delvelogic Software may be incorporated.
 */
#import "WLReel.h"
extern const char *symbolImageArray[];
extern const char *symbolAnimarray[];

@implementation WLReel
@synthesize  mImageViewArray
,mSymbolArray,mDelegate,mTraverseAmount,mFrameRate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame config:(NSMutableDictionary*)pConfig
{
    
    self = [super initWithFrame:frame];
    if (self) {
            // Initialization code
        mReelHeight = frame.size.height;
        mReelWidth = frame.size.width;
        mReelState = WL_REEL_RUNNING;
        mDampingActive = false;
        firstFrame =        prevFrame = nil;
        if ([pConfig objectForKey:REEL_HEIGHT]) {
            mReelHeight= [[pConfig objectForKey:REEL_HEIGHT] floatValue];
        }
        
        if ([pConfig objectForKey:REEL_WIDTH]) {
            mReelWidth= [[pConfig objectForKey:REEL_WIDTH] floatValue];
        }
        
        if ([pConfig objectForKey:SYMBOL_HEIGHT]) {
            mSymbolHeight= [[pConfig objectForKey:SYMBOL_HEIGHT] floatValue];
        }
        else
            {
            mSymbolHeight = DEFAULT_SYMBOL_HEIGHT;
            }
        
        if ([pConfig objectForKey:SYMBOL_WIDTH]) {
            mSymbolWidth= [[pConfig objectForKey:SYMBOL_WIDTH] floatValue];
        }
        else
            {
            mSymbolWidth = mReelWidth;
            }
        
        
        
            //        if ([pConfig objectForKey:VERTICAL_SPACING]) {
            //            mVerticalSpacing= [[pConfig objectForKey:VERTICAL_SPACING] floatValue];
            //        }
            //        else
            //        {
            //            mVerticalSpacing = DEFAULT_VERTICAL_SPACING;
            //        }
        
        
        if ([pConfig objectForKey:SYMBOLS_PER_REEL]) {
            mNumberOfSymbolsPerReel= [[pConfig objectForKey:SYMBOLS_PER_REEL] intValue];
        }
        else
            {
            mNumberOfSymbolsPerReel = 3;
            
            }
        mReelHeight = mNumberOfSymbolsPerReel * mSymbolHeight;
        
        CGRect newFrame =  self.frame;
        newFrame.size.height = mReelHeight;
        
        self.frame = newFrame;
        
        mOriginalTraverse = mReelHeight/TRAVERSE_DIVISOR;
        mTraverseAmount = mOriginalTraverse;
        
        
        if ([pConfig objectForKey:SYMBOL_ARRAY]) {
            self.mSymbolArray = [pConfig objectForKey:SYMBOL_ARRAY] ;
        }
        else
            {
            
            self.mSymbolArray = [NSArray arrayWithObjects:@"test1.jpeg",@"test2.jpeg",@"test3.jpeg",@"test4.jpeg",@"test5.jpeg",@"test6.jpeg",@"test7.jpeg",@"test8.jpeg", nil];
            }
        
        mReelRoundUpPoint = mReelHeight + mSymbolHeight*1.5 ;
        mSymbolCount = [mSymbolArray count];
        
        mSymbolTotalHeight = mSymbolHeight;
        
        NSInteger numberOfSymbolFramesNeeded = (NSInteger)ceil(mReelHeight/mSymbolTotalHeight);
        numberOfSymbolFramesNeeded = (NSInteger)(numberOfSymbolFramesNeeded + 3);
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:numberOfSymbolFramesNeeded ];
        
        for (NSUInteger i = 0 ; i< numberOfSymbolFramesNeeded; i++) {
            [array addObject:[NSNull null]];
        }
        
        self.mImageViewArray = array;
        [array release];
        
        mTopFrameIndex = 0;
        CGFloat yIndex = mReelRoundUpPoint - mSymbolHeight/2;
        mCurrentSymbolIndex = numberOfSymbolFramesNeeded-1;
        for (NSInteger i = 1 ; i<= numberOfSymbolFramesNeeded; i++) {
            
            WLImageView *tempImageView = [[WLImageView alloc] initWithFrame:CGRectMake(0, yIndex, mSymbolWidth, mSymbolHeight)];
            
                //            WLImageView *prevImageView = [self.mImageViewArray objectAtIndex:(numberOfSymbolFramesNeeded-i)];
                //            
                //            [prevImageView removeFromSuperview];
            [self.mImageViewArray replaceObjectAtIndex:(numberOfSymbolFramesNeeded-i) withObject:tempImageView];
            tempImageView.image = [UIImage imageNamed:[self getSymbolAtIndex:(numberOfSymbolFramesNeeded-i) forWlImageView:tempImageView]];
            
            [self addSubview:tempImageView];
            
            tempImageView.tag = numberOfSymbolFramesNeeded-i;
            [tempImageView release];
            
            yIndex-= mSymbolTotalHeight;
            
        }
        mReelInitialisationPoint = yIndex ;
            //        DLog(@"reel initialization point is %f",mReelInitialisationPoint);
        
        CGFloat hello = 0;
        CGFloat decreasing = mOriginalTraverse;
        while (1) {
            
            
            hello    =  hello + decreasing;
            decreasing = decreasing/DAMPING_FACTOR;
            if (decreasing <1 ) {
                break;
            }
        }
        
            //        DLog(@"the traversed amount is %f",hello);
    }
    return self;
}

-(NSString*)getSymbolAtIndex:(NSInteger)pIndex forWlImageView:(WLImageView*)pImageView
{
    pIndex = pIndex%[mSymbolArray count];
    
    int index = [[mSymbolArray objectAtIndex:pIndex] integerValue];
    
    if (pImageView) {
        pImageView.mSymbolId = index;
    }
    NSString *name = [[NSString alloc] initWithCString:symbolImageArray[index] encoding:NSUTF8StringEncoding];
    
    return[name autorelease];
}

-(NSString*)getSymbolAtIndex:(NSInteger)pIndex
{
    
    return [self getSymbolAtIndex:pIndex forWlImageView:nil];
    
}

-(WLImageView*)getFrameAtIndex:(NSInteger)pIndex
{
    
    WLImageView *imageView =  [mImageViewArray objectAtIndex:(pIndex%[mImageViewArray count])];
        //    imageView.animationImages = nil;
    return imageView;
}

-(void)jumpToPosition:(NSInteger)pPos
{
    
    
}
-(void)play
{
    mTraverseAmount = mOriginalTraverse;
    mReelState = WL_REEL_RUNNING;
    mDampingActive = false;
}

-(void)stopping
{
    mReelState = WL_REEL_STOPPING;
        //    mDampingActive = true;
}
-(void)killAllAnimations
{
    
    for (WLImageView *obj in mImageViewArray) {
        
        [obj stopAnimating];
    }
}
-(WLImageView*)getImageViewAtRowIndex:(NSNumber*)pSymbolIndexNum
{
    
    NSInteger  pSymbolIndex = [pSymbolIndexNum integerValue];
    
    
    NSInteger firstIndex = mFirstFrameIndex;
    NSInteger iter = 0;
    WLImageView *symbolFrame =nil;
    while (1) {
        
        
        
        symbolFrame = [self getFrameAtIndex:firstIndex ];
        if (iter == pSymbolIndex) {
            break;
        }
        
        firstIndex++;
        
        if (firstIndex==[mImageViewArray count]) {
            firstIndex = 0;
        }
        
        
        iter++;
        
    }
    
    return  symbolFrame;
}

-(void)hideSymbol:(NSNumber*)pSymbolIndexNum forInterval:(NSTimeInterval)pInterval
{
    
    WLImageView *imageView = [self getImageViewAtRowIndex:pSymbolIndexNum];
    
    imageView.image= [UIImage imageNamed:@"hv5_0036.png"];
    
        //    [self performSelector:@selector(showImageView:) withObject:imageView afterDelay:pInterval];
    
}
-(void)animateSymbol:(NSNumber*)pSymbolIndexNum
{
    
    NSInteger  pSymbolIndex = [pSymbolIndexNum integerValue];
    
        //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSInteger firstIndex = mFirstFrameIndex;
    NSInteger iter = 0;
    WLImageView *symbolFrame = nil;
    while (1) {
        
        
        
        symbolFrame = [self getFrameAtIndex:firstIndex ];
        if (iter == pSymbolIndex) {
            break;
        }
        
        firstIndex++;
        
        if (firstIndex==[mImageViewArray count]) {
            firstIndex = 0;
        }
        
        
        iter++;
        
    }
    
//    int index = [[mSymbolArray objectAtIndex:symbolFrame.tag] integerValue];
    
   int index = symbolFrame.mSymbolId;
    
    NSString *name = [[NSString alloc] initWithCString:symbolAnimarray[index] encoding:NSUTF8StringEncoding];
    
        //    DLog(@"\nthe tag is %d",symbolFrame.tag);
    
    NSMutableDictionary *avlDic = [[AppHelper appDelegate] mAvl];
    
    NSMutableDictionary * scene = [[avlDic objectForKey:@"Animation"] objectForKey:[name autorelease]];
    
    
    
    NSInteger end = [[scene objectForKey:@"EndIndex"] integerValue]; 
    
    
    symbolFrame.animationImages = [[AppHelper appDelegate ] getAnimImagesForSymbol:index] ;
    
    symbolFrame.animationDuration = end/25.0;
    symbolFrame.animationRepeatCount =1;
    
    [symbolFrame startAnimating];
    
        //    [pool release];
        //    symbolFrame.animationImages = nil;
}

-(void)animate
{
    
    switch (mReelState) {
        case WL_REEL_STOPPED:
            return;
            
            break;
            
        case WL_REEL_INSTANT_STOP:
        {
        
        mReelState = WL_REEL_INSTANT_STOPPING;
        
        [self instantMoveReel];
        
        return;
        
            //            WLImageView *topFrame = [self getFrameAtIndex:mTopFrameIndex];
        
        
            //            NSInteger  frameY = (NSInteger)topFrame.frame.origin.y;
            //    if (  frameY >= 0 ) {
            //        mFirstFrameIndex = [mImageViewArray indexOfObject:firstFrame];
        
            //            [self instantStopAtOffset:(0-frameY)];
        
        }
            
            return;
            
            break;
            
        case WL_REEL_RUNNING:
        case WL_REEL_STOPPING:
            
            [self moveReel];
            
            break;
            
        default:
            break;
    }
    
    
    
}



-(void)stop
{
    mReelState = WL_REEL_STOPPED;
    
    
    
        //    if([(id)mDelegate respondsToSelector:@selector(wlReel:didStoppedAtIndex:symbol:)])
        //    {
        //        NSInteger index = [[mSymbolArray objectAtIndex:mStopIndex] integerValue];
        //        
        //        [self.mDelegate wlReel:self didStoppedAtIndex:mStopIndex symbol:index];
        //    }
    
    
}

-(void)stopAtOffset:(CGFloat)pOffset
{
    
    mReelState = WL_REEL_STOPPED;
    
    
    
    if([(id)mDelegate respondsToSelector:@selector(wlReel:didStoppedAtIndex:symbol:)])
        {
        
        NSInteger index = [[mSymbolArray objectAtIndex:mStopIndex] integerValue];
        
        [self.mDelegate wlReel:self didStoppedAtIndex:mStopIndex symbol:index];
        }
    
    
    NSUInteger frameCount = [mImageViewArray count];
    WLImageView *pImageView;
    for (NSUInteger i = 0; i<frameCount; i++) {
        
        pImageView = [self getFrameAtIndex:i];
        
        
        
#ifdef GOOD_REELS
        [[pImageView layer] addAnimation:[self getStopAnimationforPoint:[pImageView center] traverseAmount:pOffset] forKey:ANIMATION_PROPERTY];
#else
        [[pImageView layer] addAnimation:[self getAnimationforPoint:[pImageView center] traverseAmount:pOffset] forKey:ANIMATION_PROPERTY];
        
#endif
        
        CGPoint newPoint =  pImageView.center;
        newPoint.y+=pOffset;
        [[pImageView layer] setPosition:newPoint];
        
        
    }
    
}

-(void)instantStopAtOffset:(CGFloat)pOffset
{
    
    
    mReelState = WL_REEL_STOPPED;
    
    
    
    
    
    NSUInteger frameCount = [mImageViewArray count];
    WLImageView *pImageView;
    for (NSUInteger i = 0; i<frameCount; i++) {
        
        pImageView = [self getFrameAtIndex:i];
        
        
#ifdef COREANIMATION_USED    
        [[pImageView layer] addAnimation:[self getStopAnimationforPoint:[pImageView center] traverseAmount:pOffset] forKey:ANIMATION_PROPERTY];
#endif
        CGPoint newPoint =  pImageView.center;
        newPoint.y+=pOffset;
        [[pImageView layer] setPosition:newPoint];
        
        
    }
    
    if([(id)mDelegate respondsToSelector:@selector(wlReel:didInstantStopAtIndex:symbol:)])
        {
        NSInteger index = [[mSymbolArray objectAtIndex:mStopIndex] integerValue];
        
        [self.mDelegate wlReel:self didInstantStopAtIndex:mStopIndex symbol:index];
        }
    
}

-(void)instanceStopAtPosition:(NSInteger)pPos
{
    
    
    mReelState = WL_REEL_INSTANT_STOP;
    
    
    pPos = pPos%[mSymbolArray count];
    mStopIndex = pPos;
    
    
#ifdef GOOD_REELS
    
    
    
    if (pPos < STOP_POSITION_GAP) {
        
        mCurrentSymbolIndex = [mSymbolArray count] - (STOP_POSITION_GAP - pPos);
    }
    else    
        {
        mCurrentSymbolIndex = pPos - STOP_POSITION_GAP;
        }
        //    mCurrentSymbolIndex = pPos;
        //    mStopIndex = (pPos+STOP_POSITION_GAP)%[mSymbolArray count]; 
#endif   
    
    
    
    return;
    
    
    
    
}

-(void)stopAtPosition:(NSInteger)pPos
{
    
    if (mReelState == WL_REEL_STOPPING || mReelState == WL_REEL_STOPPED) {
        return;
    }
    
    pPos = pPos%[mSymbolArray count];
    mStopIndex = pPos;
    
    
#ifdef GOOD_REELS
    
    pPos = pPos%[mSymbolArray count];
    mStopIndex = pPos;
    
    if (pPos < STOP_POSITION_GAP) {
        
        mCurrentSymbolIndex = [mSymbolArray count] - (STOP_POSITION_GAP - pPos);
    }
    else    
        {
        mCurrentSymbolIndex = pPos - STOP_POSITION_GAP;
        }
        //    mCurrentSymbolIndex = pPos;
        //    mStopIndex = (pPos+STOP_POSITION_GAP)%[mSymbolArray count]; 
#endif   
    mReelState = WL_REEL_STOPPING;
    
    
    /*  NSInteger frameCount = [mImageViewArray count];
     NSInteger enumerator =  mTopFrameIndex;
     NSString *symbolName = nil;
     WLImageView *thisFrame = nil;
     
     for (NSInteger i =0 ; i< frameCount; i++) {
     
     symbolName  = [self getSymbolAtIndex:pPos];
     
     
     thisFrame = [self getFrameAtIndex:enumerator];
     
     thisFrame.image = [UIImage imageNamed:symbolName];
     
     enumerator++;
     pPos++;
     
     
     }
     
     [self stop];*/
    
    
}

-(void)instantMoveReel
{
    WLImageView *topFrame = [self getFrameAtIndex:mTopFrameIndex];
#ifdef DEALLOCATE_ANIMATIONIMAGES
    topFrame.animationImages =  nil;
#endif
    if (mDampingActive) {
        
        if(!firstFrame && topFrame.tag == mStopIndex)
            firstFrame = topFrame;
        
#ifdef GOOD_REELS
        if (mTraverseAmount<2) {
            mTraverseAmount =2;
        }
        
#else
        
        if (mTraverseAmount<2) {
            mTraverseAmount =2;
        }
#endif
        else{
            
#ifndef GOOD_REELS
            mTraverseAmount = mTraverseAmount/DAMPING_FACTOR;
#endif
        }
        
        
        if (firstFrame) {
            
            if ([self instantShouldStopAtFrameFound]) {
                
                return;
            }
            
            
        }
    }
    
    [self instantAnimateAllFrames];
    
    
}
-(void)moveReel
{
    WLImageView *topFrame = [self getFrameAtIndex:mTopFrameIndex];
    
    if (mDampingActive) {
        
        if(!firstFrame && topFrame.tag == mStopIndex)
            firstFrame = topFrame;
        
#ifdef GOOD_REELS
        if (mTraverseAmount<2) {
            mTraverseAmount =2;
        }
        
#else
        
        if (mTraverseAmount<2) {
            mTraverseAmount =2;
        }
#endif
        else{  
            
#ifndef GOOD_REELS
            mTraverseAmount = mTraverseAmount/DAMPING_FACTOR;
#endif
        }
        
        
        if (firstFrame) {
            
            if ([self shouldStopAtFrameFound]) {
                
                return;
            }
            
            
        }
    }
    
    [self animateAllFrames];
}

-(BOOL)instantShouldStopAtFrameFound
{
    NSInteger  frameY = (NSInteger)firstFrame.frame.origin.y;
    
#ifdef GOOD_REELS
    if(frameY>= (mSymbolHeight/4)){
        
        
#else
        if (  frameY >= 0 ) {
            
#endif
            mFirstFrameIndex = [mImageViewArray indexOfObject:firstFrame];
            
            [self instantStopAtOffset:(0-frameY)];
            
            
            firstFrame = prevFrame = nil;
            
            return YES;
        }
        
        return FALSE;
    }
    
    -(BOOL)shouldStopAtFrameFound
    {
    NSInteger  frameY = (NSInteger)firstFrame.frame.origin.y;
    
#ifdef GOOD_REELS
    if(frameY>= (mSymbolHeight/4)){
        
        
#else
        if (  frameY >= 0 ) {
            
#endif
            mFirstFrameIndex = [mImageViewArray indexOfObject:firstFrame];
            
            [self stopAtOffset:(0-frameY)];
            
            
            firstFrame = prevFrame = nil;
            
            return YES;
        }
        
        return FALSE;
    }
    
    -(void)instantAnimateAllFrames
        {
        NSUInteger frameCount = [mImageViewArray count];
        WLImageView *thisFrame;
        for (NSUInteger i = 0; i<frameCount; i++) {
            
            thisFrame = [self getFrameAtIndex:i];
            [self instantAnimateThis:thisFrame withtraverseAmount:mTraverseAmount];
            
        }
        
        [self instantMoveReel];
        }
    -(void)animateAllFrames
        {
        NSUInteger frameCount = [mImageViewArray count];
        WLImageView *thisFrame;
        for (NSUInteger i = 0; i<frameCount; i++) {
            
            thisFrame = [self getFrameAtIndex:i];
            
            [self animateThis:thisFrame withtraverseAmount:mTraverseAmount];
            
        }
        }
    
    -(void)instantAnimateThis:(WLImageView*)pImageView withtraverseAmount:(CGFloat)ptraverseAmount
        {
            //    traverseAmount= traverseAmount/1.01;
        
        
        [[pImageView layer] removeAllAnimations]  ;
        
        CGPoint newPoint =  pImageView.center;
        newPoint.y+=ptraverseAmount;
        
        if (newPoint.y >= mReelRoundUpPoint)
            {
            
            
            CGFloat yIndex =  newPoint.y - mReelRoundUpPoint;
            newPoint.y = mReelInitialisationPoint +mSymbolTotalHeight/2 +yIndex;
            
            mTopFrameIndex = [mImageViewArray indexOfObject:pImageView];
            mCurrentSymbolIndex = mCurrentSymbolIndex%[mSymbolArray count];
            pImageView.image = [UIImage imageNamed:[self getSymbolAtIndex:mCurrentSymbolIndex forWlImageView:pImageView]];

            pImageView.tag = mCurrentSymbolIndex;
            if(mReelState == WL_REEL_INSTANT_STOPPING && mStopIndex==mCurrentSymbolIndex)
                {
                
                mDampingActive = true;
                }
            
            
            
            
            mCurrentSymbolIndex++;
            
            }
        
        [[pImageView layer] setPosition:newPoint];
        
        }
    
    
    
    -(void)animateThis:(WLImageView*)pImageView withtraverseAmount:(CGFloat)ptraverseAmount
        {
            //    traverseAmount= traverseAmount/1.01;
        
        
#ifdef COREANIMATION_USED    
        [[pImageView layer] addAnimation:[self getAnimationforPoint:[pImageView center] traverseAmount:ptraverseAmount] forKey:ANIMATION_PROPERTY];
#endif
        CGPoint newPoint =  pImageView.center;
        newPoint.y+=ptraverseAmount;
        
        if (newPoint.y >= mReelRoundUpPoint)
            {
            
            
            CGFloat yIndex =  newPoint.y - mReelRoundUpPoint;
            newPoint.y = mReelInitialisationPoint +mSymbolTotalHeight/2 +yIndex;
            
            mTopFrameIndex = [mImageViewArray indexOfObject:pImageView];
            mCurrentSymbolIndex = mCurrentSymbolIndex%[mSymbolArray count];
            pImageView.image = [UIImage imageNamed:[self getSymbolAtIndex:mCurrentSymbolIndex forWlImageView:pImageView]];
            
            pImageView.tag = mCurrentSymbolIndex;
            if(mReelState == WL_REEL_STOPPING && mStopIndex==mCurrentSymbolIndex)
                {
                    //            DLog(@"the name is %@",[self getSymbolAtIndex:mCurrentSymbolIndex ]);
                
                mDampingActive = true;
                }
            mCurrentSymbolIndex++;
            
            }
        
        [[pImageView layer] setPosition:newPoint];
        }
    
    
    -(CABasicAnimation*)getStopAnimationforPoint:(CGPoint)pPoint traverseAmount:(CGFloat)pAmount
        {
        CGPoint startPoint = pPoint;
        CGPoint endPoint = pPoint;
        endPoint.y+=pAmount;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:ANIMATION_PROPERTY];
        [animation setFromValue:[NSValue valueWithCGPoint:startPoint]];
        animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
        [animation setToValue:[NSValue valueWithCGPoint:endPoint]];
        [animation setDuration:0.25];
        animation.delegate =self;
        animation.removedOnCompletion = NO;
        return animation;
        }
    
    
    -(CABasicAnimation*)getAnimationforPoint:(CGPoint)pPoint traverseAmount:(CGFloat)pAmount
        {
        CGPoint startPoint = pPoint;
        CGPoint endPoint = pPoint;
        endPoint.y+=pAmount;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:ANIMATION_PROPERTY];
        [animation setFromValue:[NSValue valueWithCGPoint:startPoint]];
        animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
        [animation setToValue:[NSValue valueWithCGPoint:endPoint]];
        [animation setDuration:mFrameRate];
        animation.delegate =self;
        animation.removedOnCompletion = NO;
        return animation;
        }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     - (void)drawRect:(CGRect)rect
     {
     // Drawing code
     }
     */
    
    -(void)dealloc
        {
        self.mDelegate = nil;
        [mImageViewArray release];
        [mSymbolArray release];
        [super dealloc];
        
        }
    @end
