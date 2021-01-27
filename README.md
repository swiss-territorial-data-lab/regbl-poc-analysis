## Overview

This repository is related to the _RegBL completion_ research project. The _STDL_ was contacted by the Swiss Federal Statistical Office (_OFS_) to determine in which extend it could be possible to complete the construction date of swiss buildings based on the analysis of a temporal sequence of the swiss federal maps produced by _swisstopo_. With an initial tolerence of _80%_ of expected correct guesses, the goal of this research project was to demonstrate the possibility to reach such goal using reliable validation metric.

This repository holds the developed scripts used to compose and analyse the results of the detection made through the research project proof-of-concept (see Project Links section).

## Research Project Links

The following links gives access to the codes related to the project :

* [Primary pipeline - Construction dates extraction using maps](https://github.com/swiss-territorial-data-lab/regbl-poc)
* [Secondary pipeline - Construction dates extraction wihtout maps](https://github.com/swiss-territorial-data-lab/intYEARpolator)
* [Results and analysis tools for the processing pipeline](https://github.com/swiss-territorial-data-lab/regbl-poc-analysis)

The following links gives access to official documentation on the considered data :

* [RegBL : Swiss federal register of buildings and dwellings](https://www.bfs.admin.ch/bfs/en/home/registers/federal-register-buildings-dwellings.html)
* [Maps : Swiss national maps 1:25'000](https://shop.swisstopo.admin.ch/en/products/maps/national/lk25)

## regbl-poc-analysis


## Copyright and License

**regbl-poc-analysis** - Nils Hamel, Huriel Richel <br >
Copyright (c) 2020-2021 Republic and Canton of Geneva

This program is licensed under the terms of the GNU GPLv3. Documentation and illustrations are licensed under the terms of the CC BY 4.0.

## Dependencies

The _regbl-poc-analysis_ comes with the following package (Ubuntu 20.04 LTS) dependencies ([Instructions](DEPEND.md)) :

* octave
* octave-image
