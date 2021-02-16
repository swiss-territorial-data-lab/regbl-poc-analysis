
    function regbl_poc_analysis_correlation_position( regbl_storage_path, regbl_egid, regbl_corrfile )

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

            % check deduction %
            if ( regbl_deduce(1) == regbl_oldest )

                % export position value %
                fprintf( regbl_stream, "%i %f\n", regbl_list( regbl_i ), regbl_oldest );

            else

                % check detection %
                if ( regbl_deduce(2) == regbl_latest )

                    % export position value %
                    fprintf( regbl_stream, "%i %f\n", regbl_list( regbl_i ), regbl_latest );

                else

                    % compute position %
                    regbl_position = 0.5 * ( regbl_deduce(1) + regbl_deduce(2) );

                    % export position value %
                    fprintf( regbl_stream, "%i %f\n", regbl_list( regbl_i ), regbl_position );

                end

            end

        end

        % delete output stream %
        fclose( regbl_stream );

    end
