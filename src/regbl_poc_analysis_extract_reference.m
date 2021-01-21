
    function regbl_poc_analysis_extract_reference( regbl_storage_path, regbl_location_name, regbl_export )

        % create listing %
        regbl_list = dir( [ regbl_storage_path '/regbl_output/output_reference/reference_' regbl_location_name '/*' ] );

        % create exportation stream %
        regbl_stream = fopen( regbl_export, 'w' );

        % parsing listing %
        for regbl_i = 1 : size( regbl_list, 1 )

            % import reference date %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/reference_' regbl_location_name '/' regbl_list( regbl_i ).name ] );

            % check reference date %
            if ( regbl_reference > 0 )

                % export egid %
                fprintf( regbl_stream, '%s\n', regbl_list( regbl_i ).name );

            end

        end

        % delete stream %
        fclose( regbl_stream );

    end
