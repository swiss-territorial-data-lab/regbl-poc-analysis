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

    function regbl_poc_analysis_reference( regbl_storage_path, regbl_export_file )

        % create listing %
        regbl_list = dir( [ regbl_storage_path '/regbl_output/output_reference/*' ] );

        % create exportation stream %
        regbl_stream = fopen( regbl_export_file, 'w' );

        % parsing listing %
        for regbl_i = 1 : size( regbl_list, 1 )

            % export egid %
            fprintf( regbl_stream, '%s\n', regbl_list( regbl_i ).name );

        end

        % delete stream %
        fclose( regbl_stream );

    end
