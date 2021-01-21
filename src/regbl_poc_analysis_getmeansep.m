
    function regbl_meansep = regbl_poc_analysis_getmeansep( regbl_database, regbl_location_name )

        % initialise values %
        regbl_meansep = 0;

        % initialise counter %
        regbl_count = 0;

        % initialise flag %
        regbl_last = 0;

        % retrive storage main database %
        [ regbl_name regbl_date regbl_xl regbl_xh regbl_yl regbl_yh ] = textread( regbl_database, '%s %d %d %d %d %d');

        % search for most ancient map %
        for regbl_i = 1 : size( regbl_name, 1 )

            % check location %
            if ( strcmp( regbl_name( regbl_i ), regbl_location_name ) == 1 )

                % check last %
                if ( regbl_last > 0 ) 

                    % push gap %
                    regbl_meansep = regbl_meansep + ( regbl_last - regbl_date( regbl_i ) );

                    % update counter %
                    regbl_count = regbl_count + 1;

                end

                % udpate last %
                regbl_last = regbl_date( regbl_i );

            end

        end

        % compute mean value %
        regbl_meansep = regbl_meansep / regbl_count;

    end
