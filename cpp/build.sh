#!/usr/bin/env sh
MONGODB_CXX_VERSION=3.6.7
if [ ! -d "lib" ]
then
  curl -OL https://github.com/mongodb/mongo-cxx-driver/releases/download/r$MONGODB_CXX_VERSION/mongo-cxx-driver-r$MONGODB_CXX_VERSION.tar.gz
  mkdir -p lib
  tar -xzf mongo-cxx-driver-r$MONGODB_CXX_VERSION.tar.gz -C lib
  rm mongo-cxx-driver-r$MONGODB_CXX_VERSION.tar.gz
  pushd lib/mongo-cxx-driver-r$MONGODB_CXX_VERSION/build
  cmake .. -DBSONCXX_POLY_USE_BOOST=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local
  cmake --build . --target EP_mnmlstc_core -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  make install
  popd
  # Generate a Compilation Database for IDEs.
  python -m pip install compdb
  compdb -p lib/mongo-cxx-driver-r${MONGODB_CXX_VERSION}/build/ list > compile_commands.json
fi

export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig"
export INCLUDE="/opt/homebrew/include/boost"

clang++ -std=c++17 $(pkg-config --cflags --libs libmongocxx) $(pkg-config --cflags --libs sdl2) -lSDL2_mixer -lSDL2_ttf -o leafie_pong Main.cpp

if [[ $(uname -m) == 'arm64' ]]; then
  # arm64 requires extra reparation steps.
  install_name_tool -change @rpath/libbsoncxx._noabi.dylib $HOME/.local/lib/libbsoncxx._noabi.dylib leafie_pong
  install_name_tool -change @rpath/libmongocxx._noabi.dylib $HOME/.local/lib/libmongocxx._noabi.dylib leafie_pong
fi