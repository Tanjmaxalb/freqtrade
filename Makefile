build:
	docker build -t freqtradeorg/freqtrade .

run/%:
	docker run -it \
	    -v $$(pwd)/user_data:/freqtrade/user_data \
	    freqtradeorg/freqtrade \
		trade \
		    --logfile /freqtrade/user_data/freqtrade_$(notdir $@) \
		    --db-url sqlite:////freqtrade/user_data/tradesv3_$(notdir $@).sqlite \
		    --config /freqtrade/user_data/config_$(notdir $@).json \
		    --strategy strategy_$(notdir $@) \
		    $(filter-out $@,$(MAKECMDGOALS))
