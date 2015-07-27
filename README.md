PDFium is an open-source PDF rendering engine.
====

Source is hosted at http://pdfium.googlesource.com

----

This is version of PDFium with configurable variable for disabling V8 JavaScript engine (default disabled).

Klokan Technologies is using this version within [GDAL library](https://github.com/klokantech/gdal/tree/pdfium-master)

Update branch `google` from Google Code
====

`git remote add upstream https://pdfium.googlesource.com/pdfium`
`git checkout google`
`git fetch upstream`
`git merge upstream/master`
