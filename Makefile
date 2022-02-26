# tdlib build is based on
# https://tdlib.github.io/td/build.html?language=Elixir

#	do not forget to check that devtools are installed with xcode-select --install; \

build-tdlib-dev:
	brew install gperf cmake openssl; \
	git clone https://github.com/tdlib/td.git; \
	cd td && rm -rf build && mkdir build && cd build; \
	cmake -DCMAKE_BUILD_TYPE=Release -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl/ -DCMAKE_INSTALL_PREFIX:PATH=../tdlib -DTD_ENABLE_LTO=ON .. ;\
	cmake --build . --target install; \
	cd .. && cd .. && ls -l td/tdlib

build-tdlib-prod:
	ls -l
