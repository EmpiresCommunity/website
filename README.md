# Empiresmod main page

The main page for [Empiresmod, a free indie RTS/FPS game](http://www.empiresmod.com/) is free open source software built with Hakyll.

# Dependencies

## Clone this repository

```
cd ~
git clone git@github.com:EmpiresCommunity/website.git
```

## Install stack, hakyll and site

Install stack as described [here](https://docs.haskellstack.org/en/stable/README/) (oneliner for most Un*x'es)

```
stack setup
stack install hakyll
```

## Build the website

```
make site
make build
```

The first command builds an executable from site.hs (which is in Haskell and uses the Hakyll module), which can build this website from the (markdown, html, etc.) sources. The reason we do it this way instead of plain html is that you can reduce the code and content duplication without having to use PHP (which would be less scalable). The end result is still plain html, but each piece of content can be put in exactly one place and duplicated where necessary.

## Test

Open ~/website/_site/index.html in a browser. 

## Deploy

Run `make deploy` when you are happy with the changes to deploy to github pages. You can't do this unless you have the required permissions, to push to the gh-pages branch.

## Stuck?

If you get stuck trying to follow these steps, [open an issue](https://github.com/EmpiresCommunity/website/issues/new).
