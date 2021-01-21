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

    function regbl_poc_analysis_potential( regbl_storage_path, regbl_max_count = 50, regbl_prec = 10 )

        % extract maps boundaries %
        [ regbl_oldest regbl_latest ] = regbl_poc_analysis_bounds( regbl_storage_path );

        % create reference listing %
        regbl_list = dir( [ regbl_storage_path '/regbl_output/output_reference/*' ] );

        % shuffle list %
        regbl_list = regbl_list( randperm( length( regbl_list ) ) );

        % create exportation directory %
        mkdir( [ regbl_storage_path '/regbl_analysis/analysis_potential' ] );

        % create output stream %
        regbl_stream = fopen( [ regbl_storage_path '/regbl_analysis/analysis_potential/potential' ], 'w' );

        % initialise histogram %
        regbl_hist = zeros( 204, 1 );

        % initialise histogram extremum %
        regbl_old_hist = 0;
        regbl_lat_hist = 0;

        % initialise index %
        regbl_j = 0;

        % parsing listing %
        for regbl_i = 1 : size( regbl_list, 1 )

            % import reference date %
            regbl_reference = dlmread( [ regbl_storage_path '/regbl_output/output_reference/' regbl_list(regbl_i).name ] );

            % reset exportation flag %
            regbl_flag = false;

            % case study %
            if ( regbl_reference > regbl_latest )

                % check histogram %
                if ( regbl_lat_hist < regbl_max_count )

                    % update flag %
                    regbl_flag = true;

                    % update histogram %
                    regbl_lat_hist = regbl_lat_hist + 1;

                end

            elseif ( regbl_reference < regbl_oldest )

                % check histogram %
                if ( regbl_old_hist < regbl_max_count )

                    % update flag %
                    regbl_flag = true;

                    % update histogram %
                    regbl_old_hist = regbl_old_hist + 1;

                end

            else

                % compute histogram index %
                regbl_index = fix( regbl_reference / regbl_prec );

                % check histogram %
                if ( regbl_hist(regbl_index) < regbl_max_count )

                    % update flag %
                    regbl_flag = true;

                    % update histogram %
                    regbl_hist(regbl_index) = regbl_hist(regbl_index) + 1;

                end


            end

            % check exportation flag %
            if ( regbl_flag == true )

                % export egid name %
                fprintf( regbl_stream, '%s\n', regbl_list(regbl_i).name );

            end

        end

        % delete stream %
        fclose( regbl_stream );

    end

