#!/bin/bash

set -e
shopt -s globstar

find . -type f -name '*.jpg' -exec rm -f {} +
find . -type f -name '__init__.py' -exec rm -f {} +
find . -type d -name '*.hpp' -exec rm -rf {} +
find . -type d -name '*.cpp' -exec rm -rf {} +
find . -type d -name '*.json' -exec rm -rf {} +
find . -type d -name '*.meta' -exec rm -rf {} +
find . -type d -name '*.ipynb' -exec rm -rf {} +
find . -type d -name conduit -exec rm -rf {} +
find . -type d -name web -exec rm -rf {} +
find . -type d -name third-party -exec rm -rf {} +
find . -type d -name docs -exec rm -rf {} +
find . -type l -delete
find -type f -name ".*" -delete; rm -f *~
rm -f **/*{.meta,.json,.ipynb,.cpp,.hpp,.jpg,.csv,@longlink,.py,.md,.yaml,.jinja,.cfg}
ls -1 submodule/dishtiny/binder/bucket=prq49/a=all_stints_all_series_profiles+endeavor=16/**/* \
    | grep -v "submodule/dishtiny/binder/bucket=prq49/a=all_stints_all_series_profiles+endeavor=16/teeplots/bucket=prq49+cat=morph+endeavor=16+transform=filter-Series-16005+viz=letterscatter-vline+x=stint+y=num-instructions+ext=" \
    | grep -v "submodule/dishtiny/binder/bucket=prq49/a=all_stints_all_series_profiles+endeavor=16/teeplots/bucket=prq49+cat=morph+endeavor=16+transform=filter-Series-16005+viz=letterscatter-vline+x=stint+y=mean-program-module-count-monoculture-mean+ext=" \
    | xargs rm -f
rm -f submodule/**/*{.png,.sh}
rm -f submodule/**/Makefile
find . -type d -empty -delete


rm -f arxiv.tar.gz
git checkout bibl.bib
make cleaner
make
make clean
mv bibl.bib main.bib
cp oee4-draft.bbl main.bbl
cp oee4-draft.blg main.blg
tar -czvf arxiv.tar.gz *
