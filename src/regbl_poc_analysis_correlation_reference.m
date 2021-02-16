
    function regbl_poc_analysis_correlation_reference( regbl_storage_path, regbl_egid, regbl_corrfile )

        % extract maps temporal boundaries %
        [ regbl_oldest regbl_latest ] = regbl_poc_analysis_bounds( regbl_storage_path );

        % import egid list %
        regbl_list = dlmread( regbl_egid );

        % create output stream %
        regbl_stream = fopen( regbl_corrfile, 'w' );

        % parsing egid %
        for regbl_i = 1 : size( regbl_list, 1 )

            % import deduction %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/' num2str( regbl_list( regbl_i ) ) ] );

            % check reference position %
            if ( regbl_reference < regbl_oldest )

                % clamp reference %
                regbl_reference = regbl_oldest;

            end

            % check reference position %
            if ( regbl_reference > regbl_latest )

                % clamp reference %
                regbl_reference = regbl_latest;

            end

            % export position value %
            fprintf( regbl_stream, "%i %f\n", regbl_list( regbl_i ), regbl_reference );

        end

        % delete output stream %
        fclose( regbl_stream );

    end
