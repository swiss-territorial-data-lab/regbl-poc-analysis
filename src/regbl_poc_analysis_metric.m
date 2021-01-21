
    function regbl_poc_analysis_metric( regbl_storage_path, regbl_location_name, regbl_metric, regbl_hist_prec = 1 )

        % retrieve extremal maps %
        [ regbl_oldest regbl_latest ] = regbl_poc_analysis_getbounds( [ regbl_storage_path '/regbl_list' ], regbl_location_name );

        % import metric egid %
        regbl_valset = dlmread( regbl_metric );

        % counting variable %
        regbl_true  = 0;
        regbl_total = 0;

        % histogram size %
        regbl_hist_size = fix( 240 / regbl_hist_prec );

        % prepare histogram %
        regbl_hist_true  = zeros( regbl_hist_size, 1 );
        regbl_hist_total = zeros( regbl_hist_size, 1 );

        % parsing validation egid %
        for regbl_i = 1 : size( regbl_valset, 1 )

            % import deduction %
            regbl_deduce = dlmread( [ regbl_storage_path '/regbl_output/output_deduce/deduce_' regbl_location_name '/' num2str( regbl_valset(regbl_i) ) ] );

            % import reference %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/reference_' regbl_location_name '/' num2str( regbl_valset(regbl_i) ) ] );

            % compute histogram index %
            regbl_hindex = fix( ( regbl_reference - 1800 ) / regbl_hist_prec );

            % validation check %
            if ( regbl_reference <= regbl_deduce(1) ) && ( regbl_reference > regbl_deduce(2) )

                % update count %
                regbl_true = regbl_true + 1;

                % check histogram index %
                if ( ( regbl_hindex > 0 ) && ( regbl_hindex < regbl_hist_size ) )

                    % update histogram %
                    regbl_hist_true( regbl_hindex ) = regbl_hist_true( regbl_hindex ) + 1;

                end

            end

            % update count %
            regbl_total = regbl_total + 1;

            % check histogram index %
            if ( ( regbl_hindex > 0 ) && ( regbl_hindex < regbl_hist_size ) )

                % update histogram %
                regbl_hist_total( regbl_hindex ) = regbl_hist_total( regbl_hindex ) + 1;

            end

        end

        % compute score %
        regbl_score = ( regbl_true / ( regbl_total ) );

        % display summary %
        fprintf( 2, 'Results : %f (%i, %i, %i)\n', regbl_score, regbl_true, regbl_total - regbl_true, regbl_total );

        % initialise dense histogram %
        regbl_dense_true  = [];
        regbl_dense_total = [];
        regbl_dense_dates = [];

        % initialise indexation %
        regbl_k = 0;

        % compute dense histograms %
        for regbl_i = 1 : regbl_hist_size

            % check sparse histogram - requires at least 5 point of measure to compute a proportion %
            if ( regbl_hist_total( regbl_i ) > 5 )

                % update index %
                regbl_k = regbl_k + 1;

                % compute date %
                regbl_dense_dates( regbl_k ) = ( regbl_i * regbl_hist_prec ) + 1800;

                % assign values %
                regbl_dense_true ( regbl_k ) = regbl_hist_true ( regbl_i );
                regbl_dense_total( regbl_k ) = regbl_hist_total( regbl_i );

            end

        end

        % histogram normalisation %
        regbl_dense_true = ( regbl_dense_true  ./ regbl_dense_total );
        regbl_dense_comp = ( regbl_dense_total ./ regbl_dense_total ) - regbl_dense_true;

        % create figure %
        figure;

        % figure configuration %
        hold on;

        % display area plot %
        regbl_area = area( regbl_dense_dates, [ regbl_dense_true', regbl_dense_comp' ] );

        % configure area %
        set( regbl_area(1), 'edgecolor', 'none', 'facecolor', [ 22, 98, 142 ] / 255 );
        set( regbl_area(2), 'edgecolor', 'none', 'facecolor', [ 192, 78, 66 ] / 255 );

        % display count proportion %
        plot( regbl_dense_dates, regbl_dense_true, '-w', 'linewidth', 1.5 );

        % display overall score %
        plot( [ regbl_dense_dates(1), regbl_dense_dates(end) ], [ 1, 1 ] * regbl_score, 'w:', 'linewidth', 2 );

        % display oldest and latest map %
        plot( [ 1 1 ] * regbl_oldest, [ 0, 1 ], 'w-', 'linewidth', 2 );
        plot( [ 1 1 ] * regbl_latest, [ 0, 1 ], 'w-', 'linewidth', 2 );

        % display count proportion %
        plot( regbl_dense_dates, regbl_dense_total / regbl_total, '-w', 'linewidth', 1.5 );

        % axis configuration %
        axis( [ regbl_dense_dates(1), regbl_dense_dates(end), 0, 1 ] );

        % axis label %
        xlabel( 'Time [Years]' );
        ylabel( 'Proportion of correct deduction' );

        % set title %
        title( [ regbl_location_name ' - Overall : ' num2str( regbl_score * 100, '%0.2f' ) ' % - Building count : ' num2str( regbl_total ) ] );

        % export figure %
        print( '-dpng', '-r150', 'metric.png' );

    end

