
    function regbl_poc_analysis_distance( regbl_storage_path, regbl_location_name, regbl_metric )

        % retrieve extremal maps %
        [ regbl_oldest regbl_latest ] = regbl_poc_analysis_getbounds( [ regbl_storage_path '/regbl_list' ], regbl_location_name );

        % retrieve map mean separation %
        regbl_meansep = regbl_poc_analysis_getmeansep( [ regbl_storage_path '/regbl_list' ], regbl_location_name );

        % import metric egid %
        regbl_valset = dlmread( regbl_metric );

        % initialise distance set %
        regbl_dist = [];

        % initialise indexation %
        regbl_index = 0;

        % parsing validation egid %
        for regbl_i = 1 : size( regbl_valset, 1 )

            % import deduction %
            regbl_deduce = dlmread( [ regbl_storage_path '/regbl_output/output_deduce/deduce_' regbl_location_name '/' num2str( regbl_valset(regbl_i) ) ] );

            % import reference %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/reference_' regbl_location_name '/' num2str( regbl_valset(regbl_i) ) ] );

            % range selection %
            if ( ( regbl_deduce(2) >= regbl_oldest ) && ( regbl_deduce(1) <= regbl_latest ) )

                % update index %
                regbl_index = regbl_index + 1;

                % compute and push distance %
                regbl_dist( regbl_index ) = ( 0.5 * ( regbl_deduce(1) + regbl_deduce(2) ) ) - regbl_reference;

            end

        end

        % compute number of bims %
        regbl_bims_count = ( max( regbl_dist ) - min( regbl_dist ) );

        % compute distance histogram %
        [ regbl_hist, regbl_dates ] = hist( regbl_dist, regbl_bims_count );

        % normalise historgam %
        regbl_hist = regbl_hist / sum( regbl_hist );

        % compute standard deviation %
        regbl_std = std( regbl_dist );

        % initialise in-range proportion %
        regbl_inr_fmean = 0;
        regbl_inr_hmean = 0;

        % compute in-range proportion %
        for regbl_i = 1 : length( regbl_hist )

            % check range %
            if ( ( regbl_dates( regbl_i ) >= -regbl_meansep ) && ( regbl_dates( regbl_i ) <= +regbl_meansep ) )

                % update proportion %
                regbl_inr_fmean = regbl_inr_fmean + regbl_hist( regbl_i );

                % check range %
                if ( ( regbl_dates( regbl_i ) >= -regbl_meansep * 0.5 ) && ( regbl_dates( regbl_i ) <= +regbl_meansep * 0.5 ) )

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

        % display central line %
        plot( [ 0 0 ], [ 0 1 ], '-', 'linewidth', 1, 'color', [ 1 1 1 ] * 0.75 );

        % display area plot %
        regbl_area = area( regbl_dates, regbl_hist' );

        % configure area %
        set( regbl_area(1), 'edgecolor', 'none', 'facecolor', [ 22, 98, 142 ] / 255 );

        % plot map mean gap around zero %
        plot( [ +1 +1 ] * regbl_meansep, [ 0 1 ], ':k', 'linewidth', 2 );
        plot( [ -1 -1 ] * regbl_meansep, [ 0 1 ], ':k', 'linewidth', 2 );

        % plot map half mean gap around zero %
        plot( [ +1 +1 ] * regbl_meansep * 0.5, [ 0 1 ], '-k', 'linewidth', 1 );
        plot( [ -1 -1 ] * regbl_meansep * 0.5, [ 0 1 ], '-k', 'linewidth', 1 );

        % plot distance standard deviation %
        plot( [ +1 +1 ] * regbl_std, [ 0 1 ], '-', 'linewidth', 1, 'color', [ 192, 78, 66 ] / 255 );
        plot( [ -1 -1 ] * regbl_std, [ 0 1 ], '-', 'linewidth', 1, 'color', [ 192, 78, 66 ] / 255 );

        % axis configuration %
        axis( [ -25, +25, 0, max( regbl_hist ) * 1.2 ] );

        % axis label %
        xlabel( 'Distance [Years]' );
        ylabel( 'Distribution' );

        % set title %
        title( [ 'Distance to the reference : ' regbl_location_name ' - In-range : (' num2str( regbl_inr_fmean * 100, '%0.2f' ) '%, ' num2str( regbl_inr_hmean * 100, '%0.2f' ) '%)' ] );

        % export figure %
        print( '-dpng', '-r150', 'distance.png' );        

    end
