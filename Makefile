#	do not forget to install system wide deps on mac os with xcode-select --install

# cli wrapper is needed to communicate with tdlib through Port
build-tdlib-cli-dev:
	cd tdlib-json-cli; \
	brew install gperf cmake openssl readline; \
	rm -rf td ; \
  git clone git@github.com:tdlib/td.git ; \
	rm -rf Release && mkdir Release && cd Release; \
	cmake -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl/ -DREADLINE_INCLUDE_DIR=/usr/local/opt/readline/include -DREADLINE_LIBRARY=/usr/local/opt/readline/lib/libreadline.dylib -DCMAKE_BUILD_TYPE=Release -DTD_ENABLE_LTO=ON .. ;\
	cmake --build . ;

clean:
	cd tdlib-json-cli; \
	rm -rf Release; \
	rm -rf td;

init:
	touch config/dev.secret.exs; \
	touch config/test.secret.exs

build-tdlib-cli-prod:
	ls -l
