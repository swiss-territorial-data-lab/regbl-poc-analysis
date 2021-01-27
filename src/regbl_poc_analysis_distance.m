%  regbl-poc-analysis
%
%      Nils Hamel - nils.hamel@alumni.epfl.ch
%      Huriel Reichel
%      Copyright (c) 2020-2021 Republic and Canton of Geneva
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.

    function regbl_poc_analysis_distance( regbl_storage_path, regbl_metric, regbl_title_location )

        % create exportation directory %
        mkdir( [ regbl_storage_path '/regbl_analysis' ] );

        % extract maps temporal boundaries %
        [ regbl_oldest regbl_latest ] = regbl_poc_analysis_bounds( regbl_storage_path );

        % retrieve map mean separation %
        regbl_mean = regbl_poc_analysis_mean( regbl_storage_path );

        % import metric egid %
        regbl_valset = dlmread( regbl_metric );

        % initialise distance set %
        regbl_dist = [];
        regbl_full = [];

        % initialise indexation %
        regbl_dindex = 0;
        regbl_findex = 0;

        % intialise total computation %
        regbl_dtotal = 0;
        regbl_ftotal = 0;

        % parsing validation egid %
        for regbl_i = 1 : size( regbl_valset, 1 )

            % import deduction %
            regbl_deduce = dlmread( [ regbl_storage_path '/regbl_output/output_deduce/' num2str( regbl_valset(regbl_i) ) ] );

            % import reference %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/' num2str( regbl_valset(regbl_i) ) ] );

            % update index %
            regbl_findex = regbl_findex + 1;

            % update total %
            regbl_ftotal = regbl_ftotal + 1;

            % range selection %
            if ( ( regbl_deduce(2) >= regbl_oldest ) && ( regbl_deduce(1) <= regbl_latest ) )

                % update index %
                regbl_dindex = regbl_dindex + 1;

                % update total %
                regbl_dtotal = regbl_dtotal + 1;

                % compute and push distance %
                regbl_dist( regbl_dindex ) = ( 0.5 * ( regbl_deduce(1) + regbl_deduce(2) ) ) - regbl_reference;

                % push computed distance %
                regbl_full( regbl_findex ) = regbl_dist( regbl_dindex );

            else

                % check on under/above which extremum the detection is located %
                if ( regbl_deduce(1) == regbl_oldest )

                    % check reference %
                    if ( regbl_reference <= regbl_deduce(1) )
    
                        % push distance %
                        regbl_full( regbl_findex ) = 0;

                    else

                        % compute and push distance %
                        regbl_full( regbl_findex ) = regbl_deduce(1) - regbl_reference;

                    end

                else

                    % check reference %
                    if ( regbl_reference >= regbl_deduce(2) )
    
                        % push distance %
                        regbl_full( regbl_findex ) = 0;

                    else

                        % compute and push distance %
                        regbl_full( regbl_findex ) = regbl_deduce(2) - regbl_reference;

                    end

                end

            end

        end

        % compute number of bims %
        regbl_bims_count = ( max( regbl_dist ) - min( regbl_dist ) );

        % compute distance histogram %
        [ regbl_dhist, regbl_ddates ] = hist( regbl_dist, regbl_bims_count );
        [ regbl_fhist, regbl_fdates ] = hist( regbl_full, regbl_bims_count );

        % normalise historgam %
        regbl_dhist = regbl_dhist / sum( regbl_dhist );
        regbl_fhist = regbl_fhist / sum( regbl_fhist );

        % initialise in-range proportion %
        regbl_inr_dfmean = 0;
        regbl_inr_dhmean = 0;

        % compute in-range proportion %
        for regbl_i = 1 : length( regbl_dhist )

            % check range %
            if ( ( regbl_ddates( regbl_i ) >= -regbl_mean ) && ( regbl_ddates( regbl_i ) <= +regbl_mean ) )

                % update proportion %
                regbl_inr_dfmean = regbl_inr_dfmean + regbl_dhist( regbl_i );

                % check range %
                if ( ( regbl_ddates( regbl_i ) >= -regbl_mean * 0.5 ) && ( regbl_ddates( regbl_i ) <= +regbl_mean * 0.5 ) )

                    % update proportion %
                    regbl_inr_dhmean = regbl_inr_dhmean + regbl_dhist( regbl_i );

                end

            end

        end

        % initialise in-range proportion %
        regbl_inr_ffmean = 0;
        regbl_inr_fhmean = 0;

        % compute in-range proportion %
        for regbl_i = 1 : length( regbl_fhist )

            % check range %
            if ( ( regbl_fdates( regbl_i ) >= -regbl_mean ) && ( regbl_fdates( regbl_i ) <= +regbl_mean ) )

                % update proportion %
                regbl_inr_ffmean = regbl_inr_ffmean + regbl_fhist( regbl_i );

                % check range %
                if ( ( regbl_fdates( regbl_i ) >= -regbl_mean * 0.5 ) && ( regbl_fdates( regbl_i ) <= +regbl_mean * 0.5 ) )

                    % update proportion %
                    regbl_inr_fhmean = regbl_inr_fhmean + regbl_fhist( regbl_i );

                end

            end

        end

        % create figure %
        figure;

        % figure configuration %
        hold on;
        box  on;

        % display area %
        rectangle( 'position', [ -regbl_mean, 0, regbl_mean * 2, 1 ], 'edgecolor', 'none', 'facecolor', [0.9, 0.9, 0.9] );
        rectangle( 'position', [ -regbl_mean / 2, 0, regbl_mean, 1 ], 'edgecolor', 'none', 'facecolor', [0.8, 0.8, 0.8] );

        % display area plot %
        regbl_area = area( regbl_fdates, regbl_fhist' );

        % configure area %
        set( regbl_area(1), 'edgecolor', 'none', 'facecolor', [ 192, 78, 66 ] / 255 );

        % display area plot %
        regbl_area = area( regbl_ddates, regbl_dhist' );

        % configure area %
        set( regbl_area(1), 'edgecolor', 'none', 'facecolor', [ 22, 98, 142 ] / 255, 'facealpha', 0.75 );

        % display central line %
        plot( [ 0 0 ], [ 0 1 ], '-', 'linewidth', 1, 'color', 'k' );

        % redraw box ... %
        plot( [ -3 +3 ] * regbl_mean, [ 0.0 0.0 ], 'k-' );
        plot( [ -3 +3 ] * regbl_mean, [ 1.2 1.2 ] * max( regbl_fhist ), 'k-' );

        % axis configuration %
        axis( [ -regbl_mean*3, +regbl_mean*3, 0, max( regbl_fhist ) * 1.2 ] );

        % axis label %
        xlabel( 'Distance [Years]' );
        ylabel( 'Distribution [Normalised Proportion]' );

        % display overall proportion %
        text( -regbl_mean * 0.75, max( regbl_fhist ) * 1.06, [ num2str( regbl_inr_dfmean * 100, '%0.1f' ) ' %' ], 'color', [ 22, 98, 142 ] / 255, 'rotation', 90 );
        text( -regbl_mean * 0.25, max( regbl_fhist ) * 1.06, [ num2str( regbl_inr_dhmean * 100, '%0.1f' ) ' %' ], 'color', [ 22, 98, 142 ] / 255, 'rotation', 90 );
        text( +regbl_mean * 0.75, max( regbl_fhist ) * 1.06, [ num2str( regbl_inr_ffmean * 100, '%0.1f' ) ' %' ], 'color', [ 192, 78, 66 ] / 255, 'rotation', 90 );
        text( +regbl_mean * 0.25, max( regbl_fhist ) * 1.06, [ num2str( regbl_inr_fhmean * 100, '%0.1f' ) ' %' ], 'color', [ 192, 78, 66 ] / 255, 'rotation', 90 );

        % diplay EGID counts %
        text( +1.5 * regbl_mean, max( regbl_fhist ) * 1.10, [ 'EGIDs : ' num2str( regbl_dtotal ) ], 'color', [ 22, 98, 142 ] / 255 );
        text( +1.5 * regbl_mean, max( regbl_fhist ) * 1.05, [ 'EGIDs : ' num2str( regbl_ftotal ) ], 'color', [ 192, 78, 66 ] / 255 );

        % display range size %
        text( +1.5 * regbl_mean, max( regbl_fhist ) * 0.95, [ 'Outer : \pm' num2str( regbl_mean * 1.0, '%02.1f' ) ' Year(s)' ], 'color', 'k' );
        text( +1.5 * regbl_mean, max( regbl_fhist ) * 0.90, [ 'Inner : \pm' num2str( regbl_mean * 0.5, '%02.1f' ) ' Year(s)' ], 'color', 'k' );

        % set title %
        title( regbl_title_location );

        % export figure %
        print( '-dpng', '-r150', [ regbl_storage_path '/regbl_analysis/analysis_distance-' regbl_poc_analysis_filename( regbl_metric ) '.png' ] );  

    end

