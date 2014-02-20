//
//  PlayingCardDeck.m
//  Machismo
//
//  Created by Matija Abicic on 2/11/14.
//  Copyright (c) 2014 Matija Abicic. All rights reserved.
//

#import "PlayingCardDeck.h"


@implementation PlayingCardDeck

-(instancetype)init{
    self = [super init];
    if (self){
        for (NSString *suit in [PlayingCard validSuits])
            for (NSUInteger rank=1; rank<= [PlayingCard maxRank]; rank++)
            {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
                //NSLog(@"Added card: %@", card.contents);
            }
    }
    return self;
}

@end
