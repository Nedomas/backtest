require 'securities'
require 'indicators'

module Backtest
	class Backtest

		attr_reader :output

		# Initialize with Backtest::Backtest.new(:symbols => ["aapl"],
		# 																			 :start_date => '2010-01-01', 
		# 																			 :end_date => '2010-12-01', 
		# 																			 :periods => :daily,
		#   																		 :criteria => [
		# 																											{ 
	  # 																											}
	  # 																										]
		#                                        :buy => {
		# 																								:1_indicator_name => :sma,
		# 																								:1_indicator_params => 15,
		# 																								:
		# 																								}
		#  																			 :buy => "sma(10) > sma(20)"
		#  																			 :sell => "price > initial_price + initial_price*0,1"
		#  																			 :short => "sma(10) > sma(20)"
		#  																			 :cover => "price > initial_price - initial_price*0,1"
		# 																				)
		def initialize parameters
			puts parameters
			@output = Array.new
			@buy_at = Array.new
			@sell_at = Array.new
			current_trend = nil
			my_data = Securities::Stock.new(["aapl"]).history(:start_date => '2010-01-01', :end_date => '2010-12-01')
			my_indicators = Indicators::Data.new(my_data)
			sma1 = my_indicators.calc(:type => :sma, :params => 5).output["aapl"]
			sma2 = my_indicators.calc(:type => :sma, :params => 10).output["aapl"]

			sma2.each_with_index do |sma, index|
				if !sma2[index].nil?
					# puts "#{sma1[index]} and #{sma2[index]}"
					if sma1[index] > sma2[index]

						# faster is above slower
						if current_trend == nil
							# start up
							current_trend = :up
							@output[index] = "#{sma1[index]} and #{sma2[index]}"
						elsif current_trend != :up
							current_trend = :up
							@buy_at << my_data["aapl"][index][:date]
							# puts "Should get in uptrend here #{sma1[index]} and #{sma2[index]} was #{sma1[index-1]} and #{sma2[index-1]}"
						end

					else

						# faster is below slower
						if current_trend == nil
							# start down
							current_trend = :down
						elsif current_trend != :down
							current_trend = :down
							@sell_at << my_data["aapl"][index][:date]
							# puts "Should get in downtrend here #{sma1[index]} and #{sma2[index]} was #{sma1[index-1]} and #{sma2[index-1]}"
						end

					end



				else
					@output[index] = nil
				end
			end

		end

	end

end
	# my_stocks = Securities::Stock.new(["aapl", "yhoo"])

	# my_data = my_stocks.history(:start_date => '2012-01-01', :end_date => '2012-02-01', :periods => :weekly)