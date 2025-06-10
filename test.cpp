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
};

void testCard() {
    Card card(10);
    printf("Card value: %d\n", card.getValue());
    printf("Card suit: %d\n", card.getSuit());
    printf("Card rank: %d\n", card.getRank());

    printf("trying iostream\n");
    std::cout << card << std::endl;
}


int main() {

    Deck deck;
    deck.init();
    deck.shuffle();
    
    return 0;
}
