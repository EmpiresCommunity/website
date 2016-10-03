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
stack build
```

The last command builds an executable (check the output for the location) which can build this website from the (markdown) sources. 

## Build the website

You should replace the path to site in the command below with the actual executable that the previous `stack build` command listed as having installed.

```
cd ~/website
.stack-work/install/x86_64-linux/lts-2.14/7.8.4/bin/site build
```

## Test

Open ~/website/_site/index.html in a browser. 

## Deploy

Run `make deploy` when you are happy with the changes to deploy to github pages. You can't do this unless you have the required permissions, to force push to the gh-pages branch.

## Stuck?

If you get stuck trying to follow these steps, [open an issue](https://github.com/EmpiresCommunity/website/issues/new).
