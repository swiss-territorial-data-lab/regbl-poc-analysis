
    function [ regbl_oldest regbl_latest ] = regbl_poc_analysis_getbounds( regbl_database, regbl_location_name )

        % initialise values %
        regbl_oldest = 0;
        regbl_latest = 0;

        % retrive storage main database %
        [ regbl_name regbl_date regbl_xl regbl_xh regbl_yl regbl_yh ] = textread( regbl_database, '%s %d %d %d %d %d');

        % search for most ancient map %
        for regbl_i = 1 : size( regbl_name, 1 )

            % check location %
            if ( strcmp( regbl_name( regbl_i ), regbl_location_name ) == 1 )

                % check latest map %
                if ( regbl_latest == 0 )

                    % detect latest map %
                    regbl_latest = regbl_date( regbl_i );

                end

                % detect oldest map %
                regbl_oldest = regbl_date( regbl_i );

            end

        end

    end
