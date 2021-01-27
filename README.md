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

Three main plots are available for computation. All the computed plots are automatically stored in the main storage path, in the _analysis_ directory. The first one allows to displays the distribution of correct guesses along the time dimension. The usage is, in an _octave_ prompt :

    > regbl_poc_analysis_metric( '/main/storage/path', '.../path/to/metric/file',
                                 'Location Name', histogram_beam_size );

This first parameter simply gives the path of the primary pipeline work directory. The second parameter has to provide a path to a text file containing all the building _EGID_ used as a reference to compute the histogram. This file as to give a list of buildings valid _EGID_ for which a construction date is already avalilable and sufficiantly reliable to be considered as a _ground truth_. A content example could be :

    11102923
    11114701
    11114710
    11114957
    ...

for the _Biasca_ area. It is of the responsibility of the researcher to compose such validation list.

The location name provided as third parameter only gives the name of the studied area and is only used for the title of the plot. The last parameter has to be a non-zero positive number giving the size of the bims, in years, to use for the histogram. A default value of _10_ years is set in case the parameter is missing. The following image gives an example of such plot :

<p align="center">
<img src="doc/image/histogram-example.png?raw=true" width="256">
<br />
<i>Example of the histogram obtained using this script - Caslano</i>
</p>

The second plot available through the scripts is used to compute a distance-based representation of the results. It shows the distribution of errors in the attirbution of a construction date to the buildings :

    > regbl_poc_analysis_distance( '/main/storage/path', '.../path/to/metric/file',
                                   'Location Name' );

The parameters are exactly the same as for the previous script. The following image gives an illustration of an obtained plot :

<p align="center">
<img src="doc/image/distance-example.png?raw=true" width="256">
<br />
<i>Example of the distance plot obtained using this script - Biasca</i>
</p>

On this plot, two distribution are shown : the blue distribution only shows building with a detection date within the range covered by the maps. The red distribution show the full building set distribution, assigning zero-valued distance above and beyond the last and first map. The gray zones indicate the mean temporal separation of maps around zero for the first and twice the separation for the second. The numbers shown in the zones indicates which proportion of the buildings are within these ranges in terms of construction date guesses.

The last plots allows to compute a graphical representation of the zone where correct and incorrect guesses are located. The product is then an format image corresponding to the used maps :

    > regbl_poc_analysis_area( '/main/storage/path', '.../path/to/metric/file',
                               image_width, kernel_size );

The two first parameters are the same as before. The two last parameters have to give the size of the computed images and the size of the kernel. The size of the kernel indicates how many serounding pixels will be affected by a single correct or incorrect guess. Using a high value make the computation longer but create smoother representation.

The ouput of this script is two transparent images, one for the correct guess and one for the incorrect ones, that can be used as overlay on each of the considered maps. The following image gives an illustration of the composition of the transparent images and maps :

<p align="center">
<img src="doc/image/guess-by-area.jpg?raw=true" width="384">
<br />
<i>Example of usage of the two transparent representation on top of a corresponding maps - Basel, 2000</i>
</p>

As the script only exports the transparent overlay, additional work has to be done do overimpose them on a chosen map.

### Automation Scripts



## Copyright and License

**regbl-poc-analysis** - Nils Hamel, Huriel Richel <br >
Copyright (c) 2020-2021 Republic and Canton of Geneva

This program is licensed under the terms of the GNU GPLv3. Documentation and illustrations are licensed under the terms of the CC BY 4.0.

## Dependencies

The _regbl-poc-analysis_ comes with the following package (Ubuntu 20.04 LTS) dependencies ([Instructions](DEPEND.md)) :

* octave
* octave-image
