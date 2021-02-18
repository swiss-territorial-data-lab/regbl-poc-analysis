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

    function regbl_poc_analysis_todsv( regbl_storage_path, regbl_output_dsv )

        % create egid listing %
        regbl_list = dir( [ regbl_storage_path '/regbl_output/output_deduce/*' ] );

        % create output stream %
        regbl_stream = fopen( regbl_output_dsv, 'w' );

        % export DSV header %
        fprintf( regbl_stream, 'EGID\tGBAUJ_STDL_LOW\tGBAUJ_STDL_HIGH\n' );

        % parsing EGID list %
        for i = 1 : size( regbl_list, 1 )

            % import detector deduction %
            regbl_deduce = dlmread( [ regbl_storage_path '/regbl_output/output_deduce/' regbl_list(i).name ] );

            % export EGID column entry %
            fprintf( regbl_stream, '%s\t', regbl_list(i).name );

            % check map boundaries %
            if ( regbl_deduce(2) == -32768 )

                % export low range column entry %
                fprintf( regbl_stream, '\t' );

            else

                % export low range column entry %
                fprintf( regbl_stream, '%i\t', regbl_deduce(2) );

            end

            % check map boundaries %
            if ( regbl_deduce(1) == 32767 )

                % export high range column entry %
                fprintf( regbl_stream, '\n' );

            else

                % export high range column entry %
                fprintf( regbl_stream, '%i\n', regbl_deduce(1) );

            end

        end

        % delete output stream %
        fclose( regbl_stream );

    end

