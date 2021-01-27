## Overview

This repository is related to the _RegBL completion_ research project. The _STDL_ was contacted by the Swiss Federal Statistical Office (_OFS_) to determine in which extend it could be possible to complete the construction date of swiss buildings based on the analysis of a temporal sequence of the swiss federal maps produced by _swisstopo_. With an initial tolerence of _80%_ of expected correct guesses, the goal of this research project was to demonstrate the possibility to reach such goal using reliable validation metric.

This repository holds the developed scripts used to analyse the results of the detection made through the research project primary processing pipeline.

## Research Project Links

The following links gives access to the codes related to the project :

* [Primary pipeline - Construction dates extraction using maps](https://github.com/swiss-territorial-data-lab/regbl-poc)
* [Secondary pipeline - Construction dates extraction wihtout maps](https://github.com/swiss-territorial-data-lab/intYEARpolator)
* [Results and analysis tools for the processing pipeline](https://github.com/swiss-territorial-data-lab/regbl-poc-analysis)

The following links gives access to official documentation on the considered data :

* [RegBL : Swiss federal register of buildings and dwellings](https://www.bfs.admin.ch/bfs/en/home/registers/federal-register-buildings-dwellings.html)
* [Maps : Swiss national maps 1:25'000](https://shop.swisstopo.admin.ch/en/products/maps/national/lk25)

## regbl-poc-analysis

In this repository are stored scripts used around the results of the primary pipeline to compute validation plots and automated computation of result representation. The plots are mainly created through _octave/MATLAB_ codes while automation is mainly achieved through _bash_script.

In the following documentation, the _main storage path_ always refers to the root directory of the primary pipeline, used to gather configuration and to export results.

### Plots Computation

Three main plots are available for computation. The first one allows to displays the distribution of correct guesses along the time dimension. The usage is, in an _octave_ prompt :

    > regbl_poc_analysis_metric( '/main/storage/path','.../path/to/metric/file','Location Name', histogram_beam_size );

This first parameter simply gives the path of the primary pipeline work directory. The second parameter has to provide a path to a text file containing all the building _EGID_ used as a reference to compute the histogram. This file as to give a list of buildings valid _EGID_ for which a construction date is already avalilable and sufficiantly reliable to be considered as a _ground truth_. A content example could be :

    11102923
    11114701
    11114710
    11114957
    ...

for the _Biasca_ area. It is of the responsibility of the researcher to compose such validation list.

The location name provided as third parameter only gives the name of the studied area and is only used for the title of the plot. The last parameter has to be a non-zero positive number giving the size of the bims, in years, to use for the histogram. A default value of _10_ years is set in case the parameter is missing. The following image gives an example of such plot :

<br />
<p align="center">
<img src="doc/image/histogram-example.png?raw=true" width="384">
<i>Example of the histogram obtained using this script - Caslano</i>
</p>
<br />


### Automation Scripts



## Copyright and License

**regbl-poc-analysis** - Nils Hamel, Huriel Richel <br >
Copyright (c) 2020-2021 Republic and Canton of Geneva

This program is licensed under the terms of the GNU GPLv3. Documentation and illustrations are licensed under the terms of the CC BY 4.0.

## Dependencies

The _regbl-poc-analysis_ comes with the following package (Ubuntu 20.04 LTS) dependencies ([Instructions](DEPEND.md)) :

* octave
* octave-image
