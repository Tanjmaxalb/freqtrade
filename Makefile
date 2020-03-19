arch := $(shell uname -m)
image_basename := freqtrade

ifneq (,$(wildcard ./Dockerfile.$(arch)))
    dockerfile := Dockerfile.$(arch)
    image := $(image_basename):$(arch)
else
    dockerfile := Dockerfile
    image := $(image_basename)
endif

build:
	docker build -t $(image) -f $(dockerfile) .

run/%:
	docker run -d \
	    --name $(image_basename)_$(notdir $@) \
	    -v $$(pwd)/user_data:/freqtrade/user_data \
	    $(image) \
		trade \
		    --logfile /freqtrade/user_data/freqtrade_$(notdir $@).log \
		    --db-url sqlite:////freqtrade/user_data/tradesv3_$(notdir $@).sqlite \
		    --config /freqtrade/user_data/config_$(notdir $@).json \
		    --strategy $(notdir $@) \
		    $(filter-out $@,$(MAKECMDGOALS))

tail/%:
	tail -f user_data/freqtrade_$(notdir $@).log

logs/%:
	docker logs $(image_basename)_$(notdir $@)

stop/%:
	docker stop $(image_basename)_$(notdir $@)

rm/%:
	docker rm $(image_basename)_$(notdir $@)
