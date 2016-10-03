# Empiresmod main page

The main page for [Empiresmod, a free indie RTS/FPS game](http://www.empiresmod.com/) is free open source software built with Hakyll.

# Dependencies

1) Clone this repository, then 

```
cd ~
git clone git@github.com:EmpiresCommunity/website.git
cd website
make
```

2) Install stack as described [here](https://docs.haskellstack.org/en/stable/README/) (oneliner for most Un*x'es)

```
stack setup
stack install hakyll
```

3) Build the website by running make inside the website directory.

```
cd ~/website
make
```

4) (optional) If the make step failed, [open an issue](https://github.com/EmpiresCommunity/website/issues/new) - the dependencies listed at 1 may be incomplete.
