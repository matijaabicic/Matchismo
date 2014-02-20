//
//  CardMatchingGame.h
//  Machismo
//
//  Created by Matija Abicic on 2/13/14.
//  Copyright (c) 2014 Matija Abicic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
-(instancetype)initWithCardCountAndMatchignTarget:(NSUInteger)count usingDeck:(Deck *)deck targetCount:(NSUInteger)target;
-(void)chooseCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;
-(void) resetScore;
-(NSString *)getLastAction;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSInteger cardsToMatch;
@end
