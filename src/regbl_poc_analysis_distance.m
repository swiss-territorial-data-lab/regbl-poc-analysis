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

        % create directory %
        mkdir( [ regbl_storage_path '/regbl_analysis' ] );

        % retrieve extremal maps %
        [ regbl_oldest regbl_latest ] = regbl_poc_analysis_bounds( regbl_storage_path );

        % retrieve map mean separation %
        regbl_mean = regbl_poc_analysis_mean( regbl_storage_path );

        % import metric egid %
        regbl_valset = dlmread( regbl_metric );

        % initialise distance set %
        regbl_dist = [];

        % initialise indexation %
        regbl_index = 0;

        % intialise total computation %
        regbl_total = 0;

        % parsing validation egid %
        for regbl_i = 1 : size( regbl_valset, 1 )

            % import deduction %
            regbl_deduce = dlmread( [ regbl_storage_path '/regbl_output/output_deduce/' num2str( regbl_valset(regbl_i) ) ] );

            % import reference %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/' num2str( regbl_valset(regbl_i) ) ] );

            % range selection %
            if ( ( regbl_deduce(2) >= regbl_oldest ) && ( regbl_deduce(1) <= regbl_latest ) )

                % update index %
                regbl_index = regbl_index + 1;

                % compute and push distance %
                regbl_dist( regbl_index ) = ( 0.5 * ( regbl_deduce(1) + regbl_deduce(2) ) ) - regbl_reference;

                % update total %
                regbl_total = regbl_total + 1;

            end

        end

        % compute number of bims %
        regbl_bims_count = ( max( regbl_dist ) - min( regbl_dist ) );

        % compute distance histogram %
        [ regbl_hist, regbl_dates ] = hist( regbl_dist, regbl_bims_count );

        % normalise historgam %
        regbl_hist = regbl_hist / sum( regbl_hist );

        % initialise in-range proportion %
        regbl_inr_fmean = 0;
        regbl_inr_hmean = 0;

        % compute in-range proportion %
        for regbl_i = 1 : length( regbl_hist )

            % check range %
            if ( ( regbl_dates( regbl_i ) >= -regbl_mean ) && ( regbl_dates( regbl_i ) <= +regbl_mean ) )

                % update proportion %
                regbl_inr_fmean = regbl_inr_fmean + regbl_hist( regbl_i );

                % check range %
                if ( ( regbl_dates( regbl_i ) >= -regbl_mean * 0.5 ) && ( regbl_dates( regbl_i ) <= +regbl_mean * 0.5 ) )

                    % update proportion %
                    regbl_inr_hmean = regbl_inr_hmean + regbl_hist( regbl_i );

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
        regbl_area = area( regbl_dates, regbl_hist' );

        % display central line %
        plot( [ 0 0 ], [ 0 1 ], '-', 'linewidth', 1, 'color', 'k' );

        % configure area %
        set( regbl_area(1), 'edgecolor', 'none', 'facecolor', [ 22, 98, 142 ] / 255 );

        % redraw box ... %
        plot( [ -3 +3 ] * regbl_mean, [ 0.0 0.0 ], 'k-' );
        plot( [ -3 +3 ] * regbl_mean, [ 1.2 1.2 ] * max( regbl_hist ), 'k-' );

        % axis configuration %
        axis( [ -regbl_mean*3, +regbl_mean*3, 0, max( regbl_hist ) * 1.2 ] );

        % axis label %
        xlabel( 'Distance [Years]' );
        ylabel( 'Distribution [Normalised Proportion]' );

        % display overall proportion %
        text( -regbl_mean * 0.75, max( regbl_hist ) * 1.06, [ num2str( regbl_inr_fmean * 100, '%0.1f' ) ' %' ], 'color', 'k', 'rotation', 90 );
        text( -regbl_mean * 0.25, max( regbl_hist ) * 1.06, [ num2str( regbl_inr_hmean * 100, '%0.1f' ) ' %' ], 'color', 'k', 'rotation', 90 );

        % set title %
        title( [ regbl_title_location ' with ' num2str( regbl_total ) ' validation EGIDs' ] );

        % export figure %
        print( '-dpng', '-r150', [ regbl_storage_path '/regbl_analysis/analysis_distance-' regbl_poc_analysis_filename( regbl_metric ) '.png' ] );  

    end

