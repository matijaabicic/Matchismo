//
//  CardMatchingGame.m
//  Machismo
//
//  Created by Matija Abicic on 2/13/14.
//  Copyright (c) 2014 Matija Abicic. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of card
@property (nonatomic) NSUInteger cardsCurrentlyActive;
@property (nonatomic, strong) NSMutableArray *matchingQueue; //of card
@property (strong, nonatomic) NSString *lastAction;
@end

@implementation CardMatchingGame

static const int MISSMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(NSMutableArray *)matchingQueue
{
    if(!_matchingQueue){
        _matchingQueue = [[NSMutableArray alloc] init];
    }
    return _matchingQueue;
}
-(NSMutableArray *)cards{
    if(!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}
-(NSString *)getLastAction{
    return self.lastAction;
}
-(void)resetScore{
    self.score=0;
}
-(instancetype)initWithCardCountAndMatchignTarget:(NSUInteger)count usingDeck:(Deck *)deck targetCount:(NSUInteger)target
{
    self = [self initWithCardCount:count usingDeck:deck];
    self.cardsToMatch = target;
    return self;
}
-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    self.cardsCurrentlyActive=0;
    if (self){
        for(int i=0; i<count;i++){
            Card *card = [deck drawRandomCard];
            if(card){
                [self.cards addObject:card];
            }
            else{
                self = nil;
                break;
            }
        }
    }
    return self;
}
-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index< [self.cards count]) ? self.cards[index]:nil;
}

-(void)evaluateMatches:(NSMutableArray *)matchingQueue{
    NSInteger startingScore = self.score;
    NSString *actionDescription=@"";
    int numberOfMatches = 0;
    //traverse the mathingQueue and match all cards to all other cards
    for (int i=0; i<[matchingQueue count]-1; i++){
        Card *matchingCard = [matchingQueue objectAtIndex:i];
        for (int j=i+1; j<[matchingQueue count]; j++){
            Card *otherCard = [matchingQueue objectAtIndex:j];
            int matchScore = [matchingCard match:@[otherCard]];
            if (matchScore){
                self.score += matchScore * MATCH_BONUS;
                matchingCard.matched = YES;
                otherCard.matched = YES;
                numberOfMatches++;
            }
            else
            {
                //apply missmatch penalty for all missmatches
                self.score -= MISSMATCH_PENALTY;
                
            }
        }
    }
    //if we don't have any matches, flip all the cards back except the last one.
    for (Card *card in matchingQueue)
    {
        actionDescription = [actionDescription stringByAppendingString:card.contents];
        if (![matchingQueue indexOfObject:card]==[matchingQueue count])
        {
            actionDescription = [actionDescription stringByAppendingString:@" "];
        }
        if (!numberOfMatches) {
            card.chosen = NO;
        }
        else
        {
            card.matched = YES;
        }
    }
    if (!numberOfMatches){
        Card *lastCard = [matchingQueue lastObject];
        lastCard.chosen= YES;
        [self.matchingQueue removeAllObjects];
        [self.matchingQueue addObject:lastCard];
        self.cardsCurrentlyActive = 1;
        actionDescription = [NSString stringWithFormat:@"%@ don't match! %li point penalty!", actionDescription, self.score-startingScore];
    }
    else
    {
        [self.matchingQueue removeAllObjects];
        self.cardsCurrentlyActive=0;
        actionDescription = [NSString stringWithFormat:@"Matched %@ for %li points", actionDescription, self.score-startingScore];
        
    }
    self.lastAction = actionDescription;
}


-(void)chooseCardAtIndex:(NSUInteger)index{
    self.cardsCurrentlyActive++;
    Card *card = [self cardAtIndex:index];
    self.lastAction = [NSString stringWithFormat:@"%@", card.contents];
    if (!card.isMatched)
    {
        if(card.isChosen)
        {
            card.chosen=NO;
            self.cardsCurrentlyActive-=2;
            [self.matchingQueue removeObject:card];
            self.lastAction = @"";
        }
        else{
            //add the card to the matching queue
            [self.matchingQueue addObject:card];
            //when N-th card is open - evaluate cards
            if (self.cardsCurrentlyActive == self.cardsToMatch){
                [self evaluateMatches:_matchingQueue];
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

-(instancetype)init{
    return nil;
}

@end
