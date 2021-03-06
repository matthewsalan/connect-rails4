class Game < ActiveRecord::Base
  has_many :players
  has_many :users, through: :players

  validates_length_of :users, maximum: 2, message: "can have at most two players."

  serialize :state

  $board = {:a => ["a1", "a2", "a3", "a4", "a5", "a6"],
           :b => ["b1", "b2", "b3", "b4", "b5", "b6"],
           :c => ["c1", "c2", "c3", "c4", "c5", "c6"],
           :d => ["d1", "d2", "d3", "d4", "d5", "d6"],
           :e => ["e1", "e2", "e3", "e4", "e5", "e6"],
           :f => ["f1", "f2", "f3", "f4", "f5", "f6"],
           :g => ["g1", "g2", "g3", "g4", "g5", "g6"]
  }

  def initialize(player_1, player_2)
    @board = $board
    @player_1 = player_1
    @player_2 = player_2
    @player_1piece = "black"
    @player_2piece = "red"
    @turns = 42
    @row = 0
    @col = 0
    @next_player = @player_1
    super()
  end



  def show_board
    puts board
  end

  def self.waiting
    Game.where(:players_count => 1)
  end

  def self.active
    Game.where(:finished => false)
  end

  def place_piece (col, piece)
    col_height = 6
    while @board[@col][col_height].length != 2 && col_height >0
      col_height -= 1
    end
    if col_height == 0
      puts 'Get out of here, this is full.'
      pick_col
    end
    @board[col][col_height]=piece

  end

  def pick_col
    @col = @next_player

    piece = @next_player == @player_1 ? @player_1piece : @player2_piece
    place_piece(@col, piece)
  end

  def take_turn
  puts "It is #{@next_player}'s turn."
   show_board
   pick_col
   @next_player = @player1 == @next_player ? @player2 : @player1
   @turns -= 1
  end

  def can_move?(user)
    if self.turn_count.even?
      user == self.users.first
    else
      user == self.users.second
    end

  end
end
