//
//  CardGameViewController.m
//  Machismo
//
//  Created by Matija Abicic on 2/10/14.
//  Copyright (c) 2014 Matija Abicic. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property  (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *RestartButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UITextField *LastAction;
@end

@implementation CardGameViewController

-(CardMatchingGame *)game{
    if (!_game)
    {
        //_game=[[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
        _game=[[CardMatchingGame alloc] initWithCardCountAndMatchignTarget:[self.cardButtons count] usingDeck:[self createDeck] targetCount:3];
    }
    return _game;
}

-(Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)switchMoved:(id)sender {
    if (self.switchControl.on == true){
        self.switchLabel.text = @"3 cards";
        self.game.cardsToMatch = 3;
    }
    else {
        self.switchLabel.text = @"2 cards";
        self.game.cardsToMatch = 2;
    }
}

- (IBAction)touchCardButton:(UIButton *)sender {
    //first disable the switch control
    self.switchControl.enabled = false;
    self.switchLabel.enabled = false;
    //now choose the card and update UI
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

-(IBAction)restartGame:(UIButton *) sender{
    //reset score to 0
    [self.game resetScore];
    //reset cards
    for (UIButton *cardButton in self.cardButtons){
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        card.chosen = NO;
        card.matched = NO;
    }
    _game = nil;
    //start a new game. if switchControl is on, start with 3 cards, otherwise, start with 2
    _game = [self.game initWithCardCountAndMatchignTarget:[self.cardButtons count] usingDeck:[self createDeck] targetCount:self.switchControl.on?3:2];
    //restart the card switch
    self.switchControl.on = true;
    self.switchLabel.text = @"3 cards";
    self.switchControl.enabled = true;
    self.switchLabel.enabled = true;
    //update UI
    [self updateUI];
    
}

-(void)updateUI{
    for(UIButton *cardButton in self.cardButtons)
    {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        //[cardButton setTitle:[self titleForCard:card]forState:UIControlStateNormal];
        //set attributed title instead of default black one
        [cardButton setAttributedTitle:[self attributedTitleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
    }
    self.LastAction.text = [self.game getLastAction];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
}
-(NSString *)titleForCard:(Card *)card{
    return card.isChosen ? card.contents : @"";
}
-(NSMutableAttributedString *)attributedTitleForCard:(Card *)card
{
    //don't worry about non-chosen cards
    if (!card.isChosen){
        return [[NSMutableAttributedString  alloc] initWithString:@""];
    }
    //first, get the mutable attributed string from the concents of the card by calling the old titleForCard
    UIColor *fontColor = [[UIColor alloc] init];
    //first check if it's one of the black suits
    if ([card.contents rangeOfString:@"♣︎"].location != NSNotFound || [card.contents rangeOfString:@"♠︎"].location != NSNotFound)
    {
        fontColor = [UIColor blackColor];
    }
    //if not, it must be a red suit
    else
    {
        fontColor = [UIColor redColor];
    }

    //first set the whole string in suit color
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:[self titleForCard:card] attributes:@{NSForegroundColorAttributeName:fontColor}];

    //the edit the rank portion and set it black
    [result setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0,result.string.length-2)];
    
    
    
    return result;
}

-(UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen?@"cardfront":@"CardBack"];
}

@end
