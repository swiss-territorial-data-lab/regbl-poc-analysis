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
            if ( ( regbl_deduce(1) != regbl_oldest ) && ( regbl_deduce(2) != regbl_latest ) )

                % compute position %
                regbl_position = 0.5 * ( regbl_deduce(1) + regbl_deduce(2) );

                % export position value %
                fprintf( regbl_stream, "%i %f\n", regbl_list( regbl_i ), regbl_position );

            end

        end

        % delete output stream %
        fclose( regbl_stream );

    end
