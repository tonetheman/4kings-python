from random import shuffle, randomize
from math import divmod
from std/times import getTime, toUnix, nanosecond

randomize()

const KING=12

type Card = object
    val : int
    rank : int
    suit : int

proc repr(c:Card) : string =
    return $c.rank

func initCard(v:int) : Card =
    result.val = v
    let tmp = divmod(v,13)
    result.suit = tmp[0]
    result.rank = tmp[1]

type Pile = object
    cards : seq[Card]

func initPile() : Pile =
    result.cards = newSeq[Card](0)
func push(self:var Pile,c:Card) =
    self.cards.insert(c,len(self.cards))
func push_front(self:var Pile,c:Card) =
    self.cards.insert(c,0)
func pop(self:var Pile) : Card =
    return self.cards.pop()

proc onehand() : bool =

    # create a deck and shuffle it
    var deck = initPile()
    for i in 0..51:
        deck.push(initCard(i))
    shuffle(deck.cards)

    # setup the piles
    var piles : array[12,Pile]
    for i in 0..11:
        piles[i] = initPile()

    proc printPiles() =
        for i in 0..11:
            echo(i," ",piles[i])

    proc scorePiles() :bool =
        var scores : array[12,int]
        for i in 0..11:
            for j in 0..3:
                if piles[i].cards[j].rank==i:
                    scores[i]+=1
        # echo("scores",scores)
        var junk = 0
        for i in 0..11:
            if scores[i]==4:
                junk+=1
        if junk==12:
            return true
        return false
                

    
    # deal cards into the piles
    var index = 0
    for i in 0..47:
        piles[index].push(deck.pop())
        index = index + 1
        if index==12:
            index = 0

    # start of the main loop
    # at this point there are 4 cards left
    var mycard : Card
    var kingcount = 0
    
    func check_for_end() : bool =
        return kingcount==3

    var loopcounter = 0
    
    proc draw_card() : bool =

        var done = false
        while not done:
            # grab a card
            mycard = deck.pop()
            if mycard.rank == KING:
                kingcount+=1
                if check_for_end():
                    # echo("check for end said game was over!")
                    done = true
                    return true
            else:
                # we are done we got a card
                # it was not a king
                done = true
                continue
        return false

    # echo("deck before we start loop ",deck)
    # this will set the value of mycard
    var game_over = draw_card()
    if game_over:
        echo("WOW game was over before it started")
        # printPiles()
        return scorePiles()
        

    while true:
        # echo("start of loop",loopcounter)
        # echo("rank of mycard",mycard.rank)
        
        let r = mycard.rank
        piles[r].push_front(mycard)
        let newcard = piles[r].pop()
        # echo("newcard is set to",newcard)
        if newcard.rank == KING:
            # echo("the card pulled from the board was a king!")
            kingcount+=1
            if check_for_end():
                # echo("game is over")
                # printPiles()
                return scorePiles()
            game_over = draw_card()
            if game_over:
                # echo("game is over!")
                # printPiles()
                return scorePiles()
        else:
            mycard = newcard
        
        # echo("")

        loopcounter+=1

var wincount=0
var loscount=0
const SIMCOUNT = 100_000
for i in 0..SIMCOUNT:
    let r = onehand()
    if r:
        wincount+=1
    else:
        loscount+=1
echo("wincount    : ",wincount)
echo("losecount   : ",loscount)
echo("percent win : ", wincount/loscount*100.0)