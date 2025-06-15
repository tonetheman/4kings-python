from random import shuffle
from math import divmod

const KING=12

type Card = object
    val : int

func suit(c:Card) : int =
    return divmod(c.val,13)[0]
func rank(c:Card) : int =
    return divmod(c.val,13)[1]

func initCard(v:int) : Card =
    result.val = v

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
                    
    echo("deck before we start loop ",deck)
    while true:
        echo("start of loop",loopcounter)

        block findACard:
            while true:
                # pull a card
                mycard = deck.pop()
                echo("we pulled a card ",mycard)
                # if it is a king
                if mycard.rank()==KING:
                    echo("we found a king")
                    # bump the kingcount
                    kingcount+=1
                    # are we done
                    if check_for_end():
                        echo("we found all the kings")
                        break # totally done
                else:
                    echo("we are leaving findACard")
                    break findACard                

        echo("start of block mycard is ",mycard," rank is ",mycard.rank())

        echo("rank of mycard",mycard.rank())
        let r = mycard.rank()
        let newcard = piles[r].pop()
        echo("newcard is set to",newcard)
        piles[r].push_front(mycard)
        echo("piles value",piles[mycard.rank()])
        
        echo("")

        loopcounter+=1
        

onehand()
