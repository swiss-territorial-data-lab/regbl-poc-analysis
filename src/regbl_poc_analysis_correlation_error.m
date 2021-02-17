
    function regbl_poc_analysis_correlation_error( regbl_storage_path, regbl_egid, regbl_corrfile )

        % extract maps temporal boundaries %
        [ regbl_oldest regbl_latest ] = regbl_poc_analysis_bounds( regbl_storage_path );

        % import egid list %
        regbl_list = dlmread( regbl_egid );

        % create output stream %
        regbl_stream = fopen( regbl_corrfile, 'w' );

        % parsing egid %
        for regbl_i = 1 : size( regbl_list, 1 )

            % import deduction %
            regbl_deduce = dlmread( [ regbl_storage_path '/regbl_output/output_deduce/' num2str( regbl_list( regbl_i ) ) ] );

            % import reference %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/' num2str( regbl_list( regbl_i ) ) ] );

            % check deduction %
            if ( regbl_deduce(1) == regbl_oldest )

                % compute position %
                regbl_position = regbl_oldest;

            else

                % compute position %
                if ( regbl_deduce(2) == regbl_latest )

                    % compute position %
                    regbl_position = regbl_latest;

                else

                    % compute position %
                    regbl_position = 0.5 * ( regbl_deduce(1) + regbl_deduce(2) );

                end

            end

            % compute normalised error %
            regbl_error = exp( - abs( regbl_position - regbl_reference ) * ( - log( 0.5 ) / 5 ) );

            % export error %
            fprintf( regbl_stream, "%i %f\n", regbl_list( regbl_i ), regbl_error );

        end

        % delete output stream %
        fclose( regbl_stream );

    end
