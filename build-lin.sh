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
  cd .. # outside of pdfium_deps
fi

if [ "$1" = "download" ]; then
  # Download pdfium
  git clone https://github.com/klokantech/pdfium
  cd pdfium
fi

./build/gyp_pdfium

make -j `nproc` BUILDTYPE=Release \
  pdfium \
  fdrm \
  fpdfdoc \
  fpdfapi \
  fpdftext \
  fxcodec \
  fxcrt \
  fxge \
  fxedit \
  pdfwindow \
  formfiller

# third_party targets
make -j `nproc` BUILDTYPE=Release \
  bigint \
  freetype \
  fx_agg \
  fx_lcms2 \
  fx_zlib \
  pdfium_base \
  fx_libjpeg \
  fx_libopenjpeg

# Transform to normal static libraries
if [ "$1" = "normal" ]; then
  cd out/Release/obj.target
  for lib in `find -name '*.a'`;
      do ar -t $lib | xargs ar rvs $lib.new && mv -v $lib.new $lib;
  done
  cd third_party
  for lib in `find -name '*.a'`;
      do ar -t $lib | xargs ar rvs $lib.new && mv -v $lib.new $lib;
  done
  cd ..
  cd ../../..

  COPY="true"
fi

if [ "$1" = "copy" -o "$COPY" = "true" ]; then
  # Copy libraries into $PREFIX
  sudo mkdir -p $PREFIX/lib/pdfium
  sudo cp out/Release/obj.target/lib*.a $PREFIX/lib/pdfium/
  sudo cp out/Release/obj.target/third_party/lib*.a $PREFIX/lib/pdfium/
  
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
fi

if [ "$1" = "link" ]; then
  # Link public to include
  ln -s public include
  cd include
  ln -s ../fpdfsdk
  ln -s ../core
  ln -s ../third_party

  # Make lib directory structure with symlinks to out folder
  # Output is thin library, we need object files
  mkdir -p lib && cd lib
  ln -s ../out/Release/obj.target/* .
  rm -f pdfium && mkdir pdfium && cd pdfium
  ln -s ../../out/Release/obj.target/* .
  ln -s ../../out/Release/obj.target/third_party/*.a .
  cd ../..

  echo "./configure --with-pdfium=`pwd`"
fi
