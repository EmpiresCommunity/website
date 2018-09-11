build: site
	rm _site/* -rf
	rm -rf _cache/
	stack exec site build

site: site.hs
	stack build

deploy:
	cd _site && git add . && git commit -m "Built on `date` from `cd .. && git rev-parse HEAD`" && git push
