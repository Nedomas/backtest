# Backtest

A trading strategy backtesting gem.

## Installation

Add this line to your application's Gemfile:

    gem 'backtest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install backtest

## Usage

	.strategy(
		:long_open => [[:sma, 10, :crosses_above, :sma, 15], :and, [:sma, 11, :crosses_above, :sma, 16]],
		:long_close => [[:sma, 10, :crosses_above, :sma, 15], :and, [:sma, 11, :crosses_above, :sma, 16]],
		:short_open => [[:sma, 10, :crosses_above, :sma, 15], :and, [:sma, 11, :crosses_above, :sma, 16]],
		:short_close => [[:sma, 10, :crosses_above, :sma, 15], :and, [:sma, 11, :crosses_above, :sma, 16]],
		:target => 0.1,
		:stop_loss => 0.2,
		)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
