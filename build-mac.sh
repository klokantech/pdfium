#/bin/sh

PREFIX=/usr/local

set -e

if [ "$1" = "gyp" ]; then
  mkdir pdfium_deps
  cd pdfium_deps
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
  git clone https://chromium.googlesource.com/external/gyp.git
  cd depot_tools
  export PATH=`pwd`:$PATH
  cd ..
  cd gyp
  ./setup.py install
  cd ..
fi

if [ "$1" = "download" ]; then
  # Download pdfium
  git clone https://github.com/klokantech/pdfium
  cd pdfium
fi

./build/gyp_pdfium

# pdfium.xcodeproj
xcodebuild -configuration Release_x64 \
  -target pdfium \
  -target fdrm \
  -target fpdfdoc \
  -target fpdfapi \
  -target fpdftext \
  -target fxcodec \
  -target fxcrt \
  -target fxge \
  -target fxedit \
  -target pdfwindow \
  -target formfiller

# third_party.xcodeproj
cd third_party
xcodebuild -configuration Release_x64 \
  -target bigint \
  -target freetype \
  -target fx_agg \
  -target fx_lcms2 \
  -target fx_zlib \
  -target pdfium_base \
  -target fx_libjpeg \
  -target fx_libopenjpeg
cd ..

# Copy libraries into $PREFIX
sudo mkdir -p $PREFIX/lib/pdfium
sudo cp xcodebuild/Release_x64/lib*.a $PREFIX/lib/pdfium/

# Copy all headers
sudo mkdir -p $PREFIX/include/pdfium/fpdfsdk/include
sudo mkdir -p $PREFIX/include/pdfium/core/include
sudo mkdir -p $PREFIX/include/pdfium/third_party/base/numerics
sudo cp -r public/*.h $PREFIX/include/pdfium/
sudo cp -r fpdfsdk/include/* $PREFIX/include/pdfium/fpdfsdk/include/
sudo cp -r core/include/* $PREFIX/include/pdfium/core/include
sudo cp -r third_party/base/numerics/* $PREFIX/include/pdfium/third_party/base/numerics
sudo cp -r third_party/base/* $PREFIX/include/pdfium/third_party/base/

echo "./configure --with-pdfium=$PREFIX"