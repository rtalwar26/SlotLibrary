//
//  WinObject.m
//  JwelThiefIpad
//
//  Created by rajat talwar on 12/12/11.
//  Copyright (c) 2011 rajat. All rights reserved.
//

#import "WinObject.h"

extern const int symbolWins[][5];
extern const int symbolLeastWin[];

extern const char *symbolImageArray[];
extern const char *symbolAnimarray[];
@implementation WinObject

@synthesize  mPattern,mAlive,mThisPlayState,mLineNum,mLargestWinReel,mWinSymbol,mTimer,mWild,mDelegate,mScatter;
-(id)initWithPattern:(NSArray*)pPattern andLineNumber:(NSInteger)pLine andScatterActsAsWild:(BOOL)pScatterIsWild {
    mAlive = TRUE;
    mScatterIsWild = pScatterIsWild;
    if (self = [super init]) {
        
    
        mLineNum = pLine;
        mPattern = [[NSMutableArray alloc] init];
        mThisPlayState = [NSMutableArray new];
        for (NSNumber *obj in pPattern) {

            [mPattern addObject:obj];
            [mThisPlayState addObject:[NSNull null]];
        }
    }
    
    return  self;

}

-(BOOL)behavesAsWild:(NSNumber*)pNum
{

    if ([pNum integerValue] == mWild) {
        return TRUE;
    }
    
    if (mScatterIsWild) {
        
        return [pNum integerValue]== mScatter;
    }
    
    return FALSE;
}
-(BOOL)checkForReel:(NSInteger)pReel andSymbol:(NSMutableArray*)pSlotReel
{
    NSInteger rowNum = [[mPattern objectAtIndex:pReel] integerValue];

    
    if(pReel == 0){
        mWinSymbol = -1;
        mThisWin=0;
        [mThisPlayState replaceObjectAtIndex:pReel withObject:[pSlotReel objectAtIndex:rowNum]];
        mLargestWinReel = pReel;
  return  ( mAlive = TRUE);
        
    }
   
    NSNumber *slotNum = [pSlotReel objectAtIndex:rowNum];

    
    if (!mAlive) {
        [mThisPlayState replaceObjectAtIndex:pReel withObject:slotNum];

        return mAlive;
    }
    
//    NSInteger preVReelRowNum = [mPattern objectAtIndex:(pReel -1)];
    
    NSNumber *prevReelSymbol = nil; //[mThisPlayState objectAtIndex:(pReel -1)];
    
    for (int y = (pReel-1); y>=0; y--) {
    prevReelSymbol = [mThisPlayState objectAtIndex:y];
        
//        if (![prevReelSymbol isEqualToNumber: [NSNumber numberWithInt:(mWild)]]) {
//            mWinSymbol = [prevReelSymbol integerValue];
//            break;
//        }
        
        if (![self behavesAsWild:prevReelSymbol]) {
            mWinSymbol = [prevReelSymbol integerValue];
            break;
        }
        
        
    }

//    if ([prevReelSymbol isEqualToNumber: [NSNumber numberWithInt:(mWild)]]) 

    if ([self behavesAsWild:prevReelSymbol])
        {
        prevReelSymbol = slotNum;
        mWinSymbol = [prevReelSymbol integerValue];

    }
    
//    if ([slotNum isEqualToNumber:prevReelSymbol] || [slotNum  isEqualToNumber:[NSNumber numberWithInt:(mWild)]] ) {

    if ([slotNum isEqualToNumber:prevReelSymbol] || [self behavesAsWild:slotNum] ) {

        [mThisPlayState replaceObjectAtIndex:pReel withObject:slotNum];
        mLargestWinReel = pReel;

        return  ( mAlive = TRUE);
    }
    
    [mThisPlayState replaceObjectAtIndex:pReel withObject:slotNum];
    return (mAlive=false);

}
+(NSInteger)winTimeForSymbol:(NSInteger)mWinSymbol
{
    NSString *name = [[NSString alloc] initWithCString:symbolAnimarray[mWinSymbol] encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *avlDic = [[AppHelper appDelegate] mAvl];
    
    NSMutableDictionary * scene = [[avlDic objectForKey:@"Animation"] objectForKey:[name autorelease]];
    
    
    NSInteger end = [[scene objectForKey:@"EndIndex"] integerValue]; 
    
    return  (end+90)/30;
}

-(NSInteger)winAnimationTime
{

    if (symbolWins[mWinSymbol][mLargestWinReel] ==0) {
        return 0;
    }
        NSString *name = [[NSString alloc] initWithCString:symbolAnimarray[mWinSymbol] encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *avlDic = [[AppHelper appDelegate] mAvl];
    
    NSMutableDictionary * scene = [[avlDic objectForKey:@"Animation"] objectForKey:[name autorelease]];

    
    NSInteger end = [[scene objectForKey:@"EndIndex"] integerValue]; 
    
    return  (end+90)/30;
    
    
}
-(NSInteger)winAmount
{

  return   symbolWins[mWinSymbol][mLargestWinReel] ;
}
-(void)dealloc
{
    self.mDelegate = nil;
    [mTimer release];
    [mThisPlayState release];
    [mPattern release];
    [super dealloc];
}

@end
