site: site.hs
	stack build

build:
	stack exec site rebuild

deploy:
	cd _site && git checkout -- . && git clean -df
	cd _site && git checkout -B gh-pages origin/gh-pages
	make build
	cd _site && git add . && git commit -m "Built on `date` from `cd .. && git rev-parse HEAD`" && git push
