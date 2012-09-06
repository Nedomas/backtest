require 'securities'
require 'indicators'

module Backtest
	class Data

		class BacktestException < StandardError
		end

		attr_reader :data, :position_output
		# Initialize with my_backtest = Backtest::Data.new(:symbols => ["aapl"],
		# 																	 :start_date => '2010-01-01', 
		# 																	 :end_date => '2010-12-01', 
		# 																	 :periods => :daily)
		def initialize parameters
			symbols = parameters[:symbols]
			parameters.delete("symbols")
			@data = Indicators::Data.new(Securities::Stock.new(symbols).history(parameters))
			@position_output = nil
		end

		# .strategy(
		# 	POSITION:long_open CRITERIA=> CRITERION[:sma, 10, :crosses_above, :sma, 15], :and, CRITERION[:sma, 11, :crosses_above, :sma, 16], [:sma, 12, :crosses_above, :sma, 15]},
		# 	:long_close => {:indicators => [:sma, :sma], },
		# 	:short_open => {:indicators => [:sma, :sma], },
		# 	:short_close => {:indicators => [:sma, :sma], },
		# 	:target => { 0.1 },
		# 	:stop_loss => { 0.2 },
		# 	)
		def strategy positions
			@position_output = Hash.new
			positions.each do |position, criteria|
				# puts "For position #{position}"
				criteria_values = calculate_criteria_output(criteria, :values)
				criteria_actions = calculate_criteria_output(criteria, :actions)
				
				unless criteria_actions.length == criteria_values.length-1
					raise BacktestException, "There is incorrect number of actions or criteria specified."
				end
				criteria_actions.each_with_index do |action, index|
					if action == :and
						@position_output[position] = criteria_values[index] & criteria_values[index+1]
					elsif action == :or
						@position_output[position] = criteria_values[index] | criteria_values[index+1]
					end
				end
			end
			return @position_output
		end

		private

			def calculate_criteria_output criteria, get=:values
				values_output = Array.new
				actions_output = Array.new
				criteria.each do |criterion|
					if criterion.is_a?(Array)
						values_output << calculate_criterion_output(criterion)
					elsif criterion.is_a?(Symbol)
						actions_output << criterion
					else
						raise BacktestException, "Invalid criteria parameter '#{criterion}'."
					end
				end
				# should return days where to the action (crosses) happened.
				if get == :actions
					return actions_output
				else
					return values_output
				end
			end

			def calculate_criterion_output criterion
				criterion_output = []
				previous_pair = [0.0, 0.0]
				first_output = @data.calc(:type => criterion[0], :params => criterion[1]).output.values.first
				second_output = @data.calc(:type => criterion[3], :params => criterion[4]).output.values.first
				# returns [[12.3, 12.1], [11.2, 11.0]]
				first_output.zip(second_output).each_with_index do |pair, prindex|
					unless pair.include?(nil)
						# puts "previ=#{previous_pair}"
						if criterion[2] == :crosses_above
							if pair[0] > pair[1] && previous_pair[0] < previous_pair[1]
								criterion_output << prindex
							end
						elsif criterion[2] == :crosses_below
							if pair[0] < pair[1] && previous_pair[0] > previous_pair[1]
								criterion_output << prindex
							end
						end
						previous_pair = pair
					end
				end
				return criterion_output
			end

	end
end