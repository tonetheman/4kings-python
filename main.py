import math
import random

# arbitrary choice
KING = 12

class Card:
    def __init__(self,v):
        self.rank = v%13
        self.suit = math.floor(v/13)
    def __repr__(self):
        return "{0} {1}".format(self.rank,self.suit)

def fisher_yates_shuffle(arr):
    for i in range(len(arr) - 1, 0, -1):
        j = random.randint(0, i)
        arr[i], arr[j] = arr[j], arr[i]
    return arr
    
class Deck:
    def __init__(self):
        self.cards = []
        for i in range(52):
            self.cards.append(Card(i))
    
    def pop(self):
        return self.cards.pop()

    def shuffle(self):
        fisher_yates_shuffle(self.cards)

    def __repr__(self):
        ts = str(self.cards)
        return ts

class Pile:
    def __init__(self):
        self.cards = []
    def __repr__(self):
        ts = ""
        for i in range(len(self.cards)):
            ts = ts + self.cards[i].__repr__() + "\t"
        return ts
    def push(self,c):
        """
        just put the card into the pile
        """
        self.cards.append(c)
    def push_bottom(self,c):
        self.cards.insert(0,c)
    def pop(self):
        return self.cards.pop()

def one_hand(simcount):
    # one deck
    d = Deck()
    # shuffle it
    d.shuffle()
    # make 12 piles
    piles = []
    for i in range(12):
        # print("making pile",i)
        piles.append(Pile())
    index = 0
    for i in range(52-4):
        piles[index].push(d.pop())
        index += 1
        if index==12:
            index = 0


    print("running simcount",simcount)
    # grab the top card that is left from the deck
    mycard = d.pop()
    loopcount=0
    king_count = 0
    while True:
        # print(loopcount,"start of loop...")
        # print("mycard",mycard)

        if mycard.rank == KING:
            # print("mycard is a KING need to get a new card",mycard)
            # bump up the king count
            king_count += 1
            # if we have them all we are done
            if king_count==3:
                print("king count was 3 we are done")
                break
            # pull a new card
            mycard = d.pop()
            if mycard.rank==KING:
                # print("WTF we pulled a 2nd king")
                # bad luck we pulled a king!
                king_count += 1
                if king_count==3:
                    print("king count was 3 we are done")
                    break
                # pull a new card
                mycard = d.pop()
                if mycard.rank == KING:
                    print("WTF we pulled a 3rd king ... impossible")
                    king_count += 1
                    if king_count==3:
                        print("king count was 3 we are done")
                        break

        # pile we care about
        p = piles[mycard.rank]
        # print("pile it should move to",p)

        # grab top card from the pile in question
        newcard = p.pop()
        # print("pile after pop",p)
        # print("newcard",newcard)

        # put the card 
        p.push_bottom(mycard)
        # print("pile after push bottom",p)

        # set the card for the next round
        mycard = newcard

        loopcount+=1

    def score_piles():
        in_place = 0
        for i,v in enumerate(piles):
            for j,jv in enumerate(v.cards):
                if i==jv.rank:
                    in_place += 1
        print("in place is",in_place)
        return in_place

    """
    if simcount==56:
        for i,v in enumerate(piles):
            print(i)
            print(v)

    """

    # print("deck at end",d)
    return score_piles()

index = 0
win_count = 0
while True:
    res = one_hand(index)
    index += 1
    if res==48: # this is a win!
        win_count += 1
    
    if index>110000:
        break
print("index",index)
print("win count",win_count)

