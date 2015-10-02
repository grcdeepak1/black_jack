# 1. Welcome player to Blackjack game and get player's name
# 2. Initialize deck of cards
# 3. Deal 2 cards each to player and dealer
# 4. Check for blackjack winner (21) if winner? - print winner msg and exit
# 5. Player can choose to Hit/Stay in a loop - exit out of loop if (stay || 21 || bust)
# 6. If (21 or bust) - print winner/looser msg and exit
# 7. Hit/Stay for dealer in a loop - exit out of loop if (stay || 21 || bust)
# 8. If (21 or bust) - print winner/looser msg and exit
# 9. Compare player's card and dealer's card - closest to 21 wins; Same - tie or push

require "highline/import"
require 'pry'
CARD_NUM   = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
CARD_SUIT  = ["\u2660", "\u2665", "\u2666", "\u2663"]

def my_ask(msg)
  return ask "=> #{msg}"
end

def say(msg)
  puts "=> #{msg}"
end

def init_deck()
  CARD_NUM.product(CARD_SUIT)
end

def show_cards(deck, owner)
  print "=> #{owner}'s cards:\t"
  deck.each do |card|
    print " "
    print card.join
  end
  value = calculate_total(deck)
  print "\t total: #{value}"
  print "\n"
end

def calculate_total(cards) 
  # [['H', '3'], ['S', 'Q'], ... ]
  arr = cards.map{|e| e[0] }
  total = 0
  arr.each do |value|
    if value == "A"
      total += 11
    elsif value.to_i == 0 # J, Q, K
      total += 10
    else
      total += value.to_i
    end
  end

  #correct for Aces
  arr.select{|e| e == "A"}.count.times do
    total -= 10 if total > 21
  end
  total
end


def deal_card(deck, player_cards)
  new_card = deck.shuffle.pop
  index = deck.find_index(new_card)
  if index
    deck.delete_at(index)
    player_cards << new_card
  end
end

def check_winner(player_cards)
  count = calculate_total(player_cards)
  if(count == 21)
    say("Blackjack! - You Win")
    return "blackjack"
  elsif(count > 21)
    say("Busted! - You Lose")
    return "busted"
  else
    return nil
  end
end

#Start of Game
system 'clear'
say("Welcome to Blackjack!")
player_name = my_ask("Please Enter your Name : ") 
say("Hello #{player_name}, Let's play some Blackjack!")

#Game Loop
begin
  deck = init_deck
  player_cards = []
  dealer_cards = []
  play_again = nil
  dealer_value = 0
  player_value = 0

  #Deal and show cards and total
  say("Dealing 2 cards to #{player_name}")
  2.times do
    deal_card(deck, player_cards)
    deal_card(deck, dealer_cards)
  end
  show_cards(dealer_cards, "Dealer")
  show_cards(player_cards, player_name)

  #Check for winner, exit game if there is a winner
  if(check_winner(player_cards))
    play_again = ask("Hey #{player_name}, do you want to play again ? (y/n)")
    next
  end

  #Player's chance
  player_value = calculate_total(player_cards)
  player_action = ask("Choose Either to 1) Hit 2) Stay:", Integer) { |q| q.in = 1..2 }
  system 'clear'
  while (player_action == 1)
    deal_card(deck, player_cards)
    show_cards(player_cards, player_name)
    player_value = calculate_total(player_cards)
    if(check_winner(player_cards))
      play_again = ask("Hey #{player_name}, do you want to play again ? (y/n)")
      break
    end
    player_action = ask("Choose Either to 1) Hit 2) Stay:", Integer) { |q| q.in = 1..2 }
  end

  next if play_again

  #Dealer's chance
  dealer_value = calculate_total(dealer_cards)
  if (dealer_value < 17)
    say("Dealing cards for dealer..")
  end
  while (dealer_value < 17)
    deal_card(deck, dealer_cards)
    show_cards(dealer_cards, "Dealer")
    dealer_value = calculate_total(dealer_cards)
  end

  #Logic to decide winner
  if (dealer_value == player_value)
    say("It's a push/Tie !")
  elsif(dealer_value > 21)
    say("Dealer Busted!, You Win")
  elsif(dealer_value < player_value)
    say("You Win!")
  elsif(dealer_value > player_value)
    say("Dealer Wins!")
  end

  play_again = ask("Hey #{player_name}, do you want to play again ? (y/n)")
end until play_again == "n"

