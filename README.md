# Empiresmod main page

The main page for [Empiresmod, a free indie RTS/FPS game](http://www.empiresmod.com/) - free open source software built with Hakyll.

Note: The steps for building the website locally currently only work on Linux - you can still write and submit pull requests from Windows, it just means you cannot review changes, seeing them as they would appear online.

# Clone this repository

Scroll up, copy from the green "Clone or download" button on the right, plug that into your git GUI (e.g. [GitExtensions](https://gitextensions.github.io/)) or copy the following into a terminal window:

```
git clone git@github.com:EmpiresCommunity/website.git
```

# Install stack & hakyll

Install stack as described [here](https://docs.haskellstack.org/en/stable/README/), then install hakyll from a terminal, opened on the website directory, with:

```
stack setup
stack install hakyll
```

## Build the website

```
make
```

That will place a working copy of the website into /_site/, below wherever you cloned this repository. For example, if you cloned into `C:\Empiresmod\website`, then you can put `/C:/Empiresmod/website/_site/index.html` into your browser's url bar; but if you're running linux, what you put into the url bar should look like: `file:///home/you/empires/website/_site/index.html`

## Deploy

Run `make deploy` when you are happy with the changes; that deploys to empiresmod.com (gh-pages branch). If you don't have the required permissions to deploy, first [fork](https://help.github.com/articles/fork-a-repo/), then [submit a pull request](https://help.github.com/articles/about-pull-requests/).

## Stuck?

If you get stuck trying to follow these steps, [open an issue](https://github.com/EmpiresCommunity/website/issues/new).
