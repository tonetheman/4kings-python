#include <cstdio>
#include <iostream>
#include <vector>
#include <random>

class Card {
    public:
        int value;
        int suit;
        int rank;
	Card() : value(0) {}
        Card(int value) : value(value),suit(value/13),rank(value%13) {}
        int getValue() const { return value; }
        void setValue(int value) {
            this->value = value;
            this->suit = value / 13;
            this->rank = value % 13;
        }
        int getSuit() const { return suit; }
        int getRank() const { return rank; }
	friend std::ostream& operator<<(std::ostream& os, const Card& src) {
		os << src.rank << " " << src.suit;
		return os;
	}
};

class Deck {
    public:
        std::vector<Card> cards;
        Deck() {}
        Card getCard(int index) const { return cards[index]; }

        void addCard(const Card& card) {
            cards.push_back(card);
        }

        void init() {
            cards.clear();
            for (int i = 0; i < 52; ++i) {
                cards.push_back(Card(i));
            }
        }

        void shuffle() {
           std::random_device rd;
           std::mt19937 g(rd());
           std::shuffle(this->cards.begin(), this->cards.end(), g);
       }
};

class Pile {
    public:
        std::vector<Card> cards;
        Pile() {}
    void addCard(const Card& card) {
        cards.push_back(card);
    }
	int size() const {
		return cards.size();
	}
	bool empty() const {
		return cards.empty();
	}
    void printPile() const {
        for (const auto& card : cards) {
            std::cout << card << std::endl;
        }
    }
    friend std::ostream& operator<<(std::ostream& os, const Pile& src) {
        os << "Pile size: " << src.size() << "\n";
        for (const auto& card : src.cards) {
            os << card << "\n";
        }
        return os;
    }
};

void testCard() {
    Card card(10);
    printf("Card value: %d\n", card.getValue());
    printf("Card suit: %d\n", card.getSuit());
    printf("Card rank: %d\n", card.getRank());

    printf("trying iostream\n");
    std::cout << card << std::endl;
}

void testPile() {
    Deck deck;
    deck.init();
    deck.shuffle();
    Pile p;
    for (int i = 0; i < 3; ++i) {
        p.addCard(deck.getCard(i));
    }
    std::cout << "Pile: " << p << "\n";

}

bool isKing(const Card& card) {
    return card.getRank() == 12; // King is rank 12
}

bool checkForEnd(int king_count) {
    return king_count == 4; // Game ends when 4 kings are found
}

void one_hand() {
    Deck deck;
    deck.init();
    deck.shuffle();

    std::vector<Pile> piles(12);
    int index=0;
    for (int i = 0; i < 12; ++i) {
        piles[i].addCard(deck.getCard(index++));
        piles[i].addCard(deck.getCard(index++));
        piles[i].addCard(deck.getCard(index++));
        piles[i].addCard(deck.getCard(index++));
    }

    std::cout << "piles[0]: " << piles[0] << "\n";

    Card c = deck.getCard(index++);
    int king_count = 0;
    while (true) {
        if (isKing(c)) {
            king_count++;
            if (checkForEnd(king_count)) {
                std::cout << "Game over! Found 4 kings.\n";
                break;
            }
            // not the end keep playing
            // need to draw a new card
            c = deck.getCard(index++);
            if (isKing(c)) {
                king_count++;
                if (checkForEnd(king_count)) {
                    std::cout << "Game over! Found 4 kings.\n";
                    break;
                }

                // not the end keep playing
                c = deck.getCard(index++);
                if (isKing(c)) {
                    king_count++;
                    if (checkForEnd(king_count)) {
                        std::cout << "Game over! Found 4 kings.\n";
                        break;
                    }
                }
            }
        }

        Pile p = piles[c.getRank()];
        Card new_card = p.cards.back();
        // need to put the drawn card c
        // on this pile
        // then the new card will become the new c
    
    }
}

int main() {

    one_hand();
    
    return 0;
}
