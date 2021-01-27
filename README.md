## Overview

This repository is related to the _RegBL completion_ research project. The _STDL_ was contacted by the Swiss Federal Statistical Office (_OFS_) to determine in which extend it could be possible to complete the construction date of Swiss buildings based on the analysis of a temporal sequence of the Swiss federal maps produced by _swisstopo_. With an initial target of _80%_ of correct guesses, the goal of this research project was to demonstrate the possibility to reach such goal using a reliable validation metric.

This repository holds the developed scripts used to analyse the results of the detection made through the research project primary processing pipeline.

## Research Project Links

The following links give access to the codes related to the project :

* [Primary pipeline - Construction dates extraction using maps](https://github.com/swiss-territorial-data-lab/regbl-poc)
* [Secondary pipeline - Construction dates extraction without maps](https://github.com/swiss-territorial-data-lab/intYEARpolator)
* [Results and analysis tools for the processing primary pipeline (this repository)](https://github.com/swiss-territorial-data-lab/regbl-poc-analysis)

The following links give access to official documentations on the considered data :

* [RegBL : Swiss federal register of buildings and dwellings](https://www.bfs.admin.ch/bfs/en/home/registers/federal-register-buildings-dwellings.html)
* [Maps : Swiss national maps 1:25'000](https://shop.swisstopo.admin.ch/en/products/maps/national/lk25)

## regbl-poc-analysis

In this repository are stored scripts used around the results of the primary pipeline to compute plots and to automate computation of representations. The plots are mainly created through _octave/MATLAB_ codes while automation is mainly achieved through _bash_ script.

In the following documentation, the _main storage path_ always refers to the root directory of the primary pipeline, used to gather processing configuration and to export results.

### Plots Computation

Three main plots are available for computation. All the computed plots are automatically stored in the main storage path, in the _analysis_ directory. The first one allows to displays the distribution of correct guesses along the time dimension. The usage is (_octave_ prompt) :

    > regbl_poc_analysis_metric( '/main/storage/path', '.../path/to/metric/file',
                                 'Location Name', histogram_beam_size );

This first parameter simply gives the path of the primary pipeline work directory. The second parameter has to provide a path to a text file containing all the building _EGID_ used as a reference to compute the histogram. This file has to give a list of buildings valid _EGID_ for which a construction date is already available and sufficiently reliable to be considered as a _ground truth_. A content example of such file could be :

    11102923
    11114701
    11114710
    11114957
    ...

for the _Biasca_ area. It is of the responsibility of the researcher to compose such validation list.

The location name provided as third parameter only gives the name of the studied area and is only used for the title of the plot. The last parameter has to be a non-zero positive number giving the size of the bins, in years, used for the histogram. A default value of _10_ years is set in case the parameter is missing. The left image below gives an example of such plot.

The blue portion correspond to the correct guess while the red one complete it to one, thus giving the proportion of incorrect guesses. The line at _0.8_ is the desired target while the line with two numbers gives the overall success and failure rate over the whole buildings set.

The second plot available through the scripts is used to compute a distance-based representation of the results. It shows the distribution of errors in the attribution of a construction date to the buildings (_octave_ prompt) :

    > regbl_poc_analysis_distance( '/main/storage/path', '.../path/to/metric/file',
                                   'Location Name' );

The parameters are exactly the same as for the previous script. The following right image gives an illustration of an obtained plot :

<p align="center">
<img src="doc/image/histogram-example.png?raw=true" width="256"> &nbsb;
<img src="doc/image/distance-example.png?raw=true" width="256">
<br />
<i>Example of the distance plot obtained using this script - Biasca</i>
</p>

On this plot, two distribution are shown : the blue distribution only shows building with a detection date within the range covered by the maps. The red distribution show the full buildings set distribution, assigning zero-valued distance above and beyond the last and first map. The grey zones indicate the mean temporal separation of maps around zero for the first (dark) and twice the separation for the second (light). The numbers shown in the zones indicates which proportion of the buildings are within these ranges in terms error on construction date.

The last available script allows to compute a graphical representation of the zones where correct and incorrect guesses are the most located (_octave_ prompt) :

    > regbl_poc_analysis_area( '/main/storage/path', '.../path/to/metric/file',
                               image_width, kernel_size );

The two first parameters are the same as before. The two last parameters have to give the size of the images to compute and the size of the kernel. The size of the kernel indicates how many surrounding pixels will be affected by a single correct or incorrect guess. Using a high value make the computation longer but create smoother representations.

The output of this script is two transparent images, one for the correct guess and one for the incorrect ones, that can be used as overlays on each of the considered maps of the temporal sequence. The following images give an illustration of the composition of the transparent images with maps :

<p align="center">
<img src="doc/image/guess-by-area.jpg?raw=true" width="384">
<br />
<i>Example of usage of the two transparent representation on top of a corresponding maps - Basel, 2000</i>
</p>

As the script only exports the transparent overlays, additional work has to be done do superimpose them on a chosen map.

### Automation Scripts



## Copyright and License

**regbl-poc-analysis** - Nils Hamel, Huriel Richel <br >
Copyright (c) 2020-2021 Republic and Canton of Geneva

This program is licensed under the terms of the GNU GPLv3. Documentation and illustrations are licensed under the terms of the CC BY 4.0.

## Dependencies

The _regbl-poc-analysis_ comes with the following package (Ubuntu 20.04 LTS) dependencies ([Instructions](DEPEND.md)) :

* octave
* octave-image
