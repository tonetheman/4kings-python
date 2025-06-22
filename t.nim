from random import shuffle
from math import divmod

const KING=12

type Card = object
    val : int
    rank : int
    suit : int

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

proc testPilePushPop() =
    var p = initPile()
    p.push(initCard(10))
    echo(p)
    p.push(initCard(11))
    echo(p)
    echo(p.pop())
    echo(p.pop())
    echo(p.pop())

proc testDeckShuffle() =
    var deck = initPile()
    for i in 0..51:
        deck.push(initCard(i))
    shuffle(deck.cards)
    echo(deck)

proc onehand() =

    # create a deck and shuffle it
    var deck = initPile()
    for i in 0..51:
        deck.push(initCard(i))
    shuffle(deck.cards)

    # setup the piles
    var piles : array[12,Pile]
    for i in 0..11:
        piles[i] = initPile()
    
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
    
    proc draw_card() =

        var done = false
        while not done:
            # grab a card
            mycard = deck.pop()
            if mycard.rank == KING:
                kingcount+=1
                if check_for_end():
                    echo("check for end said game was over!")
                    done = true
                    continue
            else:
                # we are done we got a card
                # it was not a king
                done = true
                continue

    echo("deck before we start loop ",deck)
    # this will set the value of mycard
    draw_card()

    while true:
        echo("start of loop",loopcounter)
        echo("rank of mycard",mycard.rank)
        let r = mycard.rank
        let newcard = piles[r].pop()
        echo("newcard is set to",newcard)
        if newcard.rank == KING:
            echo("the card pulled from the board was a king!")
            kingcount+=1
            draw_card()
        else:
            piles[r].push_front(mycard)
            echo("piles value",piles[mycard.rank])
        
        echo("")

        loopcounter+=1
        if loopcounter==4:
            echo("stopping for loopcounter")
            break

onehand()
