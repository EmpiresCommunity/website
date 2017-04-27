site: site.hs
	stack build

build: checkout site
	rm _site/* -rf
	rm -rf _cache/
	stack exec site build

checkout:
	cd _site && git checkout -- . && git clean -df
	cd _site && git checkout -B gh-pages origin/gh-pages

deploy: build
	cd _site && git add . && git commit -m "Built on `date` from `cd .. && git rev-parse HEAD`" && git push
	git add _site/ && git commit -m "Added build" && git push
