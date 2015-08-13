PDFium - an open-source PDF rendering
=====================================

Official source code is available at http://pdfium.googlesource.com

----------------------------

This is fork of PDFium with configurable variable for disabling V8 JavaScript engine (disabled by default).

[Klokan Technologies](http://www.klokantech.com/) uses this version with the [GDAL PDFium driver](https://github.com/klokantech/gdal/tree/pdfium-master)

## Build

See the shell scripts for Linux, Mac and Windows in the [build branch](https://github.com/klokantech/pdfium/tree/build)

For official build instructions visit https://code.google.com/p/pdfium/wiki/Build

## Update to the latest official code

    git remote add upstream https://pdfium.googlesource.com/pdfium
    git fetch upstream
    git merge upstream/master
